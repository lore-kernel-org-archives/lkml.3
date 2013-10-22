Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753453Ab3JVGRA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 02:17:00 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:42696 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750874Ab3JVGQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 02:16:58 -0400
Date: Mon, 21 Oct 2013 23:16:57 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH, RFC] block: use a separate plug list for blk-mq requests
Message-ID: <20131022061657.GB25870@infradead.org>
References: <20131006160430.GA5959@infradead.org>
 <20131006181508.GF8252@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131006181508.GF8252@kernel.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 06, 2013 at 12:15:08PM -0600, Jens Axboe wrote:
> Thanks, I'll take a look at this. The plugging was done mostly hacky
> when implementing it, it was meant to be revisited. So definitely room
> for improvement there.

Did you manage to take a look?

