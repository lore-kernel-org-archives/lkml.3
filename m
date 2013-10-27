Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754860Ab3J0UmT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Oct 2013 16:42:19 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:41775 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753542Ab3J0UmR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Oct 2013 16:42:17 -0400
Date: Sun, 27 Oct 2013 20:42:12 +0000
From: Matt Fleming <matt@console-pimps.org>
To: linux-efi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Matt Fleming <matt.fleming@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Tony Luck <tony.luck@intel.com>,
        Leif Lindholm <leif.lindholm@linaro.org>
Subject: Re: [PATCH 1/2] efi: Add asm-generic/efi.h for non-x86
Message-ID: <20131027204212.GF1982@console-pimps.org>
References: <1382012355-8846-1-git-send-email-matt@console-pimps.org>
 <1382012355-8846-2-git-send-email-matt@console-pimps.org>
 <20131017141653.GJ10834@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131017141653.GJ10834@console-pimps.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Oct, at 03:16:53PM, Matt Fleming wrote:
> After reading Leif's arm runtime patches this patch obviously doesn't
> make much sense. I'll work on something better.

OK, since Leif's stuff needs to go through another revision, I'm gonna
leave these patches as-is and merge them into the 'next' branch. I'll
throw some patches at Leif to move efi_enabled() to common code to
include in his series.

-- 
Matt Fleming, Intel Open Source Technology Center
