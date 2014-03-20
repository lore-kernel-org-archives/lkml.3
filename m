Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758837AbaCTPoN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 11:44:13 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:42041 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758065AbaCTPoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 11:44:10 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: linux-next: manual merge of the staging tree with the  tree
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mark Brown <broonie@kernel.org>
Cc: Greg KH <greg@kroah.com>, Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <3306881.foYD0IDJn0@avalon>
References: <20140313005026.95bb2222270ded24b0a5deff@kernel.org> <3306881. foYD0IDJn0@avalon>
Date: Thu, 20 Mar 2014 15:44:01 +0000
Message-Id: <20140320154402.063BDC40A0B@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Mar 2014 10:17:56 +0100, Laurent Pinchart <laurent.pinchart@ideasonboard.com> wrote:
> Hi Mark,
> 
> On Thursday 13 March 2014 00:50:26 Mark Brown wrote:
> > Hi Greg,
> > 
> > Today's linux-next merge of the staging tree got a conflict in
> > drivers/media/v4l2-core/v4l2-of.c between commit b9db140c1e4644d
> > ("[media] v4l: of: Support empty port nodes") from the v4l tree and
> > commit fd9fdb78a9bf ("[media] of: move graph helpers from
> > drivers/media/v4l2-core to drivers/of") from the staging tree.
> > 
> > I fixed it up by essentially dropping the support for empty port nodes
> > since there were more context differences than I was comfortable with
> > in the changes in the new code.
> 
> If I'm not mistaken the move of drivers/media/v4l2-core/v4l2-of.c to 
> drivers/of/of-graph.c has been canceled for v3.15 and related patches should 
> be dropped from the for-next branches in the very near future (the v4l tree 
> has already been rebased).

I had not actually asked Mauro to revert, but the branch is still in rmk's
tree and linux-next. I do not think it needs to be cancelled.

I do still have issues about it as a generic pattern, but I'm happy with
the discussion so far and the documentation will be sorted before the
next kernel is released.

g.
