Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753194Ab3EIUog (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 16:44:36 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:46077 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752254Ab3EIUoe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 16:44:34 -0400
Date: Thu, 9 May 2013 13:44:34 -0700
From: Olof Johansson <olof@lixom.net>
To: Christian Daudt <csd@broadcom.com>
Cc: Russell King <linux@arm.linux.org.uk>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, Arnd Bergmann <arnd@arndb.de>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Will Deacon <will.deacon@arm.com>, "arm@kernel.org" <arm@kernel.org>,
        linux-arm-kernel@lists.infradead.org, csd_b@daudt.org,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Josh Cartwright <josh.cartwright@ni.com>,
        Yehuda Yitschak <yehuday@marvell.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] ARM: bcm281xx: Add L2 support for Rev A2 chips
Message-ID: <20130509204434.GA16724@quad.lixom.net>
References: <1367542653-955-1-git-send-email-csd@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1367542653-955-1-git-send-email-csd@broadcom.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 02, 2013 at 05:57:33PM -0700, Christian Daudt wrote:
> Rev A2 SoCs have an unorthodox memory re-mapping and this needs
> to be reflected in the cache operations.
> This patch adds new outer cache functions for the l2x0 driver
> to support this SoC revision. It also adds a new compatible
> value for the cache to enable this functionality.
> 
> Updates from V1:
> - remove section 1 altogether and note that in comments
> - simplify section selection caused by section 1 removal
> - BUG_ON just in case section 1 shows up
> 
> Signed-off-by: Christian Daudt <csd@broadcom.com>

This patch mostly covers code that is on Russells plate, so please feed
this to his tracker to be picked up by him. Feel free to add:

Acked-by: Olof Johansson <olof@lixom.net>


Thanks,

-Olof
