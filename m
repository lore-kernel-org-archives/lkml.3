Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752257AbaBHQmu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Feb 2014 11:42:50 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:38151 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751814AbaBHQms (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Feb 2014 11:42:48 -0500
Date: Sat, 8 Feb 2014 08:42:47 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Jan Kara <jack@suse.cz>, Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 10/11] smp: Remove wait argument from
 __smp_call_function_single()
Message-ID: <20140208164247.GA11028@infradead.org>
References: <1391876320-25068-1-git-send-email-fweisbec@gmail.com>
 <1391876320-25068-11-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1391876320-25068-11-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Might be worth to give the function a saner name than just the __-prefix
if you touch all callers anyway.

