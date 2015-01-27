Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757557AbbA0H7l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 02:59:41 -0500
Received: from bes.se.axis.com ([195.60.68.10]:58837 "EHLO bes.se.axis.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753188AbbA0H7i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 02:59:38 -0500
Message-ID: <54C74567.9020201@axis.com>
Date: Tue, 27 Jan 2015 08:59:35 +0100
From: Robert Rosengren <robert.rosengren@axis.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.3.0
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>, Jean Delvare <jdelvare@suse.de>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>
CC: Johan Adolfsson <johana@axis.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [lm-sensors] [PATCH] hwmon: (ads7828) Make sample interval configurable
References: <1421409922-28299-1-git-send-email-robert.rosengren@axis.com> <54B92596.2040206@roeck-us.net> <20150116183020.GA6262@roeck-us.net>
In-Reply-To: <20150116183020.GA6262@roeck-us.net>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/16/2015 07:30 PM, Guenter Roeck wrote:
> I sent a couple of patches a minute ago which should take care of the issue.
> Would be great if you can test it.
I applied the v2 versions of the patches for a quick test, but it was 
not successful. Haven't done any further investigation on what the 
problem might be, but when trying to read the sysfs driver I get "read 
error: No such device or address".

The sysfs path have moved with the REGMAP settings, from 
/sys/bus/i2c/devices/<x>/in0_input to 
/sys/bus/i2c/devices/<x>/hwmon/hwmon0/in0_input.

Any ideas? Haven't had REGMAP configured in my kernel earlier, might it 
be some specific configuration I miss?

BR,
Robert
