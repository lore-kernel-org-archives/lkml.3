Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752945AbbAQWkq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2015 17:40:46 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:47683 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752244AbbAQWko (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2015 17:40:44 -0500
Date: Sat, 17 Jan 2015 22:40:21 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Ray Jui <rjui@broadcom.com>
Cc: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Wolfram Sang <wsa@the-dreams.de>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        Christian Daudt <bcm@fixthebug.org>, Matt Porter <mporter@linaro.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Scott Branden <sbranden@broadcom.com>, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        bcm-kernel-feedback-list@broadcom.com, devicetree@vger.kernel.org
Subject: Re: [PATCH v4 2/3] i2c: iproc: Add Broadcom iProc I2C Driver
Message-ID: <20150117224021.GA26493@n2100.arm.linux.org.uk>
References: <1421274213-3544-1-git-send-email-rjui@broadcom.com>
 <1421274213-3544-3-git-send-email-rjui@broadcom.com>
 <20150115084119.GN22880@pengutronix.de>
 <54B98C18.4080807@broadcom.com>
 <20150117160113.GA22880@pengutronix.de>
 <54BABEE9.8070801@broadcom.com>
 <20150117201849.GC22880@pengutronix.de>
 <54BACB66.6040909@broadcom.com>
 <20150117211017.GD22880@pengutronix.de>
 <54BAD391.9080909@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54BAD391.9080909@broadcom.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 17, 2015 at 01:26:41PM -0800, Ray Jui wrote:
> 	time_left = wait_for_completion_timeout(&iproc_i2c->done, time_left);
> 
> 	/* disable all interrupts */
> 	writel(0, iproc_i2c->base + IE_OFFSET);
> 
> 	if (!time_left && !atomic_read(&iproc_i2c->transfer_is_successful)) {

Why are you using atomic_read() here?

-- 
FTTC broadband for 0.8mile line: currently at 10.5Mbps down 400kbps up
according to speedtest.net.
