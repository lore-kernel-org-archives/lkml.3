Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756579Ab3JNN3I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 09:29:08 -0400
Received: from mail.skyhub.de ([78.46.96.112]:39265 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756104Ab3JNN3E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 09:29:04 -0400
Date: Mon, 14 Oct 2013 15:28:53 +0200
From: Borislav Petkov <bp@alien8.de>
To: Chen Gong <gong.chen@linux.intel.com>
Cc: tony.luck@intel.com, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH 3/8] ACPI, x86: Extended error log driver for x86 platform
Message-ID: <20131014132853.GH4009@pd.tnic>
References: <1381473166-29303-1-git-send-email-gong.chen@linux.intel.com>
 <1381473166-29303-4-git-send-email-gong.chen@linux.intel.com>
 <20131011152451.GF5925@pd.tnic>
 <20131014031633.GA12189@gchen.bj.intel.com>
 <20131014102635.GC4009@pd.tnic>
 <20131014130311.GA1695@gchen.bj.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20131014130311.GA1695@gchen.bj.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 14, 2013 at 09:03:11AM -0400, Chen Gong wrote:
> This kind of mask is often unsigned. So how about following mode:
> 
> GENMASKL / GENMASKQ
> or
> GENMASK_L / GENMASK_Q

Right, I think the "_ULL" thing is more accepted in the kernel, see
DIV_ROUND_UP{,_ULL}. Also, Joe had a patch to convert BIT to that
scheme too:

https://lkml.org/lkml/2013/9/19/307

There are macros with "_Q" but it does not necessarily mean Quadword but
something else like queues and stuff.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
