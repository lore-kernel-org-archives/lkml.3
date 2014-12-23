Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754500AbaLWJOT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 04:14:19 -0500
Received: from galahad.ideasonboard.com ([185.26.127.97]:55671 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724AbaLWJOQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 04:14:16 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Simon Horman <horms+renesas@verge.net.au>,
        =?ISO-8859-1?Q?J=FCrg?= Billeter <j@bitron.ch>,
        Magnus Damm <damm+renesas@opensource.se>,
        Phil Edworthy <phil.edworthy@renesas.com>,
        linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org,
        dmaengine@vger.kernel.org
Subject: Re: [PATCH] dmaengine: rcar-dmac: Handle hardware descriptor allocation failure
Date: Tue, 23 Dec 2014 11:14:21 +0200
Message-ID: <3101076.RYFhQ4RW4Z@avalon>
User-Agent: KMail/4.14.3 (Linux/3.16.5-gentoo; KDE/4.14.3; x86_64; ; )
In-Reply-To: <20141222150219.GI16827@intel.com>
References: <1416924617-15939-1-git-send-email-j@bitron.ch> <20141217125406.GD16827@intel.com> <20141222150219.GI16827@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vinod,

On Monday 22 December 2014 20:32:19 Vinod Koul wrote:
> On Wed, Dec 17, 2014 at 06:24:06PM +0530, Vinod Koul wrote:
> > On Wed, Dec 17, 2014 at 01:57:30AM +0200, Laurent Pinchart wrote:
> >> Do you mean that every Intel employee needs to resubscribe to all vger
> >> mailing list once a year ? :-o
> > 
> > Unfortuntely yes... :( I need to set my infradead account up again now for
> > backup..
> > 
> >>>> I suppose I have no choice anyway. Please provide me with a v3.20
> >>>> development branch on which I can rebase the patch set, I don't want
> >>>> to rebase it twice.
> >>> 
> >>> Please use topic/slave_caps_device_control_fix. I am going to rebase
> >>> this once rc1 is declared (eow i guess). It would plain git rebase, so
> >>> shouldn't impact you.
> >> 
> >> Done. I'll rebase it once again when you will have rebased your branch,
> >> and will then send a pull request. Could you please rebase your branch
> >> early after the -rc1 release ?
> > 
> > Sure, within a day or so of its release it should be done.
> > 
> > Do note that am out during Christmas and the weekend with no email access,
> > will be lucky if my phone works, email very unlikely and I think you guys
> > will be out too.
> > 
> > But if your patches are done, feel free to send them
> 
> And I have rebased and pushed. These should be linux-next for tomorrow

Thank you. I've rebased my branch, I'm testing it, and will send you a pull 
request right afterwards.

-- 
Regards,

Laurent Pinchart

