Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933120AbaFLKWf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 06:22:35 -0400
Received: from mail-ig0-f173.google.com ([209.85.213.173]:36845 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932894AbaFLKWe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 06:22:34 -0400
MIME-Version: 1.0
In-Reply-To: <20140612074321.GT5500@mwanda>
References: <1402507301-3722-1-git-send-email-navin.patidar@gmail.com>
	<1402507301-3722-6-git-send-email-navin.patidar@gmail.com>
	<20140612074321.GT5500@mwanda>
Date: Thu, 12 Jun 2014 15:52:33 +0530
Message-ID: <CAPV97ydjB5_HT6Htvju-ng0PGYVBmiDWxY9A=vYq35vrubsWeQ@mail.gmail.com>
Subject: Re: [PATCH 06/22] staging: rtl8188eu: Instead of intf_hdl pass
 adapter in read & write functions
From: navin patidar <navin.patidar@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Larry Finger <Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 12, 2014 at 1:13 PM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> On Wed, Jun 11, 2014 at 10:51:25PM +0530, navin patidar wrote:
>> diff --git a/drivers/staging/rtl8188eu/core/rtw_io.c b/drivers/staging/rtl8188eu/core/rtw_io.c
>> index a0a31e6..85306bf 100644
>> --- a/drivers/staging/rtl8188eu/core/rtw_io.c
>> +++ b/drivers/staging/rtl8188eu/core/rtw_io.c
>> @@ -57,10 +57,10 @@ u8 _rtw_read8(struct adapter *adapter, u32 addr)
>>       u8 r_val;
>>       struct io_priv *pio_priv = &adapter->iopriv;
>>       struct  intf_hdl *pintfhdl = &(pio_priv->intf);
>> -     u8 (*_read8)(struct intf_hdl *pintfhdl, u32 addr);
>> +     u8 (*_read8)(struct adapter *pintfhdl, u32 addr);
>                                      ^^^^^^^^
> Could you send a follow on patch to change pintfhdl to adapter in all
> the declarations?
>

dan, these declarations are removed by other patches of this patch set.

do i still need to send v2 of this patch?

regards,
navin patidar
