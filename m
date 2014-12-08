Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756120AbaLHQus (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 11:50:48 -0500
Received: from cpanel09.rubas.ch ([195.182.222.79]:35988 "EHLO
	cpanel09.tophost.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751520AbaLHQuq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 11:50:46 -0500
Message-ID: <1418057426.5069.6.camel@bitron.ch>
Subject: Re: [PATCH] dmaengine: rcar-dmac: Handle hardware descriptor
 allocation failure
From: =?ISO-8859-1?Q?J=FCrg?= Billeter <j@bitron.ch>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Simon Horman <horms+renesas@verge.net.au>,
        Magnus Damm <damm+renesas@opensource.se>,
        Phil Edworthy <phil.edworthy@renesas.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org,
        dmaengine@vger.kernel.org
Date: Mon, 08 Dec 2014 17:50:26 +0100
In-Reply-To: <20141208113637.GG16827@intel.com>
References: <1416924617-15939-1-git-send-email-j@bitron.ch>
	 <20141208113637.GG16827@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.8 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - cpanel09.tophost.ch
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - bitron.ch
X-Get-Message-Sender-Via: cpanel09.tophost.ch: authenticated_id: juerg@bitron.ch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vinod,

On Mon, 2014-12-08 at 17:06 +0530, Vinod Koul wrote:
> Can you please rebase this on my next, this fails to apply for me

This is a patch for Laurent's new rcar-dmac driver, which doesn't appear
to be in your next yet. Laurent has already merged my patch into his
dma/next branch and included it in his pull request from November 27.

[GIT PULL FOR v3.19] R-Car DMA engine driver
http://www.spinics.net/lists/linux-sh/msg37764.html

Please let me know if there is still a rebase required from my side.

Regards,
Jürg

