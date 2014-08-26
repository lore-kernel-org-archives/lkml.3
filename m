Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758246AbaHZNvs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 09:51:48 -0400
Received: from verein.lst.de ([213.95.11.211]:43486 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757781AbaHZNvr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 09:51:47 -0400
Date: Tue, 26 Aug 2014 15:51:43 +0200
From: Christoph Hellwig <hch@lst.de>
To: Sabrina Dubroca <sd@queasysnail.net>
Cc: Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: linux-next: hdparm -B <value> broken
Message-ID: <20140826135143.GA30461@lst.de>
References: <20140826133159.GA5515@kria>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140826133159.GA5515@kria>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 26, 2014 at 03:31:59PM +0200, Sabrina Dubroca wrote:
> The following patch seems to fix the problem:

Thanks for the fix!  Can you turn this into a patch with a proper subject and a
signoff?

