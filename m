Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753171AbaKJPuY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 10:50:24 -0500
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:39453 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753094AbaKJPuS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 10:50:18 -0500
Message-ID: <1415634616.22736.9.camel@jarvis.lan>
Subject: Re: linux-next: build failure after merge of the scsi tree
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Anish Bhatt <anish@chelsio.com>, Stephen Rothwell <sfr@canb.auug.org.au>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Karen Xie <kxie@chelsio.com>
Date: Mon, 10 Nov 2014 07:50:16 -0800
In-Reply-To: <20141110154802.GA11895@lst.de>
References: <20141110171533.63b2dfcc@canb.auug.org.au>
	 <525DB349B3FB5444AE057A887CB2A8D8D71B12@nice.asicdesigners.com>
	 <20141110134607.GA3621@lst.de> <1415632890.22736.1.camel@jarvis.lan>
	 <20141110154802.GA11895@lst.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-11-10 at 16:48 +0100, Christoph Hellwig wrote:
> On Mon, Nov 10, 2014 at 07:21:30AM -0800, James Bottomley wrote:
> > so that's adding the 3.18-incoming trees?
> 
> Not yet.  Those are for the buildbolt to find any issues before pushing
> it to the actual for-3.x branch.  It's a trick I picked up from the nfsd tree.

So your idea is Fenguang first then linux-next.

OK.

James


