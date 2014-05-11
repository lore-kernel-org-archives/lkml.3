Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932388AbaEKLeq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 07:34:46 -0400
Received: from [31.31.75.104] ([31.31.75.104]:47026 "EHLO twilight"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757805AbaEKLep convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 07:34:45 -0400
X-Greylist: delayed 423 seconds by postgrey-1.27 at vger.kernel.org; Sun, 11 May 2014 07:34:45 EDT
Mime-Version: 1.0
Date: Sun, 11 May 2014 11:27:38 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <b9f6fe08e91b81bfd870105ab36a531c@rainloop.atalax.net>
X-Mailer: RainLoop/1.6.5.902
From: atx@atx.name
Subject: Re[2]: [PATCH] drivers/hwmon: bugfix and support for emc1412 in
 emc1403.c
To: "Jean Delvare" <jdelvare@suse.de>
Cc: linux@roeck-us.net, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20140511131228.019bdba5@endymion.delvare>
References: <20140511131228.019bdba5@endymion.delvare>
 <20140511103152.GA5631@dashie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

May 11 2014 1:12 PM, "Jean Delvare"  wrote: 

> Hi Josef,
> 
> On Sun, 11 May 2014 12:31:52 +0200, Josef Gajdusek wrote:
> 
> 
>> Adds support for emc1412 to emc1403.c + minor bugfix
>> 
>> * Renamed generic thermal_* prefixed names to emc1403_*
>> 
>> 
>> Why? This adds a lot of noise to your patch and the benefit isn't
>> obvious. If you really want to do that, then it should be a separate
>> patch.
>> 
>> 
>>> * Fixed set_hyst being broken (i. e. writing 86000 set hysteresis to 84000)
>>> 
>> 
>> 
>> Bug fixes should be sent as separate patches, so that they can be
>> ported back to stable, long-term and distribution kernels.
>> 
>> 
>> * Added support for emc1412
>> 
>> Signed-off-by: Josef Gajdusek 
>> 
>> +MODULE_ALIAS("i2c:emc1403");
>> 
> 
> 
> Why add an alias which is already present?
> 
> --
> Jean Delvare
> SUSE L3 Support
> 


Hello,
thanks for your feedback. I am going to split and change the patches as you suggested and then resend within few hours.

Josef Gajdusek <atx@atx.name>
