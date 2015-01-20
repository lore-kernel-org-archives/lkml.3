Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751885AbbATOL7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 09:11:59 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:48702 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756AbbATOL4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 09:11:56 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-62-54be6229c91d
Message-id: <54BE6228.5070304@samsung.com>
Date: Tue, 20 Jan 2015 15:11:52 +0100
From: Jacek Anaszewski <j.anaszewski@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804
 Thunderbird/17.0.8
MIME-version: 1.0
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        kyungmin.park@samsung.com, b.zolnierkie@samsung.com, pavel@ucw.cz,
        cooloney@gmail.com, rpurdie@rpsys.net, sakari.ailus@iki.fi,
        s.nawrocki@samsung.com, Chanwoo Choi <cw00.choi@samsung.com>
Subject: Re: [PATCH/RFC v10 07/19] mfd: max77693: Adjust FLASH_EN_SHIFT and
 TORCH_EN_SHIFT macros
References: <1420816989-1808-1-git-send-email-j.anaszewski@samsung.com>
 <1420816989-1808-8-git-send-email-j.anaszewski@samsung.com>
 <20150120111719.GF13701@x1> <54BE51B2.8040209@samsung.com>
In-reply-to: <54BE51B2.8040209@samsung.com>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGLMWRmVeSWpSXmKPExsVy+t/xa7qaSftCDHZsF7fYOGM9q8XRnROZ
	LK5/ec5qMf/IOVaLs01v2C3ufz3KaHF51xw2i61v1jFa9GzYympx99RRNovdu56yWhx+085q
	cWb/SjYHXo+ds+6yexz+upDF4861PWwee+b/YPXo27KK0WPF6u/sHp83yQWwR3HZpKTmZJal
	FunbJXBlzJyzgrlgFkfFk0XbWBoYz7J1MXJySAiYSJz738AEYYtJXLi3HijOxSEksJRRYser
	DnYI5yOjxKJNT5hBqngFtCR6H99jBLFZBFQlTl1YDdbNJmAo8fPFazBbVCBC4s/pfawQ9YIS
	PybfY+li5OAQEVCROPfGHCTMLLCLSWLfcQ0QW1ggWeL6mylMELsOMUq8aroNtotTQFvi6MFj
	zBANZhKPWtZB2fISm9e8ZZ7AKDALyYpZSMpmISlbwMi8ilE0tTS5oDgpPddQrzgxt7g0L10v
	OT93EyMkbr7sYFx8zOoQowAHoxIPr0bOnhAh1sSy4spcoGs4mJVEeM+a7wsR4k1JrKxKLcqP
	LyrNSS0+xMjEwSnVwKghYjzh/wNhrpPLhPnXfNI6afQqb0XpRt1AxUOt52bKzH3JmsJ3yeu2
	Ss+WPsle61d6fD2SViIqUeqF1R6f83nPFHOc3c//ZHqrQr0zi6zyYcXptW1HmxiuhC2eHVfY
	WufLKfNa7ObZir2FUj8zbk9esJrP/kXI6X82vP4XVgYlPbVMYIqtUWIpzkg01GIuKk4EAON9
	xjx5AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/20/2015 02:01 PM, Jacek Anaszewski wrote:
> On 01/20/2015 12:17 PM, Lee Jones wrote:
>> On Fri, 09 Jan 2015, Jacek Anaszewski wrote:
>>
>>> Modify FLASH_EN_SHIFT and TORCH_EN_SHIFT macros to work properly
>>> when passed enum max77693_fled values (0 for FLED1 and 1 for FLED2)
>>> from leds-max77693 driver.
>>
>> Off-by-one ay?  Wasn't the original code tested?
>
> The driver using these macros is a part of LED / flash API integration
> patch series, which still undergoes modifications and it hasn't
> reached its final state yet, as there are many things to discuss.

To be more precise: the original code had been tested and was working
properly with the header that is in the mainline. Nonetheless, because
of the modifications in the driver that was requested during code
review, it turned out that it would be more convenient to redefine the
macros.

I'd opt for just agreeing about the mfd related patches and merge
them no sooner than the leds-max77693 driver is merged.

-- 
Best Regards,
Jacek Anaszewski
