Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753580AbaAWK5j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 05:57:39 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:60380 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752868AbaAWK5g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 05:57:36 -0500
Date: Thu, 23 Jan 2014 11:57:32 +0100
From: Markus Pargmann <mpa@pengutronix.de>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Chris Ruehl <chris.ruehl@gtsys.com.hk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arm@lists.infradead.org
Subject: Re: [PATCH 2/2 v2] imx27: pinctrl: fix offset calculation in
 imx_read_2bit
Message-ID: <20140123105732.GD25016@pengutronix.de>
References: <1390360492-29126-1-git-send-email-chris.ruehl@gtsys.com.hk>
 <1390360492-29126-2-git-send-email-chris.ruehl@gtsys.com.hk>
 <CACRpkdbWY8Ny0wNo0tM9WWG4uB2xOKV6zvFcqJ__qbku9VRN9g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CACRpkdbWY8Ny0wNo0tM9WWG4uB2xOKV6zvFcqJ__qbku9VRN9g@mail.gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 11:54:58 up 151 days, 20:25, 49 users,  load average: 0.14, 0.10,
 0.08
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:5054:ff:fec0:8e10
X-SA-Exim-Mail-From: mpa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Jan 23, 2014 at 09:26:06AM +0100, Linus Walleij wrote:
> On Wed, Jan 22, 2014 at 4:14 AM, Chris Ruehl <chris.ruehl@gtsys.com.hk> wrote:
> 
> > The offset for the 2bit register calculate wrong, this patch
> > fixes the problem. The debugfs printout for oconf, iconfa, iconfb
> > now shows the real values.
> >
> > Signed-off-by: Chris Ruehl <chris.ruehl@gtsys.com.hk>
> 
> Markus: this OK? I want your review tag on it.

Yes this one is also ok.

Reviewed-by: Markus Pargmann <mpa@pengutronix.de>

Regards,

Markus

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
