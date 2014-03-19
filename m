Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965504AbaCSP2I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 11:28:08 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:59557 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965071AbaCSP2G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 11:28:06 -0400
X-Sasl-enc: F21qEzrX4s3ov7ZizGj9NWgXl1DRrukEG+t5OP6I1CME 1395242884
Date: Wed, 19 Mar 2014 08:30:08 -0700
From: Greg KH <greg@kroah.com>
To: Russell King <rmk@arm.linux.org.uk>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Philipp Zabel <p.zabel@pengutronix.de>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Grant Likely <grant.likely@linaro.org>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: Re: linux-next: manual merge of the staging tree with the v4l-dvb
 tree
Message-ID: <20140319153008.GC31293@kroah.com>
References: <20140317185542.fe4554210fc1893b44289008@canb.auug.org.au>
 <20140317080122.459ff9d4@infradead.org>
 <20140317182953.GA10565@kroah.com>
 <20140317162937.2ccdec83@infradead.org>
 <20140317222736.GB3708@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140317222736.GB3708@flint.arm.linux.org.uk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 17, 2014 at 10:27:36PM +0000, Russell King wrote:
> However, I still find myself coming back to a fundamental question: why
> were these bindings fine in April 2013, passed review, and were acked,
> but not fine today.  Here's the links to the emails acking their
> introduction which Sylwester Nawrocki sent me:
> 
>   http://www.spinics.net/lists/linux-media/msg61899.html
>   http://www.spinics.net/lists/linux-media/msg62458.html
> 
> So... *shrug*.  Make of this what you will.

Thanks for the details, I'll just leave my tree as-is for now, as that
seems the simplest thing to do.

greg k-h
