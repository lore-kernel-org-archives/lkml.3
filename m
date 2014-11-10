Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753265AbaKJPVe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 10:21:34 -0500
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:39256 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752941AbaKJPVc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 10:21:32 -0500
Message-ID: <1415632890.22736.1.camel@jarvis.lan>
Subject: Re: linux-next: build failure after merge of the scsi tree
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Anish Bhatt <anish@chelsio.com>, Stephen Rothwell <sfr@canb.auug.org.au>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Karen Xie <kxie@chelsio.com>
Date: Mon, 10 Nov 2014 07:21:30 -0800
In-Reply-To: <20141110134607.GA3621@lst.de>
References: <20141110171533.63b2dfcc@canb.auug.org.au>
	 <525DB349B3FB5444AE057A887CB2A8D8D71B12@nice.asicdesigners.com>
	 <20141110134607.GA3621@lst.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-11-10 at 14:46 +0100, Christoph Hellwig wrote:
> On Mon, Nov 10, 2014 at 06:27:13AM +0000, Anish Bhatt wrote:
> > Fix for this was sent out on thursday itself, but does not seem to be applied yet :
> > http://marc.info/?l=linux-scsi&m=141529629911520&w=2
> 
> And I pulled it from drivers-for-3.18 early on Thursday, but that didn't
> propagate to James' tree it seems.  I'll do another range of patch merging
> these afternoon and will add the proper version.

so that's adding the 3.18-incoming trees?

James


