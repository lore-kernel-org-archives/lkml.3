Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753767AbbAVOtJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 09:49:09 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:35330 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752883AbbAVOtD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 09:49:03 -0500
Message-ID: <1421938131.3084.30.camel@pengutronix.de>
Subject: Re: [PATCH] dmaengine: of: bail out early if "dmas" property is not
 present
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: dmaengine@vger.kernel.org, linux-sh@vger.kernel.org,
        Magnus Damm <magnus.damm@gmail.com>, Simon Horman <horms@verge.net.au>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org
Date: Thu, 22 Jan 2015 15:48:51 +0100
In-Reply-To: <1421244988-11794-1-git-send-email-wsa@the-dreams.de>
References: <1421244988-11794-1-git-send-email-wsa@the-dreams.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.9-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:96de:80ff:fec2:9969
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, den 14.01.2015, 15:16 +0100 schrieb Wolfram Sang:
> From: Wolfram Sang <wsa+renesas@sang-engineering.com>
> 
> And don't print an error: not configured is not an error.
> 
> Reported-by: Philipp Zabel <p.zabel@pengutronix.de>
> Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>

Acked-by: Philipp Zabel <p.zabel@pengutronix.de>

thanks
Philipp

