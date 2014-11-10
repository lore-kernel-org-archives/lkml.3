Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753031AbaKJNqN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 08:46:13 -0500
Received: from verein.lst.de ([213.95.11.211]:35774 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751928AbaKJNqL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 08:46:11 -0500
Date: Mon, 10 Nov 2014 14:46:07 +0100
From: Christoph Hellwig <hch@lst.de>
To: Anish Bhatt <anish@chelsio.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>, Karen Xie <kxie@chelsio.com>
Subject: Re: linux-next: build failure after merge of the scsi tree
Message-ID: <20141110134607.GA3621@lst.de>
References: <20141110171533.63b2dfcc@canb.auug.org.au> <525DB349B3FB5444AE057A887CB2A8D8D71B12@nice.asicdesigners.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <525DB349B3FB5444AE057A887CB2A8D8D71B12@nice.asicdesigners.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 10, 2014 at 06:27:13AM +0000, Anish Bhatt wrote:
> Fix for this was sent out on thursday itself, but does not seem to be applied yet :
> http://marc.info/?l=linux-scsi&m=141529629911520&w=2

And I pulled it from drivers-for-3.18 early on Thursday, but that didn't
propagate to James' tree it seems.  I'll do another range of patch merging
these afternoon and will add the proper version.
