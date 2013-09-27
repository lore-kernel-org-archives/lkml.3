Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754167Ab3I0QM0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 12:12:26 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:33968 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754031Ab3I0QMU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 12:12:20 -0400
Date: Fri, 27 Sep 2013 09:12:14 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Mark Brown <broonie@kernel.org>, Jean Delvare <khali@linux-fr.org>,
        Jonathan Cameron <jic23@kernel.org>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-spi@vger.kernel.org
Subject: Re: [PATCH 2/3] hwmon: (adt7310) Use spi_w8r16be() instead
 spi_w8r16()
Message-ID: <20130927161214.GA10392@roeck-us.net>
References: <1380292469-17347-1-git-send-email-lars@metafoo.de>
 <1380292469-17347-2-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1380292469-17347-2-git-send-email-lars@metafoo.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 27, 2013 at 04:34:28PM +0200, Lars-Peter Clausen wrote:
> Using spi_w8r16be() instead of spi_w8r16() in this driver makes a code a bit
> shorter and cleaner.
> 
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>

Acked-by: Guenter Roeck <linux@roeck-us.net>

Would this patch go through the SPI tree ?

Thanks,
Guenter
