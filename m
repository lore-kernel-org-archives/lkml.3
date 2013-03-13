Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933817Ab3CMQyG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 12:54:06 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:50349 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933151Ab3CMQyB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 12:54:01 -0400
Message-ID: <5140AF22.2030809@wwwdotorg.org>
Date: Wed, 13 Mar 2013 10:53:54 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Doug Anderson <dianders@chromium.org>
CC: Wolfram Sang <wsa@the-dreams.de>, Kukjin Kim <kgene.kim@samsung.com>,
        linux-doc@vger.kernel.org, Daniel Kurtz <djkurtz@chromium.org>,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>,
        Ben Dooks <ben.dooks@codethink.co.uk>, u.kleine-koenig@pengutronix.de,
        Grant Grundler <grundler@chromium.org>,
        devicetree-discuss@lists.ozlabs.org,
        Rob Herring <rob.herring@calxeda.com>,
        Jean Delvare <khali@linux-fr.org>,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        Girish Shivananjappa <girish.shivananjappa@linaro.org>,
        bhushan.r@samsung.com,
        Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        sreekumar.c@samsung.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Peter Korsgaard <peter.korsgaard@barco.com>,
        Yuvaraj Kumar <yuvaraj.cd@gmail.com>,
        Prashanth G <prashanth.g@samsung.com>
Subject: Re: [PATCH v4 1/3] i2c: mux: Add i2c-arbitrator-cros-ec 'mux' driver
References: <1360957573-864-1-git-send-email-dianders@chromium.org> <1363192583-26363-1-git-send-email-dianders@chromium.org>
In-Reply-To: <1363192583-26363-1-git-send-email-dianders@chromium.org>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/13/2013 10:36 AM, Doug Anderson wrote:
> The i2c-arbitrator-cros-ec driver implements the arbitration scheme
> that the Embedded Controller (EC) on the ARM Chromebook expects to use
> for bus multimastering.  This i2c-arbitrator-cros-ec driver could also
> be used in other places where standard I2C bus arbitration can't be
> used and two extra GPIOs are available for arbitration.
> 
> This driver is based on code that Simon Glass added to the i2c-s3c2410
> driver in the Chrome OS kernel 3.4 tree.  The current incarnation as a
> mux driver is as suggested by Grant Likely.  See
> <https://patchwork.kernel.org/patch/1877311/> for some history.
...
> Changes in v4: None

Isn't this 'PATCH V3 REPOST' then?
