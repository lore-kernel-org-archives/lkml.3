Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751865AbaL3VgQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 16:36:16 -0500
Received: from mail.skyhub.de ([78.46.96.112]:38115 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751574AbaL3VgP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 16:36:15 -0500
Date: Tue, 30 Dec 2014 22:36:12 +0100
From: Borislav Petkov <bp@alien8.de>
To: Alexander Kuleshov <kuleshovmail@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] x86/boot/early_serial_console: Remove unnecessary
 check
Message-ID: <20141230213612.GA9238@pd.tnic>
References: <1419963538-19275-1-git-send-email-kuleshovmail@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1419963538-19275-1-git-send-email-kuleshovmail@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 31, 2014 at 12:18:58AM +0600, Alexander Kuleshov wrote:
> There is already the same check before.
> 
> Signed-off-by: Alexander Kuleshov <kuleshovmail@gmail.com>
> ---
>  arch/x86/boot/early_serial_console.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/boot/early_serial_console.c b/arch/x86/boot/early_serial_console.c
> index 5df2869..c23bcae 100644
> --- a/arch/x86/boot/early_serial_console.c
> +++ b/arch/x86/boot/early_serial_console.c
> @@ -73,9 +73,8 @@ static void parse_earlyprintk(void)
>  		} else if (!strncmp(arg + pos, "ttyS", 4)) {
>  			static const int bases[] = { 0x3f8, 0x2f8 };
>  			int idx = 0;
> -

You've removed the newline here and we usually do leave an empty line
between the function local variables declarations and the rest of the
function for better readability.

And to answer your question from earlier: yes, if you want to send a
corrected patch, please do send it as a reply to this one.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
