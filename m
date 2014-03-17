Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756930AbaCQS1z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 14:27:55 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:52111 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756667AbaCQS1x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 14:27:53 -0400
X-Sasl-enc: EUY618Xf9Q6yBPbAMKng4Hj37zFdooU1jhAXNPBIRDuu 1395080872
Date: Mon, 17 Mar 2014 11:29:53 -0700
From: Greg KH <greg@kroah.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Philipp Zabel <p.zabel@pengutronix.de>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: linux-next: manual merge of the staging tree with the v4l-dvb
 tree
Message-ID: <20140317182953.GA10565@kroah.com>
References: <20140317185542.fe4554210fc1893b44289008@canb.auug.org.au>
 <20140317080122.459ff9d4@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140317080122.459ff9d4@infradead.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 17, 2014 at 08:01:22AM -0300, Mauro Carvalho Chehab wrote:
> Em Mon, 17 Mar 2014 18:55:42 +1100
> Stephen Rothwell <sfr@canb.auug.org.au> escreveu:
> 
> > Hi Greg,
> > 
> > Today's linux-next merge of the staging tree got a conflict in
> > drivers/media/platform/exynos4-is/fimc-is.c between commit d265d9ac6c7c
> > ("[media] exynos4-is: Use external s5k6a3 sensor driver") from the
> > v4l-dvb tree and commit fd9fdb78a9bf ("[media] of: move graph helpers
> > from drivers/media/v4l2-core to drivers/of") from the staging tree.
> > I fixed it up (see below, though I suspect it is wasted?) and can carry
> > the fix as necessary (no action is required).
> 
> I used to have those OF patches on my tree, but I was forced to remove,
> as Grant rejected the patches. After his nack, lots of dicussions about
> the DT bindings started and, until last week, there were no consensus
> about that (as far as I followed the discussions).
> 
> So, reluctantly, I just dropped this series from my tree, pretending
> it never existed, as reverting them could cause troubles if it 
> (or some version of it) got merged via Greg, Grant and/or Russell
> trees.
> 
> On my head, it become too late to merge it for 3.15, as first
> people must agree on the DT bindings. Also, I already closed the
> media merge window, as -rc7 seems to be the last -rc.
> 
> One possible approach for this would be to merge the patches that move
> the OF graph code away from drivers/media, and the corresponding
> internal ABI changes early at -rc, and applying the DT binding
> patches, and the staging imx-drm driver for 3.16.

I don't understand, was I supposed to do something in my staging-next
tree for this as well?

totally confused,

greg k-h
