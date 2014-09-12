Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752403AbaILQaB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 12:30:01 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:38693 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751711AbaILQ36 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 12:29:58 -0400
X-Sasl-enc: uLnxCrkiqgdH//o/E8glt4pOjiQU1fzavGncYpNTE3YB 1410539397
Date: Fri, 12 Sep 2014 09:29:56 -0700
From: Greg KH <greg@kroah.com>
To: Maciej Matraszek <m.matraszek@samsung.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>, stable@vger.kernel.org,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: Re: [PATCH v2] [media] v4l2-common: fix overflow in
 v4l_bound_align_image()
Message-ID: <20140912162956.GA27302@kroah.com>
References: <1410367869-27688-1-git-send-email-m.matraszek@samsung.com>
 <20140910171013.GA14048@kroah.com>
 <1410538309.8852.30.camel@AMDC723>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410538309.8852.30.camel@AMDC723>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 12, 2014 at 06:11:49PM +0200, Maciej Matraszek wrote:
> On Wed, 2014-09-10 at 10:10 -0700, Greg KH wrote:
> > > Fixes: b0d3159be9a3 ("V4L/DVB (11901): v4l2: Create helper function for bounding and aligning images")
> > > Signed-off-by: Maciej Matraszek <m.matraszek@samsung.com>
> > > Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > > 
> > > ---
> > 
> > <formletter>
> > 
> > This is not the correct way to submit patches for inclusion in the
> > stable kernel tree.  Please read Documentation/stable_kernel_rules.txt
> > for how to do this properly.
> > 
> > </formletter>
> 
> Hi Greg,
> 
> I'm really sorry for this mistake.
> Do I understand correctly that it is just a missing
> 'Cc: <stable@vger.kernel.org>' line?

In the signed-off-by: area of the patch, yes, that is what is needed.

Otherwise, just randomly sending the email to that address means
nothing.

thanks,

greg k-h
