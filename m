Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752701AbaCXJYs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 05:24:48 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:59040 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752665AbaCXJYq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 05:24:46 -0400
Date: Mon, 24 Mar 2014 09:24:41 +0000
From: Lee Jones <lee.jones@linaro.org>
To: "Opensource [Steve Twiss]" <stwiss.opensource@diasemi.com>
Cc: Guenter Roeck <linux@roeck-us.net>, Jean Delvare <jdelvare@suse.de>,
        David Dajun Chen <david.chen@diasemi.com>,
        LINUX-DOC <linux-doc@vger.kernel.org>,
        LINUX-KERNEL <linux-kernel@vger.kernel.org>,
        LM-SENSORS <lm-sensors@lm-sensors.org>,
        Mark Brown <broonie@linaro.org>,
        Philipp Zabel <p.zabel@pengutronix.de>, Rob Landley <rob@landley.net>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [RFC V1 1/3] hwmon: da9063: HWMON driver
Message-ID: <20140324092440.GN8541@lee--X1>
References: <cover.1395607051.git.stwiss.opensource@diasemi.com>
 <420d4f5c8436a66b511693531cfeda131258ce69.1395607051.git.stwiss.opensource@diasemi.com>
 <532FA8ED.2090201@roeck-us.net>
 <6ED8E3B22081A4459DAC7699F3695FB7A2AFC2F2@SW-EX-MBX01.diasemi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6ED8E3B22081A4459DAC7699F3695FB7A2AFC2F2@SW-EX-MBX01.diasemi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[...]

> >Please make sure that each patch, if applied one after another, compiles.
> >Patch 1/3 must not depend on patch 2/3.
> 
> Hi Guenter,
> 
> Thank you for this fast response.
> 
> Ah, the dependencies were not in order. I will check for that in future.
> 
> I will also look into using the API with devm_hwmon_device_register_with_groups
> and will resubmit with a RFC V2 later.

If there are inter-{patch,subsystem} dependencies within a patch-set
you need to let us know so we can ensure the patches are kept
together. If not they are likely to be sucked into their respective
subsystem trees and will break bisectability when they hit Mainline.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
