Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758073AbaGCKl1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 06:41:27 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:45341 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756858AbaGCKl0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 06:41:26 -0400
Date: Thu, 3 Jul 2014 03:41:21 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Thomas Sch?bel-Theuer <tst@1und1.de>
Cc: Christoph Hellwig <hch@infradead.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Thomas Schoebel-Theuer <tst@schoebel-theuer.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 49/50] mars: generic pre-patch for mars
Message-ID: <20140703104121.GA12585@infradead.org>
References: <1404251250-22992-50-git-send-email-tst@schoebel-theuer.de>
 <20140701223644.GA30330@kroah.com>
 <53B3B283.7050800@schoebel-theuer.de>
 <20140702082400.GB10971@kroah.com>
 <20140702132708.GA26732@infradead.org>
 <53B418FA.80600@1und1.de>
 <20140702145024.GA19425@infradead.org>
 <53B43144.6010306@1und1.de>
 <20140702184143.GA3061@infradead.org>
 <53B4F3D9.8050009@1und1.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53B4F3D9.8050009@1und1.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thoams,

On Thu, Jul 03, 2014 at 08:10:33AM +0200, Thomas Sch?bel-Theuer wrote:
> I see the following alternative solutions for this:

All your alternatives really miss the point.  I general we don't want
driver messing with the filesystem namespace, create their own symlink
farms or similar.  Maybe there is a good explanation why your driver
is special, but you haven't provided it.  In fact you've provided very
little explanation at all.  You've submitted a series with a very
highlevel introduction, and the 50 patches with no explanation at all.

The exported syscalls where the first major issue to stick out, but
without even looking at the code I bet there will various other
roadblocks if someone actually bothers to review the rest of the code.

So before you come up with various take it or leave it alternatives I'd
suggest you figure out how

 a) a driver submission should look like
 b) explain and "sell" your design so that people get interested in it,
    and will start to actually review it and discuss your design
    tradeoffs with it.

An attitude of a few options to chose from isn't really going to get
your very far.
