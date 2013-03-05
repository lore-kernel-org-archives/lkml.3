Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757118Ab3CEQRP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 11:17:15 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33882 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756506Ab3CEQRO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 11:17:14 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <1362484056-9778-6-git-send-email-kyungsik.lee@lge.com>
References: <1362484056-9778-1-git-send-email-kyungsik.lee@lge.com> <1362484056-9778-6-git-send-email-kyungsik.lee@lge.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3 -next 5/5] Kconfig: Make x86 and arm kernels default to the LZ4-compressed
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Tue, 05 Mar 2013 08:13:06 -0800
To: Kyungsik Lee <kyungsik.lee@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org, x86@kernel.org,
        celinux-dev@lists.celinuxforum.org
CC: Nicolas Pitre <nico@fluxnic.net>, David Sterba <dsterba@suse.cz>,
        Nitin Gupta <nitingupta910@gmail.com>,
        Joe Millenbach <jmillenbach@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Michal Marek <mmarek@suse.cz>,
        hyojun.im@lge.com, chan.jeong@lge.com, raphael.andy.lee@gmail.com
Message-ID: <951ecce5-9669-4d1e-97db-1d1946e83eb4@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm ok with this only if the patch is clearly marked LINUS DO NOT MERGE.

Kyungsik Lee <kyungsik.lee@lge.com> wrote:

>This patch makes x86 and arm kernels default to the LZ4-compressed
>to test new LZ4 code in the linux-next. This is requested by
>Andrew Morton.
>
>Signed-off-by: Kyungsik Lee <kyungsik.lee@lge.com>
>---
> init/Kconfig | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
>diff --git a/init/Kconfig b/init/Kconfig
>index fc8eb1f..de3cb00 100644
>--- a/init/Kconfig
>+++ b/init/Kconfig
>@@ -138,7 +138,7 @@ config HAVE_KERNEL_LZ4
> 
> choice
> 	prompt "Kernel compression mode"
>-	default KERNEL_GZIP
>+	default KERNEL_LZ4
>	depends on HAVE_KERNEL_GZIP || HAVE_KERNEL_BZIP2 || HAVE_KERNEL_LZMA
>|| HAVE_KERNEL_XZ || HAVE_KERNEL_LZO || HAVE_KERNEL_LZ4
> 	help
> 	  The linux kernel is a kind of self-extracting executable.

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
