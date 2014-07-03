Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759534AbaGCQ2J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 12:28:09 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43044 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759508AbaGCQ2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 12:28:05 -0400
Date: Thu, 3 Jul 2014 09:27:48 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Christoph Hellwig <hch@infradead.org>,
        Mike Christie <michaelc@cs.wisc.edu>,
        Alex Williamson <alex.williamson@redhat.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Sagi Grimberg <sagig@mellanox.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        SCSI Mailing List <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 3.15 099/139] libiscsi, iser: Adjust data_length to
 include protection information
Message-ID: <20140703162748.GA24758@kroah.com>
References: <20140628174605.352098823@linuxfoundation.org>
 <20140628174609.930049472@linuxfoundation.org>
 <1404339330.1862.69.camel@ul30vt.home>
 <53B48B37.4000608@cs.wisc.edu>
 <1404341555.16066.19.camel@dabdike>
 <20140703060548.GB17456@infradead.org>
 <1404395645.1949.2.camel@jarvis.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404395645.1949.2.camel@jarvis.lan>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 03, 2014 at 06:54:05AM -0700, James Bottomley wrote:
> On Wed, 2014-07-02 at 23:05 -0700, Christoph Hellwig wrote:
> > On Wed, Jul 02, 2014 at 03:52:35PM -0700, James Bottomley wrote:
> > > In which case it's not marked for stable backport ... I assume it should
> > > be?
> > 
> > Only if the patch that regression went to stable, which it shouldn't,
> 
> Well it did:
> 
> https://git.kernel.org/cgit/linux/kernel/git/stable/linux-stable.git/commit/drivers/scsi?h=linux-3.15.y&id=04423ddea30a7fb7232636eda8aed55ea5b972fe
> 
> The stable process is a bit broken from my point of view since it
> doesn't copy linux-scsi on SCSI commits

I copy everyone on the patch.  You were not on that patch as it doesn't
look like it went through your tree at all.

> ... but this time even I didn't get a cc, so really no-one who knew
> there was a problem had a chance to comment.

The target people (Nicholas) asked for the patch to be applied, they
knew what was going on here.

> The choice is either request revert from stable or add fix.

Agreed, just let me know.

greg k-h
