Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936814Ab3DJONM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 10:13:12 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:42848 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760149Ab3DJONH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 10:13:07 -0400
Message-ID: <5165736A.2060308@samsung.com>
Date: Wed, 10 Apr 2013 23:12:58 +0900
From: Kukjin Kim <kgene.kim@samsung.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.16
MIME-Version: 1.0
To: Wolfram Sang <wsa@the-dreams.de>
CC: Kukjin Kim <kgene.kim@samsung.com>, djkurtz@chromium.org,
        linux-kernel@vger.kernel.org, grant.likely@secretlab.ca,
        "'Russell King'" <linux@arm.linux.org.uk>,
        "'Jingoo Han'" <jg1.han@samsung.com>, ben.dooks@codethink.co.uk,
        "'Thomas Abraham'" <thomas.abraham@linaro.org>,
        u.kleine-koenig@pengutronix.de, linux@roeck-us.net,
        swarren@wwwdotorg.org, girish.shivananjappa@linaro.org,
        bhushan.r@samsung.com,
        "'Naveen Krishna Chatradhi'" <ch.naveen@samsung.com>,
        linux-arm-kernel@lists.infradead.org,
        "'Rahul Sharma'" <rahul.sharma@samsung.com>, sreekumar.c@samsung.com,
        "'Simon Glass'" <sjg@chromium.org>,
        broonie@opensource.wolfsonmicro.com,
        "'Doug Anderson'" <dianders@chromium.org>, yuvaraj.cd@gmail.com,
        olof@lixom.net, prashanth.g@samsung.com
Subject: Re: [PATCH v5 2/3] ARM: dts: Add i2c-arbitrator bus for exynos5250-snow
References: <1363192583-26363-1-git-send-email-dianders@chromium.org> <1365543270-10736-1-git-send-email-dianders@chromium.org> <1365543270-10736-2-git-send-email-dianders@chromium.org> <310301ce35da$724dff60$56e9fe20$%kim@samsung.com> <20130410110226.GA3533@the-dreams.de>
In-Reply-To: <20130410110226.GA3533@the-dreams.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/10/13 20:02, Wolfram Sang wrote:
> On Wed, Apr 10, 2013 at 07:59:17PM +0900, Kukjin Kim wrote:
>> Doug Anderson wrote:
>>>
>>> We need to use the i2c-arbitrator to talk to any of the devices on i2c
>>> bus 4 on exynos5250-snow so that we don't confuse the embedded
>>> controller (EC).  Add the i2c-arbitrator to the device tree.  As we
>>> add future devices (keyboard, sbs, tps65090) we'll add them on top of
>>> this.
>>>
>>> The arbitrated bus is numbered 104 simply as a convenience to make it
>>> easier for people poking around to guess that it might have something
>>> to do with the physical bus 4.
>>>
>>> The addition is split between the cros5250-common and the snow device
>>> tree file since not all cros5250-class devices use arbitration.
>>>
>>> Signed-off-by: Doug Anderson<dianders@chromium.org>
>>
>> I'm fine on 2nd and 3rd patches. Shall I take only two patches without 1st
>> one in samsung tree?
>
> Please wait for my OK on patch 1. Or ack patches 2 and 3 and I will pick
> them up. I am fine with both.
>
OK, I will wait for your reply on this. Because I suppose if the dt 
patches in your tree could make useless conflicts. Anyway let me know 
your opinion on that.

Thanks.

- Kukjin
