Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753979AbaHNRrQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 13:47:16 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:49954 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753713AbaHNRrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 13:47:10 -0400
Message-ID: <1408038428.2066.42.camel@jarvis.lan>
Subject: Re: [ANNOUNCE] scsi patch queue tree updated
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>
Date: Thu, 14 Aug 2014 10:47:08 -0700
In-Reply-To: <20140814125451.GA832@infradead.org>
References: <20140708134003.GA7790@infradead.org>
	 <20140801122042.GA10771@infradead.org> <1406925121.2654.21.camel@jarvis>
	 <20140804111147.GA29148@infradead.org> <1407162004.4243.1.camel@jarvis.lan>
	 <20140814125451.GA832@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-08-14 at 05:54 -0700, Christoph Hellwig wrote:
> On Mon, Aug 04, 2014 at 07:20:04AM -0700, James Bottomley wrote:
> > > The drivers side are a bunch of smaller fixes for iscsi and pm8001 which
> > > never have been a problem to put in near the end of the merge window,
> > > especially if they have a few more days linux-next exposure in
> > > Linux-next even after the 3.16 release.  They absolutely would be
> > > candidates for a second pull even if they'd miss the first pull.
> > 
> > OK, since I have to do a second pull anyway we might as well follow the
> > rules.
> 
> Ok, new tree is out, the core-for-3.17 has the one 64-bit lun format
> string fix that didn't make it into the first pull request, the
> queuecommand device busy regression fix, and the cmd_pool fix.
> 
> The drivers-for-3.17 just has the driver updates I pushed earlier that
> didn't make the cut.

So this is a bit late to get through linux-next and into a pull request.
I was planning on sending the final pull tomorrow (in case Linus planned
a surprise early release).  Can we redo some of these as bug fixes and
send them in for -rc1?

James


