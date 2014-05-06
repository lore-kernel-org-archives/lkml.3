Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934082AbaEFDPZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 23:15:25 -0400
Received: from mail.active-venture.com ([67.228.131.205]:61614 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933762AbaEFDPU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 23:15:20 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <536853C0.8020406@roeck-us.net>
Date: Mon, 05 May 2014 20:15:12 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Tomas Pop <tomas.pop.mff@gmail.com>
CC: "jdelvare@suse.de" <jdelvare@suse.de>, lm-sensors@lm-sensors.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        johannes.winkelmann@sensirion.com
Subject: Re: [RFC][PATCH v2] hwmon: add support for Sensirion SHTC1 sensor
References: <1398985530.17142.15.camel@ltli10.sensirion.lokal>		 <5362FDA9.8080300@roeck-us.net>		 <1399064369.3019.83.camel@ltli10.sensirion.lokal>		 <20140502231528.GA5157@roeck-us.net>	 <1399338214.24993.10.camel@ltli10.sensirion.lokal>	 <53683D38.7010904@roeck-us.net> <1399341707.24993.20.camel@ltli10.sensirion.lokal>
In-Reply-To: <1399341707.24993.20.camel@ltli10.sensirion.lokal>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/05/2014 07:01 PM, Tomas Pop wrote:
> Hi Guenter,
>
> Thanks a lot for comments and patience - with the testing you are right,
> I'm still waiting for board, where I will be able to run latest kernel
> and have the chip wired in - sorry for this...
>

No problem. Please make sure that the driver has been tested with the real
chip before the final submission.

Just wondering - don't you have a little test board to make the i2c pins
more readily available ? Such a board could be connected to any i2c adapter
and/or to a mainboard which exposes i2c pins. That is usually how I test
the various sensors I am working with. You could even sell that to the
hobbyists :-).

Thanks,
Guenter

