Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932934AbaDVPEP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 11:04:15 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:39804 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932828AbaDVPEC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 11:04:02 -0400
Date: Tue, 22 Apr 2014 08:03:45 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Drew Richardson <drew.richardson@arm.com>
Cc: Christoph Hellwig <hch@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>, Ben Greear <greearb@candelatech.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>
Subject: Re: [PATCH] Export irq tracepoints for use by kernel modules
Message-ID: <20140422150345.GA19099@infradead.org>
References: <20140422142419.GD21121@dreric01-Precision-T1600>
 <20140422142613.GA14535@infradead.org>
 <20140422150030.GA4969@dreric01-Precision-T1600>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140422150030.GA4969@dreric01-Precision-T1600>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2014 at 08:00:31AM -0700, Drew Richardson wrote:
> Gator (http://git.linaro.org/arm/ds5/gator.git), an out of tree kernel
> module, uses irq_handler_exit and softirq_exit. I thought it would be
> helpful to export the other tracepoints from trace/events/irq.h in
> case other users encountered a similar issue.

None of them should be exported unless we have in-tree modular users.
And I don't think adding modular users for either of them is a good idea
to start with.

