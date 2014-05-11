Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758048AbaEKLMg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 07:12:36 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39661 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757829AbaEKLMf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 07:12:35 -0400
Date: Sun, 11 May 2014 13:12:28 +0200
From: Jean Delvare <jdelvare@suse.de>
To: Josef Gajdusek <atx@atx.name>
Cc: linux@roeck-us.net, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/hwmon: bugfix and support for emc1412 in
 emc1403.c
Message-ID: <20140511131228.019bdba5@endymion.delvare>
In-Reply-To: <20140511103152.GA5631@dashie>
References: <20140511103152.GA5631@dashie>
Organization: SUSE Linux
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Josef,

On Sun, 11 May 2014 12:31:52 +0200, Josef Gajdusek wrote:
> Adds support for emc1412 to emc1403.c + minor bugfix
> 
> * Renamed generic thermal_* prefixed names to emc1403_*

Why? This adds a lot of noise to your patch and the benefit isn't
obvious. If you really want to do that, then it should be a separate
patch.

> * Fixed set_hyst being broken (i. e. writing 86000 set hysteresis to 84000)

Bug fixes should be sent as separate patches, so that they can be
ported back to stable, long-term and distribution kernels.

> * Added support for emc1412
> 
> Signed-off-by: Josef Gajdusek <atx@atx.name>

> +MODULE_ALIAS("i2c:emc1403");

Why add an alias which is already present?

-- 
Jean Delvare
SUSE L3 Support
