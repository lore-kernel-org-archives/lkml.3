Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755133Ab3JYPUV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 11:20:21 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:50763 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754705Ab3JYPUR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 11:20:17 -0400
Message-ID: <526A8C2B.7000401@gmail.com>
Date: Fri, 25 Oct 2013 09:20:11 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Pekka Enberg <penberg@iki.fi>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
CC: Pekka Enberg <penberg@kernel.org>,
        Hemant Kumar <hkshaw@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        "hegdevasant@linux.vnet.ibm.com" <hegdevasant@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@redhat.com>, "anton@redhat.com" <anton@redhat.com>,
        "systemtap@sourceware.org" <systemtap@sourceware.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "aravinda@linux.vnet.ibm.com" <aravinda@linux.vnet.ibm.com>
Subject: Re: [PATCH v4 2/3] Support for perf to probe into SDT markers:
References: <20131023044511.1886.82571.stgit@hemant-fedora> <20131023050502.1886.15779.stgit@hemant-fedora> <CAOJsxLFKm3TxeTmGjbpr1r4sZ8fHcM481-5BM_Cq0J8hhtvBqQ@mail.gmail.com> <20131025125921.GA29424@linux.vnet.ibm.com> <F53BA283-A194-4057-8409-27FD3ECFDF2E@iki.fi>
In-Reply-To: <F53BA283-A194-4057-8409-27FD3ECFDF2E@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/25/13 8:20 AM, Pekka Enberg wrote:
>> Technically feasible. But then we would have to parse each of the
>> libraries and executables to list them. Right? I am not sure if such a
>> delay is acceptable.
>
> You could do it at 'perf list' time or even build time and cache it. And add lazy discovery to 'perf record' and friends.

Instead searching all the known files or building a cache, how about 
just having an option like: perf list <DSO>. perf-record could still do 
the probe magic behind the scenes.

David
