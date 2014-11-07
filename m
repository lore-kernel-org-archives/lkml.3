Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751533AbaKGJcS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 04:32:18 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:59403 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751416AbaKGJcL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 04:32:11 -0500
X-AuditID: cbfec7f5-b7f956d000005ed7-84-545c91988fb0
Message-id: <545C9197.3090808@samsung.com>
Date: Fri, 07 Nov 2014 10:32:07 +0100
From: Robert Baldyga <r.baldyga@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.1.2
MIME-version: 1.0
To: Lee Jones <lee.jones@linaro.org>
Cc: sameo@linux.intel.com, a.zummo@towertech.it, linux-kernel@vger.kernel.org,
        rtc-linux@googlegroups.com, m.szyprowski@samsung.com,
        k.kozlowski@samsung.com
Subject: Re: [PATCH v4 1/3] mfd: max8997: use regmap to access registers
References: <1398693358-28336-1-git-send-email-r.baldyga@samsung.com>
 <1398693358-28336-2-git-send-email-r.baldyga@samsung.com>
 <20140520161902.GD32025@lee--X1> <20140520161948.GE32025@lee--X1>
In-reply-to: <20140520161948.GE32025@lee--X1>
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLLMWRmVeSWpSXmKPExsVy+t/xy7ozJsaEGPzdom2x5OJVdovXLwwt
	7n89ymhxedccNou1R+6yW+zv7GC0ON3N6sDusWfiSTaPO9f2sHnMOxno0bdlFaPH9Hk/mTw+
	b5ILYIvisklJzcksSy3St0vgytj8+hFrwRXeivN77rA1MF7h6mLk5JAQMJG403WAFcIWk7hw
	bz1bFyMXh5DAUkaJUwcusEM4HxklHk+bxNTFyMHBK6AlcWdrNUgDi4CqxPMLb9lAbDYBHYkt
	3ycwgtiiAhESJ+/uYQexeQUEJX5MvscC0ioioCJx7o05SJhZYB6jxLdPgSC2sICHROfEeawQ
	q44yShzZuASsl1NAV+LP7cvMIL3MAuoSU6bkQvTKS2xe85Z5AqPALCQbZiFUzUJStYCReRWj
	aGppckFxUnqukV5xYm5xaV66XnJ+7iZGSJB/3cG49JjVIUYBDkYlHt4HIjEhQqyJZcWVuYcY
	JTiYlUR4UxuBQrwpiZVVqUX58UWlOanFhxiZODilGhgNdZ8wxH1tPnW2qGEK7zW7hZK/xQt0
	hWbtlPztuy368+GlWRFpmZtSj03Zl3Fme3jRCw52JtUSzkbDgkunBbetTkmerXjS+1aj4YPD
	5ZoLFPtnsFW8/ln2dr/s0fMbrFe45mlON5+/yGCZ2ilBtk7ZySbqzF6rvTP9eep+th2qeDfh
	6PGUhANKLMUZiYZazEXFiQDDrywoUAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

It looks like everybody have forgot about this patch series. Is there
any chance for them to be applied? I can resend patches rebased to last
next branch.

Best regards,
Robert Baldyga.

On 05/20/2014 06:19 PM, Lee Jones wrote:
> On Tue, 20 May 2014, Lee Jones wrote:
> 
>>> This patch modifies max8997 driver and each associated function driver,
>>> to use regmap instead of operating directly on i2c bus. It will allow to
>>> simplify IRQ handling using regmap-irq.
>>>
>>> Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
>>> Reviewed-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
>>>
>>> [For extcon part]
>>> Acked-by: Chanwoo Choi <cw00.choi@samsung.com>
>>>
>>> [For leds part]
>>> Acked-by: Bryan Wu <cooloney@gmail.com>
>>> ---
>>>  drivers/extcon/extcon-max8997.c     |  31 ++++----
>>>  drivers/input/misc/max8997_haptic.c |  34 +++++----
>>>  drivers/leds/leds-max8997.c         |  13 ++--
>>>  drivers/mfd/Kconfig                 |   1 +
>>>  drivers/mfd/max8997-irq.c           |  64 +++++++---------
>>>  drivers/mfd/max8997.c               | 141 ++++++++++++++++-------------------
>>
>> Looks to be doing the right things and the diff looks good.
>>
>> For the MFD part:
>>   Acked-by: Lee Jones <lee.jones@linaro.org>
> 
> I should add that I'd like this to go through the MFD tree.
> 
> I can supply the other maintainers with a pull-request as required.
> 
>>>  drivers/power/max8997_charger.c     |  33 +++++----
>>>  drivers/regulator/max8997.c         |  87 +++++++++++-----------
>>>  drivers/rtc/rtc-max8997.c           |  56 +++++++-------
>>>  include/linux/mfd/max8997-private.h |  17 ++---
>>>  10 files changed, 228 insertions(+), 249 deletions(-)
>>
> 

