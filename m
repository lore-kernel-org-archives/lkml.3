Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753475AbaJ1MKX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 08:10:23 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44994 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751620AbaJ1MKV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 08:10:21 -0400
From: Thomas Renninger <trenn@suse.de>
To: "Wilck, Martin" <martin.wilck@ts.fujitsu.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "openipmi-developer@lists.sourceforge.net" 
	<openipmi-developer@lists.sourceforge.net>,
        "minyard@acm.org" <minyard@acm.org>
Subject: Re: [patch 1/3] ipmi: Setup ipmi_devintf automatically if ipmi_msghandler gets loaded
Date: Tue, 28 Oct 2014 13:10:19 +0100
Message-ID: <2067129.5k6o6GOLEd@d46>
User-Agent: KMail/4.11.5 (Linux/3.11.10-11-desktop; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1414147256.8113.41.camel@pdbcooper.pdb.fsc.net>
References: <20141014144020.683892494@d46.suse.de> <2294896.XUUpIPFQ25@d46> <1414147256.8113.41.camel@pdbcooper.pdb.fsc.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, October 24, 2014 12:40:56 PM Wilck, Martin wrote:
> Thomas,
> 
> 
> > > I vote for MODULE_SOFTDEP for upstream, and modalias for distros that
> > > don't support MODULE_SOFTDEP yet.
> > 
> > I vote for ipmi_msghandler.c renaming into ipmi_handler.c
> 
> 
> sorry, I am not with you here. This is a small problem that should be
> handled with small effort. Why apply a 3-part patch set for a problem
> that can be solved with 2 modalias lines in user space?

Because it is wrong.
In fact this is about a 10 line change.
The file move is no code change at all.
With a modalias added in userspace this will show up in different
distributions again and again.
I agree that a modalias makes sense for SLE and this is probably
what we will go for.
But it would be nice to have this fixed in mainline properly.

Thanks,

    Thomas
