Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753822AbaLANrn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 08:47:43 -0500
Received: from e06smtp14.uk.ibm.com ([195.75.94.110]:51344 "EHLO
	e06smtp14.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753407AbaLANrl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 08:47:41 -0500
Date: Mon, 1 Dec 2014 14:47:30 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Tony Luck <tony.luck@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Oleg Nesterov <oleg@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Wu Fengguang <fengguang.wu@intel.com>, Ingo Molnar <mingo@kernel.org>,
        Rik van Riel <riel@redhat.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [RFC PATCH 05/30] s390: Translate cputime magic constants to
 macros
Message-ID: <20141201134730.GG4074@osiris>
References: <1417199040-21044-1-git-send-email-fweisbec@gmail.com>
 <1417199040-21044-6-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417199040-21044-6-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14120113-0017-0000-0000-0000020A934C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 28, 2014 at 07:23:35PM +0100, Frederic Weisbecker wrote:
> Make the code more self-explanatory by naming magic constants.
> 
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
> Cc: Oleg Nesterov <oleg@redhat.com>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Rik van Riel <riel@redhat.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Tony Luck <tony.luck@intel.com>
> Cc: Wu Fengguang <fengguang.wu@intel.com>
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> ---
>  arch/s390/include/asm/cputime.h | 47 +++++++++++++++++++++--------------------
>  1 file changed, 24 insertions(+), 23 deletions(-)

Same here, nice cleanup and will be applied to the s390 tree.

Thanks,
Heiko

