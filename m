Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753396AbaKRIJT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 03:09:19 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:20573 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750912AbaKRIJR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 03:09:17 -0500
X-AuditID: cbfec7f5-b7f956d000005ed7-bc-546afea6b263
Message-id: <546AFEA5.9020000@samsung.com>
Date: Tue, 18 Nov 2014 09:09:09 +0100
From: Jacek Anaszewski <j.anaszewski@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804
 Thunderbird/17.0.8
MIME-version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>, Pavel Machek <pavel@ucw.cz>
Cc: pali.rohar@gmail.com, sre@debian.org, sre@ring0.de,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org, tony@atomide.com, khilman@kernel.org,
        aaro.koskinen@iki.fi, freemangordon@abv.bg, bcousson@baylibre.com,
        robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        devicetree@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [RFC] adp1653: Add device tree bindings for LED controller
References: <20141116075928.GA9763@amd>
 <20141117145857.GO8907@valkosipuli.retiisi.org.uk>
In-reply-to: <20141117145857.GO8907@valkosipuli.retiisi.org.uk>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrCIsWRmVeSWpSXmKPExsVy+t/xa7rL/mWFGPw9rGCx5oWDxZ35f1kt
	5h85x2rx+KueRf+bhawW516tZLR4uvkxk8Wmx9dYLS7vmsNm0bNhK6vF7CX9LBZLr19ksph4
	+jeTxd1TR9ksJkxfy2LRuvcIu8WZ/SvZLF7fecRksfxThMX+K14OIh5Hz79i9Vgzbw2jx7ev
	k1g83t9oZfe43NfL5PGrbS6zx85Zd9k9Vi7/wuZx+OtCFo9NqzrZPDYvqffYe+gHu8eK1d/Z
	PT5vkgvgi+KySUnNySxLLdK3S+DK2LntPnvBfY6K5hv/WBsYu9i7GDk5JARMJO6dvwxli0lc
	uLeerYuRi0NIYCmjxMM5M5lBEkICHxkl5syq72Lk4OAV0JJ4s5YDJMwioCqx7vUqNhCbTcBQ
	4ueL10wgtqhAhMSf0/tYQWxeAUGJH5PvsYDYIgLOEpfefmEFmc8scItZYtu+h2DNwgLuEjNv
	XGKH2BUjsX3+O8YuRnYOTgF7if2aIFFmAWuJlZO2MULY8hKb17xlnsAoMAvJhllIymYhKVvA
	yLyKUTS1NLmgOCk910ivODG3uDQvXS85P3cTIyRmv+5gXHrM6hCjAAejEg9vw8asECHWxLLi
	ytxDjBIczEoivOe6gUK8KYmVValF+fFFpTmpxYcYmTg4pRoYc5aIzdxfaNI7gelj+c0dzGZC
	Ou5hyxz5vi89azM/Lk5DgF1L7bTfu/3bTA7aXMy/32ypJmnlm22w6pWJqe6XhK1r2X0M3j64
	JLs08fOM+l0T1GeGfZI8fHa9m23ivk3p2zP3+6//Hba6YIXGye/1b89bLo5vtVzy7tlj1YvB
	Xx/4T9Rir4marMRSnJFoqMVcVJwIAPQdvd23AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pavel, Sakari,

On 11/17/2014 03:58 PM, Sakari Ailus wrote:
> Hi Pavel,
>
> On Sun, Nov 16, 2014 at 08:59:28AM +0100, Pavel Machek wrote:
>> For device tree people: Yes, I know I'll have to create file in
>> documentation, but does the binding below look acceptable?
>>
>> I'll clean up driver code a bit more, remove the printks. Anything
>> else obviously wrong?
>
> Jacek Anaszewski is working on flash support for LED devices. I think it'd
> be good to sync the DT bindings for the two, as the types of devices
> supported by the LED API and the V4L2 flash API are quite similar.
>
> Cc Jacek.

I've already submitted a patch [1] that updates leds common bindings.
I hasn't been merged yet, as the related LED Flash class patch [2]
still needs some indicator leds related discussion [3].

I think this is a good moment to discuss the flash related led common
bindings.

[1] http://www.spinics.net/lists/linux-leds/msg02121.html
[2] http://www.spinics.net/lists/linux-media/msg83100.html
[3] http://www.spinics.net/lists/linux-leds/msg02472.html

Best Regards,
Jacek Anaszewski


