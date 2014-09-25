Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751572AbaIYG1E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 02:27:04 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:34818 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774AbaIYG1D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 02:27:03 -0400
Date: Thu, 25 Sep 2014 08:26:48 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: linux-arm-kernel@lists.infradead.org, gerg@uclinux.org,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        ARM Maintainers <arm@kernel.org>, linux-kernel@vger.kernel.org,
        Patrice Vilchez <patrice.vilchez@atmel.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Subject: Re: [RFC PATCH] ARM: at91: remove no-MMU at91x40 support
Message-ID: <20140925062648.GJ3755@pengutronix.de>
References: <1411568281-3924-1-git-send-email-nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1411568281-3924-1-git-send-email-nicolas.ferre@atmel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Nicolas,

On Wed, Sep 24, 2014 at 04:18:01PM +0200, Nicolas Ferre wrote:
> As there is currently no-one to take care of this old !MMU target and as its
> support in recent kernels is a bit rotten, remove this at91x40 support and the
> board file associated with it (at91eb01).
> There are modern ARM !MMU in Mainline now so this target is not interesting for
s/Mainline/mainline/

> building tests anymore. It would be better to start from these modern ARM !MMU
> platforms to reintroduce at91x40 support if needed.
This last sentence doesn't sound convincing. at91x40 is an ARM7TDMI
while the "modern ARM !MMU" targets base on Cortex-M.

Anyhow, the change is fine, so:

Acked-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
