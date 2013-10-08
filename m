Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754354Ab3JHNKX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 09:10:23 -0400
Received: from mail.abilis.ch ([195.70.19.74]:11830 "EHLO mail.abilis.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752386Ab3JHNKU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 09:10:20 -0400
X-Greylist: delayed 1909 seconds by postgrey-1.27 at vger.kernel.org; Tue, 08 Oct 2013 09:10:20 EDT
Date: Tue, 8 Oct 2013 15:09:42 +0200
From: Christian Ruppert <christian.ruppert@abilis.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Export symbols for splice in modules
Message-ID: <20131008130941.GB24735@ab42.lan>
References: <1381235898-24186-1-git-send-email-christian.ruppert@abilis.com>
 <20131008125229.GA8647@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131008125229.GA8647@infradead.org>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 08, 2013 at 05:52:29AM -0700, Christoph Hellwig wrote:
> On Tue, Oct 08, 2013 at 02:38:18PM +0200, Christian Ruppert wrote:
> > The symbols splice_to_pipe, splice_grow_spd and splice_shrink_spd are not
> > currently exported from the kernel. This prevents the implementation of
> > drivers using splice in modules not statically linked with the kernel. This
> > patch exports those symbols to make it possible to implement splice in
> > kernel modules.
> 
> Please submit these together with your drivers.  In general it seems
> a higher level interface should be exported anyway.

Unluckily, the drivers are currently distributed as out-of-tree modules.
We thought this patch might be useful anyway but if you prefer we can
also resubmit it the moment we decide to upstream the drivers.

Greetings,
  Christian
