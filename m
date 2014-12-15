Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750755AbaLORCe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 12:02:34 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:51559 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751034AbaLORCb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 12:02:31 -0500
X-Sasl-enc: w9c4SC2KgApOKScQgKfgMFi88AJyZ4jfYYLKDlxgFdj4 1418662948
Date: Mon, 15 Dec 2014 09:02:27 -0800
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Wim Van Sebroeck <wim@iguana.be>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiubo Li <Li.Xiubo@freescale.com>,
        Wolfram Sang <wsa@the-dreams.de>
Subject: Re: linux-next: manual merge of the driver-core tree with the
 watchdog tree
Message-ID: <20141215170227.GC2155@kroah.com>
References: <20141215141114.575b8767@canb.auug.org.au>
 <20141215043506.GB3949@kroah.com>
 <20141215160909.24c2e73b@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141215160909.24c2e73b@canb.auug.org.au>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 15, 2014 at 04:09:09PM +1100, Stephen Rothwell wrote:
> Hi Greg,
> 
> On Sun, 14 Dec 2014 20:35:06 -0800 Greg KH <greg@kroah.com> wrote:
> >
> > How is this happening, nothing has changed in my trees, did something
> > new get added to the watchdog tree?
> 
> Yep.
> 
> It would have been much easier on me (and maybe Linus) if those "drop
> owner assignment from platform_drivers" patches had gone via their
> respective maintainers ... just something to remember for next time.

Yeah, sorry, I'll do that next time, my fault.

greg k-h
