Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752367AbbAMLTp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 06:19:45 -0500
Received: from www.linutronix.de ([62.245.132.108]:44082 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752339AbbAMLTn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 06:19:43 -0500
Date: Tue, 13 Jan 2015 12:19:20 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Alexander Kuleshov <kuleshovmail@gmail.com>
cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86/boot/video-mode: Fix video-mode.c path in comment
In-Reply-To: <1420483029-14454-1-git-send-email-kuleshovmail@gmail.com>
Message-ID: <alpine.DEB.2.11.1501131218150.5526@nanos>
References: <1420483029-14454-1-git-send-email-kuleshovmail@gmail.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Jan 2015, Alexander Kuleshov wrote:

> Signed-off-by: Alexander Kuleshov <kuleshovmail@gmail.com>
> ---
>  arch/x86/boot/video-mode.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/boot/video-mode.c b/arch/x86/boot/video-mode.c
> index 748e8d0..74338d5 100644
> --- a/arch/x86/boot/video-mode.c
> +++ b/arch/x86/boot/video-mode.c
> @@ -9,7 +9,7 @@
>   * ----------------------------------------------------------------------- */
>  
>  /*
> - * arch/i386/boot/video-mode.c
> + * arch/x86/boot/video-mode.c

We rather remove that completely as it does not contain any useful
information.

Thanks,

	tglx
