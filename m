Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752891Ab3BOQrT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 11:47:19 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751014Ab3BOQrS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 11:47:18 -0500
Date: Fri, 15 Feb 2013 17:47:10 +0100
From: Richard Weinberger <richard@nod.at>
To: Kees Cook <keescook@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: Re: [PATCH] futex: avoid kernel taint caused by get_robust_list
Message-ID: <20130215174710.1cc2349f@spider.haslach.nod.at>
In-Reply-To: <CAGXu5jL3DQis5aETSAWJ8AC43s8tmMEXZ-bNwWLdJ6p_4fP=Yw@mail.gmail.com>
References: <1360943688-12502-1-git-send-email-paul.gortmaker@windriver.com>
	<CAGXu5jJxPU2Skr12u07fTeg+8im6L4JHv23+TrB+qVWMY36F_w@mail.gmail.com>
	<511E6329.5050903@windriver.com>
	<CAGXu5jL3DQis5aETSAWJ8AC43s8tmMEXZ-bNwWLdJ6p_4fP=Yw@mail.gmail.com>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.14; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Fri, 15 Feb 2013 08:41:27 -0800
schrieb Kees Cook <keescook@chromium.org>:

> Hi Andrew,
> 
> Is this revert something you would be willing to take?

It looks like the patch[0] never made it into linux-kernel@ for whatever
reasons. :-(

Thanks,
//richard

[1] http://permalink.gmane.org/gmane.linux.kernel.hardened.devel/506

