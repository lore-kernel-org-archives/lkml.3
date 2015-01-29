Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753860AbbA2HBB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 02:01:01 -0500
Received: from bes.se.axis.com ([195.60.68.10]:49485 "EHLO bes.se.axis.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751108AbbA2HA7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 02:00:59 -0500
Message-ID: <54C9DA9D.3010802@axis.com>
Date: Thu, 29 Jan 2015 08:00:45 +0100
From: Robert Rosengren <robert.rosengren@axis.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.3.0
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>, Jean Delvare <jdelvare@suse.de>
CC: "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        Johan Adolfsson <johana@axis.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [lm-sensors] [PATCH] hwmon: (ads7828) Make sample interval configurable
References: <1421409922-28299-1-git-send-email-robert.rosengren@axis.com>	<54B92596.2040206@roeck-us.net>	<20150116183020.GA6262@roeck-us.net>	<54C74567.9020201@axis.com>	<54C79B87.8040607@roeck-us.net>	<4BEA3FF3CAA35E408EA55C7BE2E61D05943B6DD753@xmail3.se.axis.com>	<20150127200553.GA5689@roeck-us.net> <20150127233455.0c62457e@endymion.delvare> <54C86035.9080605@roeck-us.net> <54C87F3C.2020105@axis.com> <54C8F73D.4040808@roeck-us.net>
In-Reply-To: <54C8F73D.4040808@roeck-us.net>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/28/2015 03:50 PM, Guenter Roeck wrote:
> Can you possibly send me the output from i2cdump ? That might help figuring out what is going on.
I don't have i2cdump (I suppose that you mean the lm-sensors tool) 
available for my hardware. I'll give it a go to compile it...

BR,
Robert
