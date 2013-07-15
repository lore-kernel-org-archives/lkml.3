Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933240Ab3GOQ6a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 12:58:30 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:59540 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932443Ab3GOQz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 12:55:59 -0400
Message-ID: <51E4299C.3080905@gmail.com>
Date: Mon, 15 Jul 2013 09:55:56 -0700
From: David Daney <ddaney.cavm@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Ramkumar Ramachandra <artagnon@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>, David Daney <david.daney@cavium.com>,
        Michal Marek <mmarek@suse.cz>
Subject: Re: [PATCH] scripts: remove unused function in sortextable.c
References: <1373479418-7079-1-git-send-email-artagnon@gmail.com>
In-Reply-To: <1373479418-7079-1-git-send-email-artagnon@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/10/2013 11:03 AM, Ramkumar Ramachandra wrote:
> Cc: David Daney <david.daney@cavium.com>
> Cc: Michal Marek <mmarek@suse.cz>
> Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>

I haven't tested it, but it looks plausible.

Acked-by: David Daney <david.daney@cavium.com>


> ---
>   Trivial.  I wonder why make didn't tell us?
>
>   scripts/sortextable.c | 8 --------
>   1 file changed, 8 deletions(-)
>
> diff --git a/scripts/sortextable.c b/scripts/sortextable.c
> index f9ce116..7c2310c 100644
> --- a/scripts/sortextable.c
> +++ b/scripts/sortextable.c
> @@ -64,14 +64,6 @@ fail_file(void)
>   	longjmp(jmpenv, SJ_FAIL);
>   }
>
> -static void __attribute__((noreturn))
> -succeed_file(void)
> -{
> -	cleanup();
> -	longjmp(jmpenv, SJ_SUCCEED);
> -}
> -
> -
>   /*
>    * Get the whole file as a programming convenience in order to avoid
>    * malloc+lseek+read+free of many pieces.  If successful, then mmap
>

