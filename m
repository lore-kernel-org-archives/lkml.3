Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751938AbaHOTZK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 15:25:10 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:46514 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751604AbaHOTZG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 15:25:06 -0400
Date: Fri, 15 Aug 2014 12:25:05 -0700
From: Christoph Hellwig <hch@infradead.org>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [ANNOUNCE] scsi patch queue tree updated
Message-ID: <20140815192505.GA25198@infradead.org>
References: <20140708134003.GA7790@infradead.org>
 <20140801122042.GA10771@infradead.org>
 <1406925121.2654.21.camel@jarvis>
 <20140804111147.GA29148@infradead.org>
 <1407162004.4243.1.camel@jarvis.lan>
 <20140814125451.GA832@infradead.org>
 <1408038428.2066.42.camel@jarvis.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1408038428.2066.42.camel@jarvis.lan>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 14, 2014 at 10:47:08AM -0700, James Bottomley wrote:
> So this is a bit late to get through linux-next and into a pull request.
> I was planning on sending the final pull tomorrow (in case Linus planned
> a surprise early release).  Can we redo some of these as bug fixes and
> send them in for -rc1?

core-for-3.17 is entirely bug fixes, the drivers side is all except
for 4 tiny patches, and even Linus isn't that anal I think.

