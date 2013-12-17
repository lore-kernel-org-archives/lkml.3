Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754547Ab3LQQK2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 11:10:28 -0500
Received: from mail-ea0-f179.google.com ([209.85.215.179]:34558 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752536Ab3LQQK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 11:10:27 -0500
Date: Tue, 17 Dec 2013 17:10:22 +0100
From: Ingo Molnar <mingo@kernel.org>
To: "Yan, Zheng" <zheng.z.yan@intel.com>
Cc: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, eranian@google.com,
        andi@firstfloor.org, Arnaldo Carvalho de Melo <acme@infradead.org>
Subject: Re: [PATCH 04/15] perf, x86: Use context switch callback to flush
 LBR stack
Message-ID: <20131217161022.GA13205@gmail.com>
References: <1386745860-21143-1-git-send-email-zheng.z.yan@intel.com>
 <1386745860-21143-5-git-send-email-zheng.z.yan@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386745860-21143-5-git-send-email-zheng.z.yan@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yan, Zheng <zheng.z.yan@intel.com> wrote:

> From: "Yan, Zheng" <zheng.z.yan@intel.com>
> 
> Enable pmu context switch callback if LBR is used. Use the callback
> to flush LBR stack when process is scheduled in.
> 
> Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>

I see several fundamental problems with your series:

1)

Minimal changelogs like the ones in this series are completely 
unacceptable! You seem to be copying the changelog style of Andi 
Kleen: written to inform as little as possible.

Don't do that if you want your patches to get anywhere, instead adapt 
the akpm style:

 "Please update the changelog to describe the current behavior.

  Please also describe why you think that behavior should be changed.
  ie: what's the reason for this patch.
 "

2)

Also, there are frequent typos.

3)

Plus you didn't Cc: other perf maintainers like myself or Arnaldo.

4)

How can users actually make use of the changes you are doing? Cite 
actual perf analysis usecases in the 0/15 description and describe how 
your patches improve/enable all that.

Please fix all those problems and resend.

Thanks,

	Ingo
