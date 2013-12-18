Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752218Ab3LRJv2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 04:51:28 -0500
Received: from mail-ea0-f169.google.com ([209.85.215.169]:60487 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751016Ab3LRJvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 04:51:25 -0500
Date: Wed, 18 Dec 2013 10:51:21 +0100
From: Ingo Molnar <mingo@kernel.org>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: linux-kernel@vger.kernel.org, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [GIT PULL] Update to error injection interface
Message-ID: <20131218095121.GA19319@gmail.com>
References: <52b0eda116006e30e1@agluck-desk.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52b0eda116006e30e1@agluck-desk.sc.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Luck, Tony <tony.luck@intel.com> wrote:

> Ingo,
> 
> Please queue in x86/ras branch for next merge window.
> 
> Thanks
> 
> -Tony
> 
> The following changes since commit 319e2e3f63c348a9b66db4667efa73178e18b17d:
> 
>   Linux 3.13-rc4 (2013-12-15 12:31:33 -0800)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/ras/ras.git tags/please-pull-einj
> 
> for you to fetch changes up to 3482fb5e0c1c20ce0dbcfc5ca3b6558a8c455b10:
> 
>   ACPI, APEI, EINJ: Changes to the ACPI/APEI/EINJ debugfs interface (2013-12-17 16:04:22 -0800)
> 
> ----------------------------------------------------------------
> Add more flexibility to debugfs i/f to error injection (EINJ)
> 
> ----------------------------------------------------------------
> Tony Luck (1):
>       ACPI, APEI, EINJ: Changes to the ACPI/APEI/EINJ debugfs interface
> 
>  Documentation/acpi/apei/einj.txt | 19 ++++++++++++++++++-
>  drivers/acpi/apei/einj.c         | 39 ++++++++++++++++++++++++++++++++++-----
>  2 files changed, 52 insertions(+), 6 deletions(-)

Pulled, thanks Tony!

	Ingo
