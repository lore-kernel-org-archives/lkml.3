Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753116AbbAQBzS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 20:55:18 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:44920 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752144AbbAQBzR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 20:55:17 -0500
Date: Fri, 16 Jan 2015 17:55:09 -0800
From: Darren Hart <dvhart@infradead.org>
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Darren Hart <darren@dvhart.com>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] doc: Fix misnamed FUTEX_CMP_REQUEUE_PI 'op' constants
Message-ID: <20150117015508.GA6494@vmdeb7>
References: <54B9663D.9070000@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54B9663D.9070000@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 16, 2015 at 08:27:57PM +0100, Michael Kerrisk (man-pages) wrote:
> From: Michael Kerrisk <mtk.manpages@gmail.com>
> 
> FUTEX_CMP_REQUEUE_PI was misnamed in two different ways:
> FUTEX_REQUEUE_CMP_PI and FUTEX_REQUEUE_PI. The existence of two
> different misnamings leaves the reader wondering if we are talking
> about two different operations. Furthermore, the misnamings mean
> that grepping the source for the correct name (which doesn't
> appear at all) won't find this documentation file.
> 
> Signed-off-by: Michael Kerrisk <mtk.manpages@gmail.com>

Ugh! I noticed this today while reviewing your futex manpage work. Embarassing
to say the least :/ Thanks Michael!

Reviewed-by: Darren Hart <dvhart@linux.intel.com>

-- 
Darren Hart
Intel Open Source Technology Center
