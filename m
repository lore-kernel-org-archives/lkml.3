Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753593AbaGBN1M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 09:27:12 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:53035 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751744AbaGBN1K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 09:27:10 -0400
Date: Wed, 2 Jul 2014 06:27:08 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Thomas Schoebel-Theuer <tst@schoebel-theuer.de>,
        linux-kernel@vger.kernel.org, Thomas Sch?bel-Theuer <tst@1und1.de>
Subject: Re: [PATCH 49/50] mars: generic pre-patch for mars
Message-ID: <20140702132708.GA26732@infradead.org>
References: <1404251250-22992-1-git-send-email-tst@schoebel-theuer.de>
 <1404251250-22992-50-git-send-email-tst@schoebel-theuer.de>
 <20140701223644.GA30330@kroah.com>
 <53B3B283.7050800@schoebel-theuer.de>
 <20140702082400.GB10971@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140702082400.GB10971@kroah.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 02, 2014 at 01:24:00AM -0700, Greg KH wrote:
> > I will prepare a new version ASAP.
> > 
> > Is the asmlinkage one of the reasons?
> 
> No.  The wholesale exporting of all 300+ syscall functions for no
> apparent reasoning is the reason.

Using syscalls or syscall-like functionality from kernel code generally
is a bad idea.  Every single use needs a clear rationale in the patch
description.  Which do not seem to exist at all for the series, so in
it's current form it'll go straight to the trash bin anyway.

