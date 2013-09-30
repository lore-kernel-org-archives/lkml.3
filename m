Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754691Ab3I3IVf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 04:21:35 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:36200 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753210Ab3I3IVd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 04:21:33 -0400
Date: Mon, 30 Sep 2013 10:20:58 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Xiubo Li <Li.Xiubo@freescale.com>
Cc: r65073@freescale.com, thierry.reding@gmail.com, swarren@wwwdotorg.org,
        t.figa@samsung.com, grant.likely@linaro.org, linux@arm.linux.org.uk,
        rob@landley.net, ian.campbell@citrix.com, mark.rutland@arm.com,
        pawel.moll@arm.com, rob.herring@calxeda.com,
        linux-arm-kernel@lists.infradead.org, linux-pwm@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCHv5 0/4] Add Freescale FTM PWM driver.
Message-ID: <20130930082058.GB30088@pengutronix.de>
Mail-Followup-To: Xiubo Li <Li.Xiubo@freescale.com>, r65073@freescale.com,
	thierry.reding@gmail.com, swarren@wwwdotorg.org, t.figa@samsung.com,
	grant.likely@linaro.org, linux@arm.linux.org.uk, rob@landley.net,
	ian.campbell@citrix.com, mark.rutland@arm.com, pawel.moll@arm.com,
	rob.herring@calxeda.com, linux-arm-kernel@lists.infradead.org,
	linux-pwm@vger.kernel.org, linux-kernel@vger.kernel.org,
	devicetree@vger.kernel.org, linux-doc@vger.kernel.org
References: <1380521611-2764-1-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1380521611-2764-1-git-send-email-Li.Xiubo@freescale.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 10:19:49 up 36 days, 17:50, 45 users,  load average: 0.13, 0.11,
 0.07
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:5054:ff:fec0:8e10
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 30, 2013 at 02:13:27PM +0800, Xiubo Li wrote:
> Hello,
> 
> This patch series is the Freescale FTM PWM implementation. And there are 8 channels most supported by the FTM PWM. This implementation is only compatible with device tree definition.
> 
> This patch series is based on linux-next and has been tested on Vybrid VF610 Tower board using device tree.

Looks good to me now. Thanks for fixing.

For the series:

Reviewed-by: Sascha Hauer <s.hauer@pengutronix.de>

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
