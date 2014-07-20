Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756317AbaGTDRy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2014 23:17:54 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:35026 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752701AbaGTDRx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2014 23:17:53 -0400
Message-ID: <53CB34D9.8090807@hitachi.com>
Date: Sun, 20 Jul 2014 12:17:45 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
Cc: Hemant Kumar <hemant@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        srikar@linux.vnet.ibm.com, peterz@infradead.org, oleg@redhat.com,
        hegdevasant@linux.vnet.ibm.com, mingo@redhat.com, anton@redhat.com,
        systemtap@sourceware.org, namhyung@kernel.org,
        aravinda@linux.vnet.ibm.com, penberg@iki.fi
Subject: Re: [PATCH v2 1/3] perf/sdt : Listing of SDT markers by perf
References: <20140717054826.19995.61782.stgit@hemant-fedora> <20140717055341.19995.97042.stgit@hemant-fedora> <87d2d24kui.fsf@tassilo.jf.intel.com>
In-Reply-To: <87d2d24kui.fsf@tassilo.jf.intel.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/07/19 2:50), Andi Kleen wrote:
> Hemant Kumar <hemant@linux.vnet.ibm.com> writes:
> 
> First I should say supporting these probes is very useful. Thanks for
> working on this.
> 
>> +
>> +#define SDT_CACHE_DIR "/var/cache/perf/"
> 
> This requires running perf as root, right?
> 
> It would be better to use the $HOME cache dir, like the recent JSON patches.

Even though, we have to enhance uprobe-tracer that allows non-root user
to add/remove events. :)
Anyway, I guess we can use ~/.debug for this purpose as buildid-cache does.

Thank you,


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


