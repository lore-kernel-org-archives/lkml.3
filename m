Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756369AbaAJArb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 19:47:31 -0500
Received: from kirsty.vergenet.net ([202.4.237.240]:59229 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753158AbaAJAr1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 19:47:27 -0500
Date: Fri, 10 Jan 2014 09:47:24 +0900
From: Simon Horman <horms@verge.net.au>
To: Olof Johansson <olof@lixom.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Paul Mundt <lethal@linux-sh.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Bastian Hecht <hechtb@gmail.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Subject: Re: linux-next: manual merge of the sh tree with the tree
Message-ID: <20140110004724.GA22965@verge.net.au>
References: <20140106121317.bada4233ec3fec40f79735cc@canb.auug.org.au>
 <CAOesGMgJe9KR2muA4F9EaXYpDFDLxVZsKOj-8qZFbDZTiRBuww@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOesGMgJe9KR2muA4F9EaXYpDFDLxVZsKOj-8qZFbDZTiRBuww@mail.gmail.com>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 08, 2014 at 11:11:03PM -0800, Olof Johansson wrote:
> On Sun, Jan 5, 2014 at 5:13 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> > Hi Paul,
> >
> > Today's linux-next merge of the sh tree got conflicts in
> > drivers/tty/serial/sh-sci.c and include/linux/serial_sci.h between
> > commits 8fb9631c517b ("serial: sh-sci: Sort headers alphabetically"),
> > 20bdcab8268c ("serial: sh-sci: Add OF support") and probably others from
> > the arm-soc tree and commits ada80ee7fa60 ("serial: sh-sci: Add OF
> > support") and b19ef75c56e9 ("serial: sh-sci: OF definitions need
> > linux/of.h") from the sh tree.
> >
> > The arm-soc tree version is dated much more recently than
> > the sh tree version and conflicts badly, so for today I have just dropped
> > the sh tree (everything in there was committed before April 2013).  Please
> > figure this out.
> 
> The request to merge the sh code came through Simon with claimed
> agreement from SH maintainers to do so -- I didn't verify this since
> they have in the past been well-coordinated. Simon?

I spoke with Paul recently and my understanding is that
he hasn't been actively working in this area for over a year now.

I guess there are some stale patches in his tree.
