Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754521AbaGPJlu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 05:41:50 -0400
Received: from eth2015.qld.adsl.internode.on.net ([150.101.176.226]:44488 "EHLO
	atomos.longlandclan.yi.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751477AbaGPJls (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 05:41:48 -0400
X-Greylist: delayed 505 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 Jul 2014 05:41:47 EDT
Message-ID: <53C64759.8020505@vrt.com.au>
Date: Wed, 16 Jul 2014 19:35:21 +1000
From: Stuart Longland <stuartl@vrt.com.au>
Organization: VRT Systems
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Mark Rutland <mark.rutland@arm.com>
CC: Roman Fietze <roman.fietze@telemotive.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH] drivers/rtc/rtc-isl12022.c: Device tree support
References: <1405477705-16885-2-git-send-email-stuartl@vrt.com.au> <20140716085904.GA26951@leverpostej>
In-Reply-To: <20140716085904.GA26951@leverpostej>
X-Enigmail-Version: 1.6
OpenPGP: id=10BDE3B7;
	url=http://stuartl.longlandclan.yi.org/key.asc
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,
On 16/07/14 18:59, Mark Rutland wrote:
> On Wed, Jul 16, 2014 at 03:28:25AM +0100, Stuart Longland wrote:
>> Add some support for configuring isl12020/isl12022 devices using the
>> Device Tree blob.
>>
>> Signed-off-by: Stuart Longland <stuartl@vrt.com.au>
> 
> Please document this as with isl,isl12057, in
> Documentation/devicetree/bindings/i2c/trivial-devices.txt
> 
> The string itself looks fine.

No problems.  I'll do this shortly.

>> +#ifdef CONFIG_OF
>> +		.of_match_table = of_match_ptr(isl12022_dt_match),
>> +#endif
> 
> You can drop the ifdef here, of_match_ptr(x) is NULL if !CONFIG_OF.

Ahh okay, I wasn't sure how of_match_ptr worked, so I thought I'd play
it safe.  A revised patch is coming right up.

Regards,
-- 
Stuart Longland
Systems Engineer
     _ ___
\  /|_) |                           T: +61 7 3535 9619
 \/ | \ |     38b Douglas Street    F: +61 7 3535 9699
   SYSTEMS    Milton QLD 4064       http://www.vrt.com.au


