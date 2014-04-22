Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757285AbaDVQBU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 12:01:20 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:41633 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756923AbaDVQBS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 12:01:18 -0400
Date: Tue, 22 Apr 2014 09:01:15 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Drew Richardson <drew.richardson@arm.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        Pawel Moll <pawel.moll@arm.com>
Subject: Re: [PATCH] Export block tracepoints for use by kernel modules
Message-ID: <20140422160115.GA21205@infradead.org>
References: <20140422142341.GC21121@dreric01-Precision-T1600>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140422142341.GC21121@dreric01-Precision-T1600>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2014 at 07:23:41AM -0700, Drew Richardson wrote:
> After commit de7b2973903c6cc50b31ee5682a69b2219b9919d ("tracepoint:
> Use struct pointer instead of name hash for reg/unreg tracepoints"),
> any tracepoints used in a kernel module must be exported.

NAK due to the lack of in-tree modules actually using it.
