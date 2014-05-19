Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752426AbaESAUH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2014 20:20:07 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:51982 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752195AbaESAUF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2014 20:20:05 -0400
Message-ID: <1400458802.2288.11.camel@dabdike>
Subject: Re: SCSI "staging" tree for linux-next?
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Mon, 19 May 2014 09:20:02 +0900
In-Reply-To: <1400277676.16968.2.camel@dabdike.int.hansenpartnership.com>
References: <20140515052645.GA26266@infradead.org>
	 <537614CC.6020602@suse.de>
	 <1400277676.16968.2.camel@dabdike.int.hansenpartnership.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.12.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-05-16 at 15:01 -0700, James Bottomley wrote:
> On Fri, 2014-05-16 at 15:38 +0200, Hannes Reinecke wrote:
> > On 05/15/2014 07:26 AM, Christoph Hellwig wrote:
> > > Hi James,
> > >
> > > we're past -rc5 and no SCSI patches have been collected for 3.16 yet,
> > > despite a lot of patches including a lot of reviewed ones pending on the
> > > list.
> > >
> > > I'd really love to get at least some testing for all the work that
> > > sometimes has been pending for months in linux-next and would offer to
> > > put together a tree of reviewed patches for linux-next.  Is this fine
> > > with you?
> > >
> > Seconded. Having a staging tree would make my life _so_ much easier.
> 
> OK, I think we can do this easily.  Send me your staging branches and
> I'll pull them into a global staging branch and merge it with for-next
> in linux-scsi ... this will ensure we don't get yelled at for duplicate
> commits causing merge rejections in linux-next.  Since staging will be
> volatile and for the purposes of testing patches on upstream track, we
> don't need signed tags or anything.

Ping ... Git URL, anyone?

I thought this was something you really wanted and an essential
component to making your lives easier?

Like I said, just the URL will work for a staging tree, I don't need
signed tags or commit descriptions ... although if testing by next or
Fengguang shows fatal problems, I'll drop the branch.

James


