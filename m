Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752860Ab3JVKvK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 06:51:10 -0400
Received: from merlin.infradead.org ([205.233.59.134]:49889 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751950Ab3JVKvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 06:51:09 -0400
Date: Tue, 22 Oct 2013 12:51:06 +0200
From: Jens Axboe <axboe@kernel.dk>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH, RFC] block: use a separate plug list for blk-mq requests
Message-ID: <20131022105106.GH14598@kernel.dk>
References: <20131006160430.GA5959@infradead.org>
 <20131006181508.GF8252@kernel.dk>
 <20131022061657.GB25870@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131022061657.GB25870@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 21 2013, Christoph Hellwig wrote:
> On Sun, Oct 06, 2013 at 12:15:08PM -0600, Jens Axboe wrote:
> > Thanks, I'll take a look at this. The plugging was done mostly hacky
> > when implementing it, it was meant to be revisited. So definitely room
> > for improvement there.
> 
> Did you manage to take a look?

Yep, just did on the flight. I think it looks pretty good and I want to
queue it up. Did you test it?

-- 
Jens Axboe

