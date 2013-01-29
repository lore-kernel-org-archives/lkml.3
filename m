Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754862Ab3A2Ikn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 03:40:43 -0500
Received: from mail-la0-f50.google.com ([209.85.215.50]:54126 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754647Ab3A2Ikk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 03:40:40 -0500
MIME-Version: 1.0
In-Reply-To: <87k3qxnt07.fsf@nemi.mork.no>
References: <1359387918-2791-1-git-send-email-dnlplm@gmail.com>
	<87k3qxnt07.fsf@nemi.mork.no>
Date: Tue, 29 Jan 2013 09:40:38 +0100
Message-ID: <CAGRyCJEThQaex9au5AbWT-hm1Vvj2jxiXuAfrgNTdTofqAYY3A@mail.gmail.com>
Subject: Re: [PATCH 1/1] NET: qmi_wwan: add Telit LE920 support
From: Daniele Palmas <dnlplm@gmail.com>
To: =?ISO-8859-1?Q?Bj=F8rn_Mork?= <bjorn@mork.no>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

2013/1/28 Bjørn Mork <bjorn@mork.no>:
> Daniele Palmas <dnlplm@gmail.com> writes:
>
>> Add VID, PID and fixed interface for Telit LE920
>>
>> Signed-off-by: Daniele Palmas <dnlplm@gmail.com>
>> ---
>>  drivers/net/usb/qmi_wwan.c |    1 +
>>  1 files changed, 1 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
>> index 6a1ca50..e32f9a1 100644
>> --- a/drivers/net/usb/qmi_wwan.c
>> +++ b/drivers/net/usb/qmi_wwan.c
>> @@ -459,6 +459,7 @@ static const struct usb_device_id products[] = {
>>       {QMI_FIXED_INTF(0x1199, 0x68a2, 19)},   /* Sierra Wireless MC7710 in QMI mode */
>>       {QMI_FIXED_INTF(0x1199, 0x901c, 8)},    /* Sierra Wireless EM7700 */
>>       {QMI_FIXED_INTF(0x1bbb, 0x011e, 4)},    /* Telekom Speedstick LTE II (Alcatel One Touch L100V LTE) */
>> +     {QMI_FIXED_INTF(0x1bc7, 0x1200, 5)},    /* Telit LE920 */
>>
>>       /* 4. Gobi 1000 devices */
>>       {QMI_GOBI1K_DEVICE(0x05c6, 0x9212)},    /* Acer Gobi Modem Device */
>
> Thanks for adding this device. But the patch doesn't apply to the
> current "net" tree.  Care to rebase it?
>

Sure. Should I use the following git repository

git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/net-next.git

?

Thanks,
Daniele
