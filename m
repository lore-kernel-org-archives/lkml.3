Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753630AbaLANq3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 08:46:29 -0500
Received: from e06smtp15.uk.ibm.com ([195.75.94.111]:38664 "EHLO
	e06smtp15.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752404AbaLANq1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 08:46:27 -0500
Date: Mon, 1 Dec 2014 14:46:13 +0100
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
Subject: Re: [RFC PATCH 04/30] s390: Convert open coded idle time seqcount
Message-ID: <20141201134613.GF4074@osiris>
References: <1417199040-21044-1-git-send-email-fweisbec@gmail.com>
 <1417199040-21044-5-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417199040-21044-5-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14120113-0021-0000-0000-000001F98DF8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 28, 2014 at 07:23:34PM +0100, Frederic Weisbecker wrote:
> s390 uses open coded seqcount to synchronize idle time accounting.
> Lets consolidate it with the standard API.
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
>  arch/s390/include/asm/idle.h |  3 ++-
>  arch/s390/kernel/idle.c      | 28 +++++++++++++++-------------
>  2 files changed, 17 insertions(+), 14 deletions(-)

This is a nice cleanup. I'll apply it to the s390 tree, so it will
go upstream independently of this discussion.

Thanks,
Heiko

