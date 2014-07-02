Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757381AbaGBSlr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 14:41:47 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:41578 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754614AbaGBSlq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 14:41:46 -0400
Date: Wed, 2 Jul 2014 11:41:43 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Thomas Sch?bel-Theuer <tst@1und1.de>
Cc: Christoph Hellwig <hch@infradead.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Thomas Schoebel-Theuer <tst@schoebel-theuer.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 49/50] mars: generic pre-patch for mars
Message-ID: <20140702184143.GA3061@infradead.org>
References: <1404251250-22992-1-git-send-email-tst@schoebel-theuer.de>
 <1404251250-22992-50-git-send-email-tst@schoebel-theuer.de>
 <20140701223644.GA30330@kroah.com>
 <53B3B283.7050800@schoebel-theuer.de>
 <20140702082400.GB10971@kroah.com>
 <20140702132708.GA26732@infradead.org>
 <53B418FA.80600@1und1.de>
 <20140702145024.GA19425@infradead.org>
 <53B43144.6010306@1und1.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53B43144.6010306@1und1.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 02, 2014 at 06:20:20PM +0200, Thomas Sch?bel-Theuer wrote:
> Please take into account that MARS Light is not just a "device driver",
> but a long-distance distributed system dealing with huge masses of state
> information.

Which doesn't matter.  No kernel driver has a business messing with the
filesystem namespace.  Especially no maintaining magic symlink farms.

