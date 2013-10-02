Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752864Ab3JBB2o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 21:28:44 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:59747 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752568Ab3JBB2l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 21:28:41 -0400
Date: Wed, 2 Oct 2013 10:28:37 +0900
From: Simon Horman <horms@verge.net.au>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: takasi-y@ops.dti.ne.jp, SH-Linux <linux-sh@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>, ben.dooks@codethink.co.uk,
        Shinya Kuribayashi <shinya.kuribayashi.px@renesas.com>,
        devicetree@vger.kernel.org, linux-serial@vger.kernel.org,
        Paul Mundt <lethal@linux-sh.org>,
        Mike Turquette <mturquette@linaro.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/6] ARM: shmobile: emev2: Define SMU clock DT bindings
Message-ID: <20131002012837.GA29457@verge.net.au>
References: <52410F86.4040301@renesas.com>
 <20130924131331.0e9a5f830f531655b2ea0ebe@ops.dti.ne.jp>
 <20130924045215.GE3619@verge.net.au>
 <21574726.tiJa6Opb1k@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <21574726.tiJa6Opb1k@avalon>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 01, 2013 at 01:36:33PM +0200, Laurent Pinchart wrote:
> Hi Yoshii-san and Simon,
> 
> On Tuesday 24 September 2013 13:52:15 Simon Horman wrote:
> > [ Cc Laurent ]
> > 
> > On Tue, Sep 24, 2013 at 01:13:31PM +0900, takasi-y@ops.dti.ne.jp wrote:
> > > Device tree clock binding document for EMMA Mobile EV2 SMU.
> > > Following nodes are defined to describe clock tree.
> > > - renesas,emev2-smu
> > > - renesas,emev2-smu-clkdiv
> > > - renesas,emev2-smu-gclk
> > 
> > I realise this has been entirely consistent in the past and
> > even as recently as Linus' pre v3.12-rc2 master branch.
> > However, after some recent discussion we are now trying to make our
> > compatibility strings consistently of the form renesas,<unit>-<soc>.
> > 
> > With this in mind I believe the strings should be:
> > 
> > - renesas,smu-emev2
> > - renesas,smu-clkdiv-emev2
> > - renesas,smu-gclk-emev2
> > 
> > To be honest I am not quite sure about the "-clkdiv" and "-gclk"
> > bits and I would appreciate some review from others.
> 
> I don't have access to the EMEV2 datasheet so my ability to comment on this is 
> somehow limited. However, given that the clock hardware is very SoC-specific, 
> it might make sense to keep the names proposed by Yoshii-san. This would be 
> consistent with the other clock bindings.

Thanks Laurent. If that seems fine by you then it is fine by me.
