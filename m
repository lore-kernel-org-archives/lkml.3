Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753945Ab3CEL6M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 06:58:12 -0500
Received: from mail.skyhub.de ([78.46.96.112]:35867 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752558Ab3CEL6J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 06:58:09 -0500
Date: Tue, 5 Mar 2013 12:58:07 +0100
From: Borislav Petkov <bp@alien8.de>
To: Kyungsik Lee <kyungsik.lee@lge.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Russell King <linux@arm.linux.org.uk>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        x86@kernel.org, celinux-dev@lists.celinuxforum.org,
        Nicolas Pitre <nico@fluxnic.net>, David Sterba <dsterba@suse.cz>,
        Nitin Gupta <nitingupta910@gmail.com>,
        Joe Millenbach <jmillenbach@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Michal Marek <mmarek@suse.cz>,
        hyojun.im@lge.com, chan.jeong@lge.com, raphael.andy.lee@gmail.com
Subject: Re: [PATCH v3 -next 5/5] Kconfig: Make x86 and arm kernels default
 to the LZ4-compressed
Message-ID: <20130305115807.GC4914@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Kyungsik Lee <kyungsik.lee@lge.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Russell King <linux@arm.linux.org.uk>,
	"H. Peter Anvin" <hpa@zytor.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-kbuild@vger.kernel.org, x86@kernel.org,
	celinux-dev@lists.celinuxforum.org,
	Nicolas Pitre <nico@fluxnic.net>, David Sterba <dsterba@suse.cz>,
	Nitin Gupta <nitingupta910@gmail.com>,
	Joe Millenbach <jmillenbach@gmail.com>,
	Thomas Gleixner <tglx@linutronix.de>, Michal Marek <mmarek@suse.cz>,
	hyojun.im@lge.com, chan.jeong@lge.com, raphael.andy.lee@gmail.com
References: <1362484056-9778-1-git-send-email-kyungsik.lee@lge.com>
 <1362484056-9778-6-git-send-email-kyungsik.lee@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1362484056-9778-6-git-send-email-kyungsik.lee@lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 05, 2013 at 08:47:36PM +0900, Kyungsik Lee wrote:
> This patch makes x86 and arm kernels default to the LZ4-compressed
> to test new LZ4 code in the linux-next. This is requested by
> Andrew Morton.
> 
> Signed-off-by: Kyungsik Lee <kyungsik.lee@lge.com>
> ---
>  init/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/init/Kconfig b/init/Kconfig
> index fc8eb1f..de3cb00 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -138,7 +138,7 @@ config HAVE_KERNEL_LZ4
>  
>  choice
>  	prompt "Kernel compression mode"
> -	default KERNEL_GZIP
> +	default KERNEL_LZ4

Do I understand it correctly that when this thing gets committed, kernel
builds on all systems missing the lz4 tool will fail and everybody
should go running to get it so that everybody can build kernels again?

WTF?

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
