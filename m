Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751686AbaKGPQP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 10:16:15 -0500
Received: from mail-pd0-f178.google.com ([209.85.192.178]:45084 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919AbaKGPQM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 10:16:12 -0500
Message-ID: <545CE239.6050205@gmail.com>
Date: Fri, 07 Nov 2014 08:16:09 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
CC: Hemant Kumar <hemant@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        linux-kernel@vger.kernel.org, srikar@linux.vnet.ibm.com,
        oleg@redhat.com, hegdevasant@linux.vnet.ibm.com, mingo@redhat.com,
        systemtap@sourceware.org, aravinda@linux.vnet.ibm.com, penberg@iki.fi,
        brendan.d.gregg@gmail.com,
        "yrl.pp-manager.tt@hitachi.com" <yrl.pp-manager.tt@hitachi.com>
Subject: Re: [RFC] perf-cache command interface design
References: <20141102105006.21708.28734.stgit@hemant-fedora> <20141102105557.21708.19032.stgit@hemant-fedora> <87lhnr5sbl.fsf@sejong.aot.lge.com> <54588905.7040002@linux.vnet.ibm.com> <5458CD15.4010101@hitachi.com> <874muew2hk.fsf@sejong.aot.lge.com> <5459E865.6050207@hitachi.com> <545B1DDE.9000202@linux.vnet.ibm.com> <545C80F4.4020905@hitachi.com> <20141107084211.GC23531@worktop.programming.kicks-ass.net>
In-Reply-To: <20141107084211.GC23531@worktop.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/7/14, 1:42 AM, Peter Zijlstra wrote:
> On Fri, Nov 07, 2014 at 05:21:08PM +0900, Masami Hiramatsu wrote:
>> The paths of buildid cache of binary/symbols are not changed.
>
> Could we get an option in .perfconfig to disable the buildid cache? Its
> pointless diskspace wastage for some of us.

I was going to respond with the same. This:

[buildid]
    # Default, disable using /dev/null
    dir = /dev/null

disables the build-id cache. Hopefully that extends to all the other 
caches getting discussed.

David
