Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753107Ab3KZDDQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 22:03:16 -0500
Received: from mail-pb0-f51.google.com ([209.85.160.51]:40389 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751749Ab3KZDDM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 22:03:12 -0500
Date: Mon, 25 Nov 2013 19:03:08 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-input@vger.kernel.org, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Input: ads7846: Convert to
 devm_hwmon_device_register_with_groups
Message-ID: <20131126030308.GF31517@core.coreip.homeip.net>
References: <1385242620-21719-1-git-send-email-linux@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1385242620-21719-1-git-send-email-linux@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guenter,

On Sat, Nov 23, 2013 at 01:37:00PM -0800, Guenter Roeck wrote:
> Simplify the code and create mandatory 'name' attribute by using
> new hwmon API.
> 
> Also use is_visible to determine visible attributes instead of creating
> several different attribute groups.

This change does not quite work without converting the rest of the
driver to devm_ resources as it makes hwmon outlive regulator and other
essential resources when unbinding driver from the device.

Thanks.

-- 
Dmitry
