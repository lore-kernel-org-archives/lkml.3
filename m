Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753149AbbAZGr0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 01:47:26 -0500
Received: from mga02.intel.com ([134.134.136.20]:16736 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751591AbbAZGrY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 01:47:24 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,467,1418112000"; 
   d="scan'208";a="675851989"
Date: Sun, 25 Jan 2015 22:45:36 -0800
From: Vinod Koul <vinod.koul@intel.com>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: dmaengine@vger.kernel.org, linux-sh@vger.kernel.org,
        Magnus Damm <magnus.damm@gmail.com>, Simon Horman <horms@verge.net.au>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Philipp Zabel <p.zabel@pengutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dmaengine: of: bail out early if "dmas" property is not
 present
Message-ID: <20150126064536.GK28763@intel.com>
References: <1421244988-11794-1-git-send-email-wsa@the-dreams.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421244988-11794-1-git-send-email-wsa@the-dreams.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14, 2015 at 03:16:28PM +0100, Wolfram Sang wrote:
> From: Wolfram Sang <wsa+renesas@sang-engineering.com>
> 
> And don't print an error: not configured is not an error.
> 
Applied, thanks

This must be record for Acks per lines :)

-- 
~Vinod
