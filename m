Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753261AbaGGMCG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 08:02:06 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:33401 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752724AbaGGMCD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 08:02:03 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH v2] declance: Fix 64-bit compilation warnings
To: Joe Perches <joe@perches.com>, "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <1404585099.6384.53.camel@joe-AO725>
References: <alpine.LFD.2.11.1406290246120.15455@eddie.linux-mips.org>
	<20140702.182807.1245632778216212860.davem@davemloft.net>
	<alpine.LFD.2.11.1407030244230.15455@eddie.linux-mips.org>
	<alpine.LFD.2.11.1407030331550.15455@eddie.linux-mips.org>
	<1404356734.14741.18.camel@joe-AO725>
	<alpine.LFD.2.11.1407030423300.15455@eddie.linux-mips.org>
	<1404364565.14741.26.camel@joe-AO725>
	<alpine.LFD.2.11.1407030637030.15455@eddie.linux-mips.org>
	<1404368746.14741.36.camel@joe-AO725>
	<alpine.LFD.2.11.1407051529040.15455@eddie.linux-mips.org>
	<1404576420.6384.41.camel@joe-AO725>
	<alpine.LFD.2.11.1407051833400.15455@eddie.linux-mips.org>
	<1404583739.6384.51.camel@joe-AO725>
	<alpine.LFD.2.11.1407051917480.15455@eddie.linux-mips.org>
	<1404585099.6384.53.camel@joe-AO725>
Date: Mon, 07 Jul 2014 13:01:52 +0100
Message-Id: <20140707120152.CF82BC40921@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 05 Jul 2014 11:31:39 -0700, Joe Perches <joe@perches.com> wrote:
> On Sat, 2014-07-05 at 19:20 +0100, Maciej W. Rozycki wrote:
> > On Sat, 5 Jul 2014, Joe Perches wrote:
> > > I don't think %#p is valid so it
> > > shouldn't have been set by #.
> > 
> >  Huh?  As recently as last Wednesday you pointed me at the specific commit 
> > from Grant that made it valid (GCC format complaints aside).
> 
> Those gcc complaints are precisely the thing
> that makes it invalid.

That's the most inane reason ever for saying something is invalid. "The
tool doesn't recognise it, there for it is invalid?" Seriously?

Tools are just tools. They aren't the source of what is valid/invalid,
they only report on what we as engineers have told them to do, because
*we* define what should be valid/invalid.

If you've got a real reason that explains *why* the tool rejects that
construct, then I'd be happy to hear it, but otherwise that argument
makes no sense.

g.

