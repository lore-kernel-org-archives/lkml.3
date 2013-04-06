Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422702Ab3DFJ7L (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Apr 2013 05:59:11 -0400
Received: from nws-gwwien.ortnergmbh.at ([83.64.229.139]:60294 "HELO
	nws-gwwien.ortnergmbh.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1163287Ab3DFJ7K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Apr 2013 05:59:10 -0400
Message-ID: <515FF037.5080802@winischhofer.net>
Date: Sat, 06 Apr 2013 11:51:51 +0200
From: Thomas Winischhofer <thomas@winischhofer.net>
User-Agent: Thunderbird 2.0.0.24 (Macintosh/20100228)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: balbi@ti.com, Alan Stern <stern@rowland.harvard.edu>,
        Florian Fainelli <florian@openwrt.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        gregkh@linuxfoundation.org, USB list <linux-usb@vger.kernel.org>
Subject: Re: [PATCH 1/5 v3] USB: regroup all depends on USB within an if USB
 block
References: <20130404171429.GF5129@arwen.pp.htv.fi> <Pine.LNX.4.44L0.1304041339530.1324-100000@iolanthe.rowland.org> <20130404180229.GA5926@arwen.pp.htv.fi> <201304041942.23259.arnd@arndb.de>
In-Reply-To: <201304041942.23259.arnd@arndb.de>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Arnd Bergmann wrote:
> On Thursday 04 April 2013, Felipe Balbi wrote:
>> On Thu, Apr 04, 2013 at 01:42:18PM -0400, Alan Stern wrote:
>>>>> diff --git a/drivers/usb/misc/sisusbvga/Kconfig b/drivers/usb/misc/sisusbvga/Kconfig
>>>>> index 30ea7ca..0d03a52 100644
>>>>> --- a/drivers/usb/misc/sisusbvga/Kconfig
>>>>> +++ b/drivers/usb/misc/sisusbvga/Kconfig
>>>>> @@ -1,7 +1,7 @@
>>>>>  
>>>>>  config USB_SISUSBVGA
>>>>>   tristate "USB 2.0 SVGA dongle support (Net2280/SiS315)"
>>>>> - depends on USB && (USB_MUSB_HDRC || USB_EHCI_HCD)
>>>>> + depends on (USB_MUSB_HDRC || USB_EHCI_HCD)
>>>> is it just me or would everybody agree that depending on MUSB or EHCI
>>>> here is wrong ?
>>> That line certainly looks like it could be removed entirely.  Perhaps 
>>> the original author can enlighten us.
>>>
>>> In any case, it's not relevant to the purpose of this patch set.
>> right :-)
>>
> 
> Originally it had just "depends on USB_EHCI_HCD" and the text mentions that
> it requires USB 2.0, so it probably comes from a time where EHCI was the
> only high speed capable USB HCD.
> 
> 	Arnd
> 

That's exactly right.

Thomas

- --
Thomas Winischhofer
thomas AT winischhofer DOT net
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (Darwin)

iD8DBQFRX/A3zydIRAktyUcRAo+YAJ9bmOrODMsIiBessMNnrmYJLYvmhwCgyABL
z9A6pb1sab2VwnI8i5v3bCI=
=HNat
-----END PGP SIGNATURE-----
