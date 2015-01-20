Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754725AbbATMmx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 07:42:53 -0500
Received: from www.linutronix.de ([62.245.132.108]:48463 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752298AbbATMmw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 07:42:52 -0500
Date: Tue, 20 Jan 2015 13:42:33 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Borislav Petkov <bp@suse.de>
cc: x86-ml <x86@kernel.org>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] x86 cleanups for 3.20
In-Reply-To: <20150113141255.GB5784@pd.tnic>
Message-ID: <alpine.DEB.2.11.1501201340421.5526@nanos>
References: <20150113141255.GB5784@pd.tnic>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Jan 2015, Borislav Petkov wrote:

> Hi guys,
> 
> here just a bunch of minor cleanups for 3.20.
> 
> Please pull,
> thanks.
> 
> ---
> The following changes since commit b1940cd21c0f4abdce101253e860feff547291b0:
> 
>   Linux 3.19-rc3 (2015-01-05 17:05:20 -0800)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git tags/x86_queue
> 
> for you to fetch changes up to b34630014dad0ba69aadd8deb231ddc6d2efcf53:
> 
>   x86, early_serial_console: Remove unnecessary check (2015-01-13 12:14:44 +0100)
> 
> ----------------------------------------------------------------
> Minor cleanups.
> 
> ----------------------------------------------------------------
> Alexander Kuleshov (3):
>       x86, setup: Rename BOOT_ISDIGIT_H to BOOT_CTYPE_H
>       x86, early_serial_console: Remove unused macro XMTRDY

This one is equally pointless as the other two which remove a few more
defines. Can you please zap that and resend the pull request?

Thanks,

	tglx
