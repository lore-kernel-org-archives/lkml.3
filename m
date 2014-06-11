Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753469AbaFKMBr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 08:01:47 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:52544 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751328AbaFKMBq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 08:01:46 -0400
Date: Wed, 11 Jun 2014 05:01:43 -0700
From: Christoph Hellwig <hch@infradead.org>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Hannes Reinecke <hare@suse.de>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] scsi patch queue tree
Message-ID: <20140611120143.GA26071@infradead.org>
References: <20140519140614.GA12183@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140519140614.GA12183@infradead.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After this first pull for the 3.16 merge window it seems like this
worked out fairly well - we got a large number of patches in, and all
reviewed by a second pair of eyes.

How should we go on from this?  The drivers-for-3.16-2 branch, which had
the late lpfs and hpsa updates didn't make it into the pull request for
Linus, do you intend to skip them for this window?  If not do you still
want to have another branch for the other pending smaller updates?

