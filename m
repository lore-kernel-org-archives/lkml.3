Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752408AbaFDPQp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 11:16:45 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:38984 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751510AbaFDPQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 11:16:44 -0400
Date: Wed, 4 Jun 2014 08:16:43 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@infradead.org>, Shaohua Li <shli@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [patch]blk-mq: blk_mq_tag_to_rq should handle flush request
Message-ID: <20140604151643.GA6344@infradead.org>
References: <20140604111133.GA7826@infradead.org>
 <538F2A11.4060800@kernel.dk>
 <20140604142012.GA20056@infradead.org>
 <538F331F.60101@kernel.dk>
 <20140604145803.GA7826@infradead.org>
 <538F34FB.7050003@kernel.dk>
 <20140604150508.GA21551@infradead.org>
 <538F365C.8050604@kernel.dk>
 <20140604151020.GA13586@infradead.org>
 <538F3733.6040207@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <538F3733.6040207@kernel.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 04, 2014 at 09:11:47AM -0600, Jens Axboe wrote:
> On 2014-06-04 09:10, Christoph Hellwig wrote:
> >On Wed, Jun 04, 2014 at 09:08:12AM -0600, Jens Axboe wrote:
> >>>The performance regression is caused by "blk-mq: avoid code
> >>>duplication", but I don't really understand why yet.
> >>
> >>Gah, looks like this one dropped the tag idling. I bet that is why.
> >
> >Ah, thanks.  It's indeed exactly the same sort of slow down I bisected
> >back then, this should have rung a bell instead of keeping me occupied
> >for hours..
> 
> Patch is committed :-)

Oh well, I had just prepared the same one for you, but I want to at
least do basic sanity checking of my rebased tree with the fixes applied
now that I'm done bisecting.

