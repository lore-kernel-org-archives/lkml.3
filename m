Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751813AbaBHQyP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Feb 2014 11:54:15 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:38175 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751453AbaBHQyO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Feb 2014 11:54:14 -0500
Date: Sat, 8 Feb 2014 08:54:13 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Jan Kara <jack@suse.cz>,
        Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 10/11] smp: Remove wait argument from
 __smp_call_function_single()
Message-ID: <20140208165413.GA19333@infradead.org>
References: <1391876320-25068-1-git-send-email-fweisbec@gmail.com>
 <1391876320-25068-11-git-send-email-fweisbec@gmail.com>
 <20140208164247.GA11028@infradead.org>
 <20140208164633.GA21882@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140208164633.GA21882@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 08, 2014 at 05:46:36PM +0100, Frederic Weisbecker wrote:
> Good point. How about smp_call_function_single_async() ?

Fine with me.
