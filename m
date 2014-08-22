Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756666AbaHVPYM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 11:24:12 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33366 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756459AbaHVPYK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 11:24:10 -0400
Message-ID: <53F76097.8020800@suse.com>
Date: Fri, 22 Aug 2014 11:24:07 -0400
From: Jeff Mahoney <jeffm@suse.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>,
        LMML <linux-media@vger.kernel.org>
Subject: Re: Autoselecting SPI for MEDIA_SUBDRV_AUTOSELECT?
References: <53F75B26.2020101@suse.com> <53F75F02.2030300@iki.fi>
In-Reply-To: <53F75F02.2030300@iki.fi>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri Aug 22 11:17:22 2014, Antti Palosaari wrote:
> Moikka!
>
> On 08/22/2014 06:00 PM, Jeff Mahoney wrote:
>> -----BEGIN PGP SIGNED MESSAGE-----
>> Hash: SHA1
>>
>> Hi Antti -
>>
>> Commit e4462ffc160 ([media] Kconfig: sub-driver auto-select SPI bus)
>> enables CONFIG_SPI globally for a driver that won't even be enabled in
>> many cases.
>>
>> Is there a reason USB_MSI2500 doesn't select SPI instead of
>> MEDIA_SUBDRV_AUTOSELECT?
>
> Nothing but I decided to set it similarly as I2C, another more common
> bus. IIRC same was for I2C_MUX too.
>
> You could still disable media subdriver autoselect and then disable
> SPI and select all the media drivers (excluding MSSi2500) manually.
>
> I have feeling that media auto-select was added to select everything
> needed for media.

Ok, that makes sense. I suppose I'll still need to enable SPI just for 
this device and disable every other SPI device anyway. I'll live.

Thanks,

-Jeff

--
Jeff Mahoney
SUSE Labs
