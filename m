Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753725AbaLAQXv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 11:23:51 -0500
Received: from mail-wi0-f171.google.com ([209.85.212.171]:46250 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753244AbaLAQXt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 11:23:49 -0500
Date: Mon, 1 Dec 2014 17:23:46 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
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
Message-ID: <20141201162344.GD27302@lerouge>
References: <1417199040-21044-1-git-send-email-fweisbec@gmail.com>
 <1417199040-21044-6-git-send-email-fweisbec@gmail.com>
 <20141201134730.GG4074@osiris>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141201134730.GG4074@osiris>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 01, 2014 at 02:47:30PM +0100, Heiko Carstens wrote:
> On Fri, Nov 28, 2014 at 07:23:35PM +0100, Frederic Weisbecker wrote:
> > Make the code more self-explanatory by naming magic constants.
> > 
> > Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> > Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
> > Cc: Ingo Molnar <mingo@kernel.org>
> > Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
> > Cc: Oleg Nesterov <oleg@redhat.com>
> > Cc: Paul Mackerras <paulus@samba.org>
> > Cc: Peter Zijlstra <peterz@infradead.org>
> > Cc: Rik van Riel <riel@redhat.com>
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > Cc: Tony Luck <tony.luck@intel.com>
> > Cc: Wu Fengguang <fengguang.wu@intel.com>
> > Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> > ---
> >  arch/s390/include/asm/cputime.h | 47 +++++++++++++++++++++--------------------
> >  1 file changed, 24 insertions(+), 23 deletions(-)
> 
> Same here, nice cleanup and will be applied to the s390 Thanks.

Oh thanks a lot!
