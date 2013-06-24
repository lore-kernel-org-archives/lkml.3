Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752972Ab3FXMHm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 08:07:42 -0400
Received: from mga02.intel.com ([134.134.136.20]:21039 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751952Ab3FXMHL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 08:07:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,928,1363158000"; 
   d="scan'208";a="358624966"
Date: Mon, 24 Jun 2013 14:06:50 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Kevin Strasser <kevin.strasser@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Kevin Strasser <strassek@engr.orst.edu>,
        Darren Hart <dvhart@linux.intel.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Michael Brunner <Michael.Brunner@kontron.com>,
        Michael Brunner <mibru@gmx.de>, Chris Healy <chealy@imsco-us.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Dirk Hohndel <Dirk.Hohndel@intel.com>,
        Wolfram Sang <wsa@the-dreams.de>, Ben Dooks <ben-linux@fluff.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>,
        Wim Van Sebroeck <wim@iguana.be>, linux-i2c@vger.kernel.org,
        linux-watchdog@vger.kernel.org
Subject: Re: [PATCH v3 0/4] Kontron PLD drivers
Message-ID: <20130624120650.GC30838@zurbaran>
References: <1365441321-21952-1-git-send-email-kevin.strasser@linux.intel.com>
 <1372046406-3127-1-git-send-email-kevin.strasser@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1372046406-3127-1-git-send-email-kevin.strasser@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kevin,

On Sun, Jun 23, 2013 at 09:00:02PM -0700, Kevin Strasser wrote:
> Changes since v2:
> -Change Michael's "Signed-off-by" to "Originally-From" in all patches
> -Add "From: Guenter Roeck <linux@roeck-us.net>" to gpio patch
> 
> Guenter Roeck (1):
>   gpio: Kontron PLD gpio driver
> 
> Kevin Strasser (3):
>   mfd: Kontron PLD mfd driver
>   i2c: Kontron PLD i2c bus driver
>   watchdog: Kontron PLD watchdog timer driver
I just applied (after a warning fix) and pushed the MFD driver, thanks.

I am happy to take the sub devices driver as well, although the
respective maintainers can safely carry them as they all have a Kconfig
dependency on MFD_KEMPLD. So it's up to them.
If I have to take them, I'd need Wolfram's ACK for the i2c one and Wim's
for the watchdog one. Linus already ACKed the GPIO one.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
