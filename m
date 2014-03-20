Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759476AbaCTRJp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 13:09:45 -0400
Received: from mailout2.w2.samsung.com ([211.189.100.12]:8462 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755261AbaCTRJl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 13:09:41 -0400
X-AuditID: cbfec372-b7fa96d000006a7b-04-532b20d32f15
Date: Thu, 20 Mar 2014 14:09:33 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mark Brown <broonie@kernel.org>, Greg KH <greg@kroah.com>,
        Philipp Zabel <p.zabel@pengutronix.de>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: manual merge of the staging tree with the  tree
Message-id: <20140320140933.4218df22@samsung.com>
In-reply-to: <20140320154402.063BDC40A0B@trevor.secretlab.ca>
References: <20140313005026.95bb2222270ded24b0a5deff@kernel.org>
 <3306881.foYD0IDJn0@avalon> <20140320154402.063BDC40A0B@trevor.secretlab.ca>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-redhat-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrILMWRmVeSWpSXmKPExsVy+t/hYN3LCtrBBh86rC2mPnzCZvHqzEY2
	i3MLZjBadE5cwm5xedccNouDC9sYLe7eO8HiwO4xu2Mmq8emVZ1sHm8fBnj0/zXw+PlSx+Pz
	JrkAtigum5TUnMyy1CJ9uwSujPuXWtkK2gQqnqxsZWlgvMPTxcjJISFgIvFt9RlmCFtM4sK9
	9WxdjFwcQgJLGCUWvz7EDOH0MElMvDsLrIpFQFVizvIONhCbTcBI4lVjC2sXIweHiICOxLNz
	giD1zAK3GSW2fb8PVi8s4CHxdeoCMJtXwFCi4+p7dhCbU8BWov3HZVaIBf1A295tYoQ4w0ni
	1evJTBANghI/Jt9jAbGZBbQkNm9rYoWw5SU2r3nLPIFRYBaSsllIymYhKVvAyLyKUbS0OLmg
	OCk911CvODG3uDQvXS85P3cTIyTYi3YwPttgdYhRgINRiYe3glM7WIg1say4MvcQowQHs5II
	b54MUIg3JbGyKrUoP76oNCe1+BAjEwenVAPjjJlzuJubRHlO2X3M7q6XFfl+ZuG5QzvCwpmi
	Fkccj0tV0Nwxz+dR8MqnqXwd/73OOJx+ZKe9JFAwx8c27Iyz0ZHiY0c5Ap79M/M4HsTX0dc1
	z+K65V/z+3pdW2rPrzqSJNW4rp39XNfl78o2YdPf5fv0/D7Kmr3jsKbKse6vUps3xSy9G5mu
	xFKckWioxVxUnAgANqzznFQCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, 20 Mar 2014 15:44:01 +0000
Grant Likely <grant.likely@secretlab.ca> escreveu:

> On Thu, 13 Mar 2014 10:17:56 +0100, Laurent Pinchart <laurent.pinchart@ideasonboard.com> wrote:
> > Hi Mark,
> > 
> > On Thursday 13 March 2014 00:50:26 Mark Brown wrote:
> > > Hi Greg,
> > > 
> > > Today's linux-next merge of the staging tree got a conflict in
> > > drivers/media/v4l2-core/v4l2-of.c between commit b9db140c1e4644d
> > > ("[media] v4l: of: Support empty port nodes") from the v4l tree and
> > > commit fd9fdb78a9bf ("[media] of: move graph helpers from
> > > drivers/media/v4l2-core to drivers/of") from the staging tree.
> > > 
> > > I fixed it up by essentially dropping the support for empty port nodes
> > > since there were more context differences than I was comfortable with
> > > in the changes in the new code.
> > 
> > If I'm not mistaken the move of drivers/media/v4l2-core/v4l2-of.c to 
> > drivers/of/of-graph.c has been canceled for v3.15 and related patches should 
> > be dropped from the for-next branches in the very near future (the v4l tree 
> > has already been rebased).
> 
> I had not actually asked Mauro to revert,

See:
	https://lkml.org/lkml/2014/3/10/283

There, you literally answered me that:
	"All trees containing the branch would need to be reverted."
and:
	"It means any tree containing that branch *must* be rewound."

That's what I (unhappily) did.

I won't reapply this series, but, instead, I'll simply wait for the
staging tree to be merged before sending those patches upstream,
before sending the topic branch with exynos 5 patches that depend on it.

This way, I can add Stephen patch on such topic branch, to avoid
compilation breakages after merged.

> but the branch is still in rmk's
> tree and linux-next. I do not think it needs to be cancelled.

> I do still have issues about it as a generic pattern, but I'm happy with
> the discussion so far and the documentation will be sorted before the
> next kernel is released.
> 
> g.

Regards,
Mauro
