Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751165AbaLQMyf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 07:54:35 -0500
Received: from mga03.intel.com ([134.134.136.65]:41528 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750790AbaLQMyd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 07:54:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,691,1406617200"; 
   d="scan'208";a="500170274"
Date: Wed, 17 Dec 2014 18:24:06 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Simon Horman <horms+renesas@verge.net.au>,
        =?iso-8859-1?Q?J=FCrg?= Billeter <j@bitron.ch>,
        Magnus Damm <damm+renesas@opensource.se>,
        Phil Edworthy <phil.edworthy@renesas.com>,
        linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org,
        dmaengine@vger.kernel.org
Subject: Re: [PATCH] dmaengine: rcar-dmac: Handle hardware descriptor
 allocation failure
Message-ID: <20141217125406.GD16827@intel.com>
References: <1416924617-15939-1-git-send-email-j@bitron.ch>
 <24462099.2yiDWKCQ5B@avalon>
 <20141216070413.GW16827@intel.com>
 <5322978.GxSKO5eTNh@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5322978.GxSKO5eTNh@avalon>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 17, 2014 at 01:57:30AM +0200, Laurent Pinchart wrote:
> Do you mean that every Intel employee needs to resubscribe to all vger mailing 
> list once a year ? :-o
Unfortuntely yes... :( I need to set my infradead account up again now for
backup..

> 
> > > I suppose I have no choice anyway. Please provide me with a v3.20
> > > development branch on which I can rebase the patch set, I don't want to
> > > rebase it twice.
> >
> > Please use topic/slave_caps_device_control_fix. I am going to rebase this
> > once rc1 is declared (eow i guess). It would plain git rebase, so shouldn't
> > impact you.
> 
> Done. I'll rebase it once again when you will have rebased your branch, and 
> will then send a pull request. Could you please rebase your branch early after 
> the -rc1 release ?
Sure, within a day or so of its release it should be done.

Do note that am out during Christmas and the weekend with no email access,
will be lucky if my phone works, email very unlikely and I think you guys
will be out too.

But if your patches are done, feel free to send them

-- 
~Vinod

