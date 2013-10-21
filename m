Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753196Ab3JUWzH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 18:55:07 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:45796 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751827Ab3JUWzE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 18:55:04 -0400
X-AuditID: cbfee68e-b7f416d0000020d6-f6-5265b0c72a56
Message-id: <5265B0C7.7040808@samsung.com>
Date: Tue, 22 Oct 2013 07:55:03 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: George Cherian <george.cherian@ti.com>
Cc: myungjoo.ham@samsung.com, kishon@ti.com, ldewangan@nvidia.com,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH] extcon: palmas: Handle ID interrupt properly using
 USB_ID_INT_SRC
References: <1381430919-4635-1-git-send-email-george.cherian@ti.com>
 <525CC725.7060508@ti.com>
In-reply-to: <525CC725.7060508@ti.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrIIsWRmVeSWpSXmKPExsWyRsSkWPf4htQggwU9fBanDi5ntbjwtIfN
	Yum+1SwWl3fNYbNYtKyV2eJ24wo2BzaP3uZ3bB59W1Yxehy/sZ3J4/MmuQCWKC6blNSczLLU
	In27BK6Muy2f2Qrmi1ec2jWRvYGxV6iLkYNDQsBE4vhOsS5GTiBTTOLCvfVsXYxcHEICSxkl
	unZMYYep+bjEDqRGSGARo8TVPfkQNa8YJb523mIFSfAKaEkseHWSBcRmEVCVuPnlCZjNBhTf
	/+IGG4gtKhAmsXL6FRaIekGJH5PvgdkiQDX9l7qZQGxmgRqJZWe3gtnCAhES73etZwS5QUgg
	QeLCn3CQMKeAmsSxpp2sEOU6Evtbp7FB2PISm9e8ZQa5TUJgH7vExEudzBD3CEh8m3yIBeIX
	WYlNB5gh/pWUOLjiBssERrFZSC6ahWTsLCRjFzAyr2IUTS1ILihOSi8y0itOzC0uzUvXS87P
	3cQIjK7T/5717WC8ecD6EGMy0MqJzFKiyfnA6MwriTc0NjOyMDUxNTYytzQjTVhJnHfRw6Qg
	IYH0xJLU7NTUgtSi+KLSnNTiQ4xMHJxSDYzpV++dCbuzeVnI0y+q4dnsjybt1fsi0v9V/Yf3
	n/qaN2dnOzREn/h0tL/31n2X4jNXCw1zHjTvvfQ7Z73AWw71v9ssv9S9ZFxhsayoWsxj+ozV
	Skz7nFz+qGrwXWs+wPlks9A/s1dney8FSqQHPm3al8ZudzesTX7as46NxsHC/voy+wTtAliV
	WIozEg21mIuKEwEyo0JgxAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnleLIzCtJLcpLzFFi42I5/e+xgO7xDalBBmuusFqcOric1eLC0x42
	i6X7VrNYXN41h81i0bJWZovbjSvYHNg8epvfsXn0bVnF6HH8xnYmj8+b5AJYohoYbTJSE1NS
	ixRS85LzUzLz0m2VvIPjneNNzQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOAtisplCXmlAKFAhKL
	i5X07TBNCA1x07WAaYzQ9Q0JgusxMkADCWsYM+62fGYrmC9ecWrXRPYGxl6hLkYODgkBE4mP
	S+y6GDmBTDGJC/fWs4HYQgKLGCWu7snvYuQCsl8xSnztvMUKkuAV0JJY8OokC4jNIqAqcfPL
	EzCbDSi+/8UNsGZRgTCJldOvsEDUC0r8mHwPzBYBqum/1M0EYjML1EgsO7sVzBYWiJB4v2s9
	I8g9QgIJEhf+hIOEOQXUJI417WSFKNeR2N86jQ3ClpfYvOYt8wRGgVlINsxCUjYLSdkCRuZV
	jKKpBckFxUnpuYZ6xYm5xaV56XrJ+bmbGMHR+0xqB+PKBotDjAIcjEo8vBlWqUFCrIllxZW5
	hxglOJiVRHi/9wGFeFMSK6tSi/Lji0pzUosPMSYDA2Ais5Rocj4wseSVxBsam5gZWRqZG1oY
	GZuTJqwkznug1TpQSCA9sSQ1OzW1ILUIZgsTB6dUA+OpWKG8dWHz9W+uVI1av+vy9OAXpdk7
	6mLvzGDLjMvadrOy2uuM/q9VnZu9HjH5scaVmdadvGsWpXkj2Him6cyW7uXsIbP3SN+7K7BE
	8jfHhibd3+4H/1vIpQQ17DW/KmwqfuVgkzPHW59L5q77DbaH7np6MdfuNssWlenmzk/UPtt/
	mJQ80UmJpTgj0VCLuag4EQBhfS/6IgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi George,

