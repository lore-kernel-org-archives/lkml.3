Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755467AbaIQMbH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 08:31:07 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:60968 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754692AbaIQMbG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 08:31:06 -0400
Date: Wed, 17 Sep 2014 14:31:00 +0200
From: Ingo Molnar <mingo@kernel.org>
To: "David E. Box" <david.e.box@linux.intel.com>
Cc: hpa@zytor.com, tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] x86: iosf: Move Kconfig to proper submenu
Message-ID: <20140917123100.GD2704@gmail.com>
References: <1409175640-32426-1-git-send-email-david.e.box@linux.intel.com>
 <1410924386-16977-3-git-send-email-david.e.box@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410924386-16977-3-git-send-email-david.e.box@linux.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David E. Box <david.e.box@linux.intel.com> wrote:

> Moves Kconfig option to "Processor type and features" menu from main
> configuration menu.
> 
> Signed-off-by: David E. Box <david.e.box@linux.intel.com>
> ---
>  arch/x86/Kconfig | 29 ++++++++++++++---------------
>  1 file changed, 14 insertions(+), 15 deletions(-)
> 
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index bcbb57d..2db4b1d 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -480,6 +480,20 @@ config X86_INTEL_LPSS
>  	  things like clock tree (common clock framework) and pincontrol
>  	  which are needed by the LPSS peripheral drivers.
>  
> +config IOSF_MBI
> +	tristate "Intel System On Chip IOSF Sideband support"
> +	depends on PCI
> +	---help---
> +	  Enables sideband access to mailbox registers on SoC's. The sideband is
> +	  available on the following platforms. This list is not meant to be
> +	  exclusive.
> +	   - BayTrail
> +	   - Braswell
> +	   - Quark
> +
> +	  You should say Y if you are running a kernel on one of these
> +	  platforms.

What this help text does not tell us is why such sideband access 
is useful, why the user should enable it.

Thanks,

	Ingo
