Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754755AbaESOGU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 10:06:20 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:58256 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331AbaESOGS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 10:06:18 -0400
Date: Mon, 19 May 2014 07:06:14 -0700
From: Christoph Hellwig <hch@infradead.org>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Hannes Reinecke <hare@suse.de>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [ANNOUNCE] scsi patch queue tree
Message-ID: <20140519140614.GA12183@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'd like to announce the new scsi patch queue tree, which will pick up
any scsi core or driver patches promptly to allow easy integration and
feedback that contributors might be used to from other kernel subsystems.

There are two branches, one for the SCSI core and upper level drivers,
and one for low-level (hardware) drivers:

  git://git.infradead.org/users/hch/scsi-queue.git core-for-3.16
  git://git.infradead.org/users/hch/scsi-queue.git drivers-for-3.16 

The rules for the tree are:

 - it has at least two positive reviews (non-author signoff, reviewed-by
   or acked-by tags).   In practice this means it had at least one and
   I added another one.
 - no negative review on the mailing list
 - it applies cleanly
 - it compiles cleanly (drivers for architectures I can't test excluded)
 - for core the core branch: survives a full xfstests run

I went through the linux-scsi archives for March, April and May and
applied all patches that clearly fit the above criteria, but it's fairly
like I missed some.

If I'm missing your patch(es):

 - resend it unless it was sent in the last few weeks
 - make sure all reviews are recorded in the most recent post of the
   patch(es)
 - ping the list for additional reviewers

For now the prime intent of the tree is to feed it to James, although
I'd welcome everyone interested to pull and test it.  If the scheme
proves successful I'd love to invite more core scsi contributors to help
with it and move to a shared kernel.org tree.
