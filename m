Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753611AbaI1JIn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2014 05:08:43 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:40405 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753371AbaI1JIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2014 05:08:42 -0400
Date: Sun, 28 Sep 2014 11:08:38 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-gpio@vger.kernel.org
Subject: Re: [PATCH] pinctrl: remove remaining users of gpiochip_remove()
 retval
Message-ID: <20140928090838.GD31554@pengutronix.de>
References: <1410905274-22339-1-git-send-email-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1410905274-22339-1-git-send-email-linus.walleij@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Linus,

On Tue, Sep 16, 2014 at 03:07:54PM -0700, Linus Walleij wrote:
> Some drivers accidentally still use the return value from
> gpiochip_remove(). Get rid of them so we can simplify this function
> and get rid of the return value.
> 
> Abdoulaye Berthe <berthe.ab@gmail.com>
Is there a "Signed-off-by: " (or an other tag) missing?

> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>

Best regards
Uwe
-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
