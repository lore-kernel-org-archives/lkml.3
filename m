Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753510AbaKCUbL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 15:31:11 -0500
Received: from www.linutronix.de ([62.245.132.108]:55362 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752335AbaKCUbH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 15:31:07 -0500
Date: Mon, 3 Nov 2014 21:31:01 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andy Lutomirski <luto@amacapital.net>
cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Josh Triplett <josh@joshtriplett.org>, Ingo Molnar <mingo@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [PATCH v2 2/3] x86_64,vsyscall: Rewrite comment and clean up
 headers in vsyscall code
In-Reply-To: <9c448d5643d0fdb618f8cde9a54c21d2bcd486ce.1414618407.git.luto@amacapital.net>
Message-ID: <alpine.DEB.2.11.1411032124350.5308@nanos>
References: <cover.1414618407.git.luto@amacapital.net> <9c448d5643d0fdb618f8cde9a54c21d2bcd486ce.1414618407.git.luto@amacapital.net>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Oct 2014, Andy Lutomirski wrote:

> vsyscall_64.c is just vsyscall emulation.  Tidy it up accordingly.
> 
> If my comment editing offends anyone, let me know and I can fix it.
> 
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>
> Signed-off-by: Andy Lutomirski <luto@amacapital.net>
> ---
>  arch/x86/kernel/vsyscall_64.c | 51 +++++++++++++++----------------------------
>  1 file changed, 18 insertions(+), 33 deletions(-)
> 
> diff --git a/arch/x86/kernel/vsyscall_64.c b/arch/x86/kernel/vsyscall_64.c
> index 2d912629c96e..ee622f8183f3 100644
> --- a/arch/x86/kernel/vsyscall_64.c
> +++ b/arch/x86/kernel/vsyscall_64.c
> @@ -1,52 +1,37 @@
>  /*
> - *  Copyright (C) 2001 Andrea Arcangeli <andrea@suse.de> SuSE
> - *  Copyright 2003 Andi Kleen, SuSE Labs.
> + * Mostly copyright (c) 2012-2014 Andy Lutomirski <luto@amacapital.net>

We usualy leave the old copyright notices around even if the code
which is related to them has been removed more or less completely.

So I change this to:

/*
 * Copyright (c) 2012-2014 Andy Lutomirski <luto@amacapital.net>
 *
 * Based on the original implementation:
 *  Copyright (C) 2001 Andrea Arcangeli <andrea@suse.de> SuSE
 *  Copyright 2003 Andi Kleen, SuSE Labs.

and apply the whole lot.

Thanks,

	tglx

