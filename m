Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932234AbaFHUQQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2014 16:16:16 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:51127 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753820AbaFHUQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2014 16:16:08 -0400
Date: Sun, 8 Jun 2014 13:16:00 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Fabio Baltieri <fabio.baltieri@gmail.com>
Cc: Jean Delvare <jdelvare@suse.de>, Lothar Felten <l-felten@ti.com>,
        lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hwmon: (ina2xx) Change register cache to signed
Message-ID: <20140608201600.GA30953@roeck-us.net>
References: <1402174021-25857-1-git-send-email-fabio.baltieri@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402174021-25857-1-git-send-email-fabio.baltieri@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 07, 2014 at 09:47:01PM +0100, Fabio Baltieri wrote:
> All devices supported by the ina2xx driver are bidirectional and reports
> the measured value as a signed 16 bit, but the current driver
> implementation caches the number as an u16, leading to an incorrect sign
> extension when reporting to the userspace in ina2xx_get_value().
> 
> This patch fixes the problem by using a s16 instead, and has been tested
> on an INA219.
> 
> Signed-off-by: Fabio Baltieri <fabio.baltieri@gmail.com>

Applied.

Thanks,
Guenter
