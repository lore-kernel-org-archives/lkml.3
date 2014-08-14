Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754836AbaHNMyx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 08:54:53 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:40027 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754220AbaHNMyv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 08:54:51 -0400
Date: Thu, 14 Aug 2014 05:54:51 -0700
From: Christoph Hellwig <hch@infradead.org>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] scsi patch queue tree updated
Message-ID: <20140814125451.GA832@infradead.org>
References: <20140708134003.GA7790@infradead.org>
 <20140801122042.GA10771@infradead.org>
 <1406925121.2654.21.camel@jarvis>
 <20140804111147.GA29148@infradead.org>
 <1407162004.4243.1.camel@jarvis.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407162004.4243.1.camel@jarvis.lan>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 04, 2014 at 07:20:04AM -0700, James Bottomley wrote:
> > The drivers side are a bunch of smaller fixes for iscsi and pm8001 which
> > never have been a problem to put in near the end of the merge window,
> > especially if they have a few more days linux-next exposure in
> > Linux-next even after the 3.16 release.  They absolutely would be
> > candidates for a second pull even if they'd miss the first pull.
> 
> OK, since I have to do a second pull anyway we might as well follow the
> rules.

Ok, new tree is out, the core-for-3.17 has the one 64-bit lun format
string fix that didn't make it into the first pull request, the
queuecommand device busy regression fix, and the cmd_pool fix.

The drivers-for-3.17 just has the driver updates I pushed earlier that
didn't make the cut.

