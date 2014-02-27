Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753434AbaB0QP6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 11:15:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42614 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751500AbaB0QP5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 11:15:57 -0500
Date: Thu, 27 Feb 2014 17:14:01 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Rashika Kheria <rashika.kheria@gmail.com>
Cc: linux-kernel@vger.kernel.org, Jason Wessel <jason.wessel@windriver.com>,
        Vincent <vincent.stehle@laposte.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Kees Cook <keescook@chromium.org>,
        Tejun Heo <tj@kernel.org>, Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        Emese Revfy <re.emese@gmail.com>, Andrey Vagin <avagin@openvz.org>,
        Jesper Derehag <jderehag@hotmail.com>,
        Vineet Gupta <vgupta@synopsys.com>,
        kgdb-bugreport@lists.sourceforge.net, josh@joshtriplett.org
Subject: Re: [PATCH 05/46] kernel: Include appropriate header file in
	kernel/signal.c
Message-ID: <20140227161401.GA32685@redhat.com>
References: <7b4a60c74ced00e0d65c38488f20dc4bd69f0dd2.1393493276.git.rashika.kheria@gmail.com> <ffebeb9154859c6e109c825597c473dd6527f6bc.1393493276.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ffebeb9154859c6e109c825597c473dd6527f6bc.1393493276.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/27, Rashika Kheria wrote:
>
> --- a/kernel/signal.c
> +++ b/kernel/signal.c
> @@ -42,6 +42,7 @@
>  #include <asm/siginfo.h>
>  #include <asm/cacheflush.h>
>  #include "audit.h"	/* audit_signal_info() */
> +#include "debug/kdb/kdb_private.h"

Perhaps this should go under "#ifdef CONFIG_KGDB_KDB" along with
"#include <linux/kdb.h>" we already have?

Oleg.

