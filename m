Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756054AbaLHRTJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 12:19:09 -0500
Received: from mga09.intel.com ([134.134.136.24]:31816 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755928AbaLHRTH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 12:19:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,539,1413270000"; 
   d="scan'208";a="620509369"
Date: Mon, 8 Dec 2014 22:49:24 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: =?iso-8859-1?Q?J=FCrg?= Billeter <j@bitron.ch>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Simon Horman <horms+renesas@verge.net.au>,
        Magnus Damm <damm+renesas@opensource.se>,
        Phil Edworthy <phil.edworthy@renesas.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org,
        dmaengine@vger.kernel.org
Subject: Re: [PATCH] dmaengine: rcar-dmac: Handle hardware descriptor
 allocation failure
Message-ID: <20141208171923.GS16827@intel.com>
References: <1416924617-15939-1-git-send-email-j@bitron.ch>
 <20141208113637.GG16827@intel.com>
 <1418057426.5069.6.camel@bitron.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1418057426.5069.6.camel@bitron.ch>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 08, 2014 at 05:50:26PM +0100, Jürg Billeter wrote:
> Hi Vinod,
> 
> On Mon, 2014-12-08 at 17:06 +0530, Vinod Koul wrote:
> > Can you please rebase this on my next, this fails to apply for me
> 
> This is a patch for Laurent's new rcar-dmac driver, which doesn't appear
> to be in your next yet. Laurent has already merged my patch into his
> dma/next branch and included it in his pull request from November 27.
> 
> [GIT PULL FOR v3.19] R-Car DMA engine driver
> http://www.spinics.net/lists/linux-sh/msg37764.html
And I dont seem to have this request in my Inbox :(
Yes I do see it in archieves, so not sure how this is not present, not sure
if the servers mangeled it!!

I will pull this tomorrow...

> Please let me know if there is still a rebase required from my side.
Nope

-- 
~Vinod

