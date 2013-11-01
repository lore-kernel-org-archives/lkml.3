Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753866Ab3KAU16 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 16:27:58 -0400
Received: from mail.linux-iscsi.org ([67.23.28.174]:43352 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752537Ab3KAU1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 16:27:55 -0400
Message-ID: <1383338230.4216.9.camel@haakon3.risingtidesystems.com>
Subject: Re: scsi-mq + open-iscsi support patches..?
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: open-iscsi@googlegroups.com, linux-scsi <linux-scsi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        target-devel <target-devel@vger.kernel.org>,
        Or Gerlitz <ogerlitz@mellanox.com>
Date: Fri, 01 Nov 2013 13:37:10 -0700
In-Reply-To: <5273BEBF.2090008@cs.wisc.edu>
References: <1382997816.19256.767.camel@haakon3.risingtidesystems.com>
	 <5273BEBF.2090008@cs.wisc.edu>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-11-01 at 09:46 -0500, Mike Christie wrote:
> On 10/28/13 5:03 PM, Nicholas A. Bellinger wrote:
> > Hi Mike,
> >
> > Just curious as to the status of the scsi-mq conversion patches for
> > open-iscsi that you where working on a while back..?
> >
> > I'm asking because recently I've been spending alot of time with scsi-mq
> > + virtio-scsi, and would really to start banging on iser-target ports
> > using an scsi-mq enabled iser-initiator as well..
> >
> > So that said, are there any blockers holding things up towards getting a
> > working prototype..?
> >
> 
> Just time. Just finished a release at work and just got back from 
> vacation so hoping to work on this some more in the next weeks.
> 

<nod>

Btw, I'm happy to help move things along here too, and have a few extra
cycles to spare..

> On a related note, some iscsi vendor has been hitting a crash with your 
> tree.

I got an email from Jayamohan recently, but the OOPs did not appear to
be scsi-mq related..

>  Have you rebased it it to take in Christoph's changes and fixes 
> that are in Jens's tree? The code here
> 
> https://git.kernel.org/cgit/linux/kernel/git/nab/target-pending.git/log/?h=scsi-mq
> 
> looks ok. That is the current code right?
> 

It's current as of a few weeks ago, but does not include the very latest
blk-mq code that's now in next from Jens.

I'll be rebasing once blk-mq hits mainline over the next weeks..  ;)

--nab

