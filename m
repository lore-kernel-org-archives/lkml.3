Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752784AbaHDOUJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 10:20:09 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:56284 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752706AbaHDOUG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 10:20:06 -0400
Message-ID: <1407162004.4243.1.camel@jarvis.lan>
Subject: Re: [ANNOUNCE] scsi patch queue tree updated
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 04 Aug 2014 07:20:04 -0700
In-Reply-To: <20140804111147.GA29148@infradead.org>
References: <20140708134003.GA7790@infradead.org>
	 <20140801122042.GA10771@infradead.org> <1406925121.2654.21.camel@jarvis>
	 <20140804111147.GA29148@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-08-04 at 04:11 -0700, Christoph Hellwig wrote:
> On Fri, Aug 01, 2014 at 04:32:01PM -0400, James Bottomley wrote:
> > On Fri, 2014-08-01 at 05:20 -0700, Christoph Hellwig wrote:
> > > I've pushed out updates to both the core-for-3.17 and drivers-for-3.17
> > > branches.
> > 
> > So I'm afraid we missed the last -next build on these, so they can't go
> > in with the early SCSI pull.  I'm open to doing one mid merge window,
> > but Linus tends not to like that.
> 
> I don't think there are any hard and fast rules.

True, but the hardest of our semi-liquid rules is nothing in the merge
window that wasn't in -next first.

> The core-for-3.17 commit is a trivial printk specifier regression fix for
> something introduced in the 3.17 merge window, so pulling it in is
> an absolute non-brainer.
> 
> The drivers side are a bunch of smaller fixes for iscsi and pm8001 which
> never have been a problem to put in near the end of the merge window,
> especially if they have a few more days linux-next exposure in
> Linux-next even after the 3.16 release.  They absolutely would be
> candidates for a second pull even if they'd miss the first pull.

OK, since I have to do a second pull anyway we might as well follow the
rules.

James


