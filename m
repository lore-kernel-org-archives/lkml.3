Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757148Ab3LFJnd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 04:43:33 -0500
Received: from e06smtp11.uk.ibm.com ([195.75.94.107]:55218 "EHLO
	e06smtp11.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752656Ab3LFJn2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 04:43:28 -0500
Date: Fri, 6 Dec 2013 10:43:21 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Jiang Liu <liuj97@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Shaohua Li <shli@kernel.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>, linux390@de.ibm.com,
        Thomas Gleixner <tglx@linutronix.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Michael Holzheu <holzheu@linux.vnet.ibm.com>,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>, Jiri Kosina <trivial@kernel.org>,
        Wang YanQing <udknight@gmail.com>, linux-arch@vger.kernel.org
Subject: Re: [RFC PATCH v3 13/19] smp, s390: prepare for killing
 generic_smp_call_function_single_interrupt()
Message-ID: <20131206094321.GC4524@osiris>
References: <1386173591-28514-1-git-send-email-liuj97@gmail.com>
 <1386173591-28514-14-git-send-email-liuj97@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386173591-28514-14-git-send-email-liuj97@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13120609-5024-0000-0000-0000080F622A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 05, 2013 at 12:13:04AM +0800, Jiang Liu wrote:
> Signed-off-by: Jiang Liu <liuj97@gmail.com>
> ---
>  arch/s390/kernel/smp.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)

I assume you will take care and make sure it gets merged?
Besides that:

Acked-by: Heiko Carstens <heiko.carstens@de.ibm.com>

