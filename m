Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756362Ab3GRHXM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 03:23:12 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:36635 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755962Ab3GRHXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 03:23:07 -0400
Date: Thu, 18 Jul 2013 00:23:11 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Eduardo Valentin <eduardo.valentin@ti.com>
Cc: devicetree-discuss@lists.ozlabs.org, wni@nvidia.com,
        l.stach@pengutronix.de, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, lm-sensors@lm-sensors.org,
        Jean Delvare <khali@linux-fr.org>
Subject: Re: [RESEND PATCH V1 9/9] hwmon: tmp102: expose to thermal fw via DT
 nodes
Message-ID: <20130718072311.GB11120@roeck-us.net>
References: <1374074248-31690-1-git-send-email-eduardo.valentin@ti.com>
 <1374074248-31690-10-git-send-email-eduardo.valentin@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374074248-31690-10-git-send-email-eduardo.valentin@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 17, 2013 at 11:17:28AM -0400, Eduardo Valentin wrote:
> This patch adds to tmp102 temperature sensor the possibility
> to expose itself as thermal zone device, registered on the
> thermal framework.
> 
> The thermal zone is built only if a device tree node
> describing a thermal zone for this sensor is present
> inside the tmp102 DT node. Otherwise, the driver behavior
> will be the same.
> 
NACK, same reason as for the lm75 patch.

Guenter
