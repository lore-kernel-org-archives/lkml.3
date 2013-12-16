Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754046Ab3LPNeY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 08:34:24 -0500
Received: from mail-ee0-f44.google.com ([74.125.83.44]:59762 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752803Ab3LPNeW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 08:34:22 -0500
Date: Mon, 16 Dec 2013 14:34:17 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Borislav Petkov <bp@suse.de>
Cc: x86-ml <x86@kernel.org>, Tony Luck <tony.luck@intel.com>,
        linux-edac <linux-edac@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [GIT PULL] RAS for 3.14
Message-ID: <20131216133417.GA2460@gmail.com>
References: <20131214101144.GA21353@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131214101144.GA21353@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Borislav Petkov <bp@suse.de> wrote:

> Hi guys,
> 
> please queue for 3.14.
> 
> Thanks.
> 
> --
> The following changes since commit dc1ccc48159d63eca5089e507c82c7d22ef60839:
> 
>   Linux 3.13-rc2 (2013-11-29 12:57:14 -0800)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git tags/ras_for_3.14
> 
> for you to fetch changes up to 42139eb356e3384759ca143ae04d82376346eb4c:
> 
>   ACPI, eMCA: Combine eMCA/EDAC event reporting priority (2013-12-11 19:04:37 +0100)
> 
> ----------------------------------------------------------------
> * Add the functionality to override error reporting agents as some
> machines are sporting a new extended error logging capability which, if
> done properly in the BIOS, makes a corresponding EDAC module redundant,
> from Gong Chen.
> 
> * PCIe AER tracepoint severity levels fix, from Rui Wang.
> 
> * Error path correction for the mce device init, from Levente Kurusa.
> 
> ----------------------------------------------------------------
> Chen, Gong (3):
>       EDAC: Add an edac_report parameter to EDAC
>       EDAC, sb_edac: Modify H/W event reporting policy
>       ACPI, eMCA: Combine eMCA/EDAC event reporting priority
> 
> Levente Kurusa (1):
>       x86, mce: Call put_device on device_register failure
> 
> Rui Wang (1):
>       PCI, AER: Fix severity usage in aer trace event
> 
>  Documentation/kernel-parameters.txt |  8 ++++++++
>  arch/x86/kernel/cpu/mcheck/mce.c    |  4 +++-
>  drivers/acpi/acpi_extlog.c          | 18 ++++++++++++++++--
>  drivers/edac/edac_stub.c            | 19 +++++++++++++++++++
>  drivers/edac/sb_edac.c              |  6 +++++-
>  include/linux/edac.h                | 28 ++++++++++++++++++++++++++++
>  include/trace/events/ras.h          | 10 +++++-----
>  7 files changed, 84 insertions(+), 9 deletions(-)

Pulled into tip:x86/ras, thanks Boris!

	Ingo
