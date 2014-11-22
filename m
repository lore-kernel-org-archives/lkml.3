Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752520AbaKVSp4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2014 13:45:56 -0500
Received: from mail-wi0-f179.google.com ([209.85.212.179]:38887 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752441AbaKVSpw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2014 13:45:52 -0500
Message-ID: <5470D9DC.70807@gmail.com>
Date: Sat, 22 Nov 2014 20:45:48 +0200
From: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: =?UTF-8?B?UGFsaSBSb2jDoXI=?= <pali.rohar@gmail.com>,
        Sakari Ailus <sakari.ailus@iki.fi>
CC: Tony Lindgren <tony@atomide.com>, Pavel Machek <pavel@ucw.cz>,
        sre@debian.org, sre@ring0.de,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org, khilman@kernel.org, aaro.koskinen@iki.fi,
        freemangordon@abv.bg, bcousson@baylibre.com, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        devicetree@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [RFC] adp1653: Add device tree bindings for LED controller
References: <20141116075928.GA9763@amd> <201411171601.32311@pali> <20141117150407.GP8907@valkosipuli.retiisi.org.uk> <201411171615.34822@pali>
In-Reply-To: <201411171615.34822@pali>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

>> Can you capture raw bayer images correctly? I assume green
>> means YUV buffers that are all zero.
>>
>> Do you know more specifically which patch breaks it?
>
> CCing freemangordon (Ivaylo Dimitrov). He tried to debug it
> months ago but without success. Should know more info about this
> problem.
>
> I think that commit which broke it was not bisected...
>

According to my vague memories, the green captured image was a result 
from the ISP IRQ never got triggered. I tried to find why, but never 
succeeded.

Sakari, we discussed that on #maemo-ssu when I was playing with cameras, 
and there is nothing new in that regard:
http://mg.pov.lt/maemo-ssu-irclog/%23maemo-ssu.2013-09-18.log.html#t2013-09-18T18:46:38 

