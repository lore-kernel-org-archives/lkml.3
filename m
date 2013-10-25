Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754450Ab3JYNI1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 09:08:27 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:56578 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753882Ab3JYNHl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 09:07:41 -0400
Message-Id: <20131025130459.730903511@bombadil.infradead.org>
User-Agent: quilt/0.60-1
Date: Fri, 25 Oct 2013 06:04:59 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jens Axboe <axboe@kernel.dk>, Rusty Russell <rusty@rustcorp.com.au>,
        Asias He <asias@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] block multiqueue support for virtio-blk
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an updated version of the block multiqueue support for virtio-blk,
against Jens' blk-mq/core tree.  It's been working fine on my local tests,
but I'd love to see current performance numbers on hardware fast enough that
people were using the bio path for it earlier.
