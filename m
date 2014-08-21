Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753930AbaHUSnA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 14:43:00 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:45963 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752475AbaHUSm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 14:42:58 -0400
Date: Thu, 21 Aug 2014 11:42:54 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Andreas Werner <andreas.werner@men.de>
Cc: linux-kernel@vger.kernel.org, sameo@linux.intel.com, lee.jones@linaro.org,
        wim@iguana.be, linux-watchdog@vger.kernel.org, cooloney@gmail.com,
        rpurdie@rpsys.net, linux-leds@vger.kernel.org, jdelvare@suse.de,
        lm-sensors@lm-sensors.org
Subject: Re: [PATCH v4 2/4] drivers/watchdog/menf21bmc_wdt: introduce MEN
 14F021P00 BMC Watchdog driver
Message-ID: <20140821184254.GB16045@roeck-us.net>
References: <cover.1407918792.git.andreas.werner@men.de>
 <af461d35d8e7e6300fd3bd2cb4e94f78d5445132.1407918792.git.andreas.werner@men.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <af461d35d8e7e6300fd3bd2cb4e94f78d5445132.1407918792.git.andreas.werner@men.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 13, 2014 at 10:39:59AM +0200, Andreas Werner wrote:
> Added driver to support the 14F021P00 BMC Watchdog.
> The BMC is a Board Management Controller including watchdog functionality.
> 
> Signed-off-by: Andreas Werner <andreas.werner@men.de>

Reviewed-by: Guenter Roeck <linux@roeck-us.net>
