Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754761AbaGUWAl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 18:00:41 -0400
Received: from mail-lb0-f176.google.com ([209.85.217.176]:58664 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751052AbaGUWAk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 18:00:40 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.11.1407210110550.31021@titan.int.lan.stealer.net>
References: <alpine.LNX.2.11.1407210110550.31021@titan.int.lan.stealer.net>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 21 Jul 2014 15:00:18 -0700
Message-ID: <CALCETrW=fRmWXGHoie13KQ7tKbwsqjb81ApCDNL32Qr0U+Zu_w@mail.gmail.com>
Subject: Re: [PATCH] x86_32, entry: fix sysenter_badsys END symbol
To: Sven Wegener <sven.wegener@stealer.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 20, 2014 at 4:13 PM, Sven Wegener <sven.wegener@stealer.net> wrote:
> Signed-off-by: Sven Wegener <sven.wegener@stealer.net>
> Cc: Andy Lutomirski <luto@amacapital.net>

Acked-by: Andy Lutomirski <luto@amacapital.net>

> ---
>  arch/x86/kernel/entry_32.S | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
> index 793f6c9..0958f2b 100644
> --- a/arch/x86/kernel/entry_32.S
> +++ b/arch/x86/kernel/entry_32.S
> @@ -682,7 +682,7 @@ END(syscall_badsys)
>  sysenter_badsys:
>         movl $-ENOSYS,%eax
>         jmp sysenter_after_call
> -END(syscall_badsys)
> +END(sysenter_badsys)
>         CFI_ENDPROC
>
>  .macro FIXUP_ESPFIX_STACK



-- 
Andy Lutomirski
AMA Capital Management, LLC
