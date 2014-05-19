Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754691AbaESOZW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 10:25:22 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:57274 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753964AbaESOZV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 10:25:21 -0400
Date: Mon, 19 May 2014 15:25:19 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: time to move fs/bio.c to block/ ?
Message-ID: <20140519142519.GI18016@ZenIV.linux.org.uk>
References: <20140519141309.GB21570@infradead.org>
 <537A11CC.5060708@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <537A11CC.5060708@kernel.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 19, 2014 at 08:14:36AM -0600, Jens Axboe wrote:
> On 05/19/2014 08:13 AM, Christoph Hellwig wrote:
> > I recently saw patches to fs/bio.c that were sent to Al instead of Jens.
> > I think having bio.c in fs/ is rather confusing, so maybe it's time to
> > include the simple git-mv for it in the your for-next tree?
> 
> Sure, I've been thinking that too for a while. I'll do the move.

While you are at it, could you take bio-integrity.c with it?  _That_
has zero excuse being anywhere in fs/* - not even "filesystem code
uses quite a few functions from that sucker" as with bio.c.
FWIW, consider the move ACKed.
