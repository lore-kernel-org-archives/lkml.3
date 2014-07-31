Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752483AbaGaTVd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 15:21:33 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39523 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752245AbaGaTVc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 15:21:32 -0400
Message-ID: <53DA9738.6080809@suse.de>
Date: Thu, 31 Jul 2014 21:21:28 +0200
From: =?UTF-8?B?QW5kcmVhcyBGw6RyYmVy?= <afaerber@suse.de>
Organization: SUSE LINUX Products GmbH
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Tomasz Figa <tomasz.figa@gmail.com>, linux-samsung-soc@vger.kernel.org
CC: Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>,
        Vincent Palatin <vpalatin@chromium.org>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        open list <linux-kernel@vger.kernel.org>,
        Kumar Gala <galak@codeaurora.org>,
        Stephan van Schaik <stephan@synkhronix.com>,
        Doug Anderson <dianders@chromium.org>,
        Rob Herring <robh+dt@kernel.org>, Ben Dooks <ben-linux@fluff.org>,
        Russell King <linux@arm.linux.org.uk>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 3/4] ARM: dts: Clean up exynos5250-snow
References: <1406822910-6255-1-git-send-email-afaerber@suse.de> <1406822910-6255-4-git-send-email-afaerber@suse.de> <53DA96C7.30009@gmail.com>
In-Reply-To: <53DA96C7.30009@gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 31.07.2014 21:19, schrieb Tomasz Figa:
> Andreas,
> 
> Please see my comments inline.
> 
> On 31.07.2014 18:08, Andreas Färber wrote:
>> Use the new style of referencing inherited nodes and use symbolic names.
>>
>> Suggested-by: Doug Anderson <dianders@chromium.org>
>> Signed-off-by: Andreas Färber <afaerber@suse.de>
> 
> [snip]
> 
>> -
>>  	usb@12110000 {
>> -		samsung,vbus-gpio = <&gpx1 1 0>;
>> +		samsung,vbus-gpio = <&gpx1 1 GPIO_ACTIVE_HIGH>;
>>  	};
> 
> This is a higher level node being overridden, so it should be specified
> using references too.
> 
>>  
>>  	fixed-rate-clocks {
>> @@ -287,7 +206,7 @@
>>  	};
>>  
>>  	hdmi {
> 
> Ditto.

Same problem as with spring: We need the labels first!

Andreas

-- 
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg, Germany
GF: Jeff Hawn, Jennifer Guild, Felix Imendörffer; HRB 16746 AG Nürnberg