On 10/15/2013 01:40 PM, George Cherian wrote:
> Laxman/Chanwoo/Kishon,
> 
> Any comments on this!!
> Regards
> -George
> On 10/11/2013 12:18 AM, George Cherian wrote:
>> Always cross check with the ID state and the source of interrupt.
>> Also add a case in which ID Source is ID_GND but LATCH state is set
>> wrongly. This uses the previous Link stat to determine the new state.
>>
>> Signed-off-by: George Cherian <george.cherian@ti.com>
>> ---
>>   drivers/extcon/extcon-palmas.c | 15 ++++++++++++---
>>   1 file changed, 12 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/extcon/extcon-palmas.c b/drivers/extcon/extcon-palmas.c
>> index 6e83e9a..2aea4bc 100644
>> --- a/drivers/extcon/extcon-palmas.c
>> +++ b/drivers/extcon/extcon-palmas.c
>> @@ -78,20 +78,24 @@ static irqreturn_t palmas_vbus_irq_handler(int irq, void *_palmas_usb)
>>     static irqreturn_t palmas_id_irq_handler(int irq, void *_palmas_usb)
>>   {
>> -    unsigned int set;
>> +    unsigned int set, id_src;
>>       struct palmas_usb *palmas_usb = _palmas_usb;
>>         palmas_read(palmas_usb->palmas, PALMAS_USB_OTG_BASE,
>>           PALMAS_USB_ID_INT_LATCH_SET, &set);
>> +    palmas_read(palmas_usb->palmas, PALMAS_USB_OTG_BASE,
>> +        PALMAS_USB_ID_INT_SRC, &id_src);
>>   -    if (set & PALMAS_USB_ID_INT_SRC_ID_GND) {
>> +    if ((set & PALMAS_USB_ID_INT_SRC_ID_GND) &&
>> +                (id_src & PALMAS_USB_ID_INT_SRC_ID_GND)) {
>>           palmas_write(palmas_usb->palmas, PALMAS_USB_OTG_BASE,
>>               PALMAS_USB_ID_INT_LATCH_CLR,
>>               PALMAS_USB_ID_INT_EN_HI_CLR_ID_GND);
>>           palmas_usb->linkstat = PALMAS_USB_STATE_ID;
>>           extcon_set_cable_state(&palmas_usb->edev, "USB-HOST", true);
>>           dev_info(palmas_usb->dev, "USB-HOST cable is attached\n");
>> -    } else if (set & PALMAS_USB_ID_INT_SRC_ID_FLOAT) {
>> +    } else if ((set & PALMAS_USB_ID_INT_SRC_ID_FLOAT) &&
>> +                (id_src & PALMAS_USB_ID_INT_SRC_ID_FLOAT)) {
>>           palmas_write(palmas_usb->palmas, PALMAS_USB_OTG_BASE,
>>               PALMAS_USB_ID_INT_LATCH_CLR,
>>               PALMAS_USB_ID_INT_EN_HI_CLR_ID_FLOAT);
>> @@ -103,6 +107,11 @@ static irqreturn_t palmas_id_irq_handler(int irq, void *_palmas_usb)
>>           palmas_usb->linkstat = PALMAS_USB_STATE_DISCONNECT;
>>           extcon_set_cable_state(&palmas_usb->edev, "USB-HOST", false);
>>           dev_info(palmas_usb->dev, "USB-HOST cable is detached\n");
>> +    } else if ((palmas_usb->linkstat == PALMAS_USB_STATE_DISCONNECT) &&
>> +                (id_src & PALMAS_USB_ID_INT_SRC_ID_GND)) {
>> +        palmas_usb->linkstat = PALMAS_USB_STATE_ID;
>> +        extcon_set_cable_state(&palmas_usb->edev, "USB-HOST", true);
>> +        dev_info(palmas_usb->dev, " USB-HOST cable is attached\n");
>>       }
>>         return IRQ_HANDLED;
> 
> 

Applied it on next branch.

Thanks.
Chanwoo Choi
