Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754505AbbA0Kh5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 05:37:57 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44770 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751425AbbA0Khz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 05:37:55 -0500
Subject: Re: [lm-sensors] [PATCH] hwmon: (ads7828) Make sample interval
 configurable
From: Jean Delvare <jdelvare@suse.de>
To: Robert Rosengren <robert.rosengren@axis.com>
Cc: Guenter Roeck <linux@roeck-us.net>, lm-sensors <lm-sensors@lm-sensors.org>,
        Johan Adolfsson <johana@axis.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <54C74567.9020201@axis.com>
References: <1421409922-28299-1-git-send-email-robert.rosengren@axis.com>
	 <54B92596.2040206@roeck-us.net> <20150116183020.GA6262@roeck-us.net>
	 <54C74567.9020201@axis.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Suse Linux
Date: Tue, 27 Jan 2015 11:37:50 +0100
Message-ID: <1422355070.4499.136.camel@chaos.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Robert,

Le Tuesday 27 January 2015 à 08:59 +0100, Robert Rosengren a écrit :
> On 01/16/2015 07:30 PM, Guenter Roeck wrote:
> > I sent a couple of patches a minute ago which should take care of the issue.
> > Would be great if you can test it.
> I applied the v2 versions of the patches for a quick test, but it was 
> not successful. Haven't done any further investigation on what the 
> problem might be, but when trying to read the sysfs driver I get "read 
> error: No such device or address".
> 
> The sysfs path have moved with the REGMAP settings, from 
> /sys/bus/i2c/devices/<x>/in0_input to 
> /sys/bus/i2c/devices/<x>/hwmon/hwmon0/in0_input.

This is expected, shouldn't be an issue if you are using a
libsensors-based application with a recent enough version of libsensors.

> Any ideas? Haven't had REGMAP configured in my kernel earlier, might it 
> be some specific configuration I miss?

How are you testing/reading exactly?

-- 
Jean Delvare
SUSE L3 Support

