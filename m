Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757888AbaDWTA0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 15:00:26 -0400
Received: from mail.skyhub.de ([78.46.96.112]:40830 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756122AbaDWTAV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 15:00:21 -0400
Date: Wed, 23 Apr 2014 21:00:15 +0200
From: Borislav Petkov <bp@alien8.de>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        venkateshs@google.com, ak@linux.intel.com, zheng.z.yan@intel.com
Subject: Re: [PATCH] perf/x86: fix RAPL rdmsrl_safe() usage
Message-ID: <20140423190015.GF25378@pd.tnic>
References: <20140423170418.GA12767@quad>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140423170418.GA12767@quad>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 23, 2014 at 07:04:19PM +0200, Stephane Eranian wrote:
> 
> This patch fixes a bug introduced by commit 24223657.

Maybe add

Fixes: <commit-id>

tag?

> The rdmsrl_safe() function returns 0 on success.
> The current code was failing to detect the RAPL PMU
> on real hardware  (missing /sys/devices/power) because
> the return value of rdmsrl_safe() was misinterpreted.
> 
> Signed-off-by: Stephane Eranian <eranian@google.com>

Acked-by: Borislav Petkov <bp@suse.de>

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
