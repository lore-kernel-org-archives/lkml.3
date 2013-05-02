Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761804Ab3EBTL1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 15:11:27 -0400
Received: from smtprelay03.ispgateway.de ([80.67.31.30]:55967 "EHLO
	smtprelay03.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761227Ab3EBTL0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 15:11:26 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Thu, 02 May 2013 21:11:19 +0200
From: Dirk Eibach <dirk.eibach@gdsys.cc>
To: Guenter Roeck <linux@roeck-us.net>
Cc: <linux-kernel@vger.kernel.org>, Kumar Gala <galak@kernel.crashing.org>,
        Wim Van Sebroeck <wim@iguana.be>, <linux-watchdog@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>
Subject: Re: [PATCH] powerpc: Make Book E watchdog reset type configurable
In-Reply-To: <20130502161720.GA7797@roeck-us.net>
References: <1367505913-18970-1-git-send-email-dirk.eibach@gdsys.cc>
 <20130502161720.GA7797@roeck-us.net>
Message-ID: <429ec64cf7c30a139db40eb20fd3e682@gdsys.cc>
User-Agent: Roundcube Webmail/0.8.1
X-Df-Sender: ZGlyay5laWJhY2hAZ2RzeXMuY2M=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guenter,


>> diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
>> index e89fc31..6048593 100644
>> --- a/drivers/watchdog/Kconfig
>> +++ b/drivers/watchdog/Kconfig
>> @@ -1172,6 +1172,38 @@ config BOOKE_WDT_DEFAULT_TIMEOUT
>> 
>>  	  The value can be overridden by the wdt_period command-line 
>> parameter.
>> 
>> +choice
>> +	prompt "PowerPC Book-E Watchdog reset type"
>> +	depends on BOOKE_WDT
>> +	default BOOKE_WDT_RESET_CHIP
>> +	help
>> +	  Specify what kind of reset will be executed on watchdog timeout.
>> +
> Seems to me it would be much better to make this configurable via 
> platform data
> and/or device tree.

good catch. What do the device-tree gurus think to be a nice property 
name?

Cheers
Dirk
