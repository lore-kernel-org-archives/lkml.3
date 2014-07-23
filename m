Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757962AbaGWJmS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 05:42:18 -0400
Received: from mail-oi0-f46.google.com ([209.85.218.46]:50129 "EHLO
	mail-oi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757644AbaGWJmQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 05:42:16 -0400
MIME-Version: 1.0
In-Reply-To: <001901cfa657$05d4a020$117de060$%han@samsung.com>
References: <1406101102-11894-1-git-send-email-kiran.padwal@smartplayin.com>
	<001901cfa657$05d4a020$117de060$%han@samsung.com>
Date: Wed, 23 Jul 2014 15:12:13 +0530
Message-ID: <CA+neC=OPR3tYX+arpMT_-4ZyobHOk8K1wZSFGpE1-RBMqsoaQA@mail.gmail.com>
Subject: Re: [PATCH] usb: phy: msm: Make of_device_id array const
From: kiran padwal <kiran.padwal21@gmail.com>
To: Jingoo Han <jg1.han@samsung.com>
Cc: balbi <balbi@ti.com>, linux-usb <linux-usb@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, kiran.padwal@smartplayin.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2014 at 2:48 PM, Jingoo Han <jg1.han@samsung.com> wrote:
> On Wednesday, July 23, 2014 4:38 PM, Kiran Padwal wrote:
>>
>> Make of_device_id array const, because all OF functions handle it as const.
>
> Hi Kiran Padwal,
>
> The same patch was already submitted and merged to USB tree.
> Thank you.

Thanks.

>
> Best regards,
> Jingoo Han
>
>>
>> Signed-off-by: Kiran Padwal <kiran.padwal@smartplayin.com>
>> ---
>>  drivers/usb/phy/phy-msm-usb.c |    2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/usb/phy/phy-msm-usb.c b/drivers/usb/phy/phy-msm-usb.c
>> index 78cc870..e4108ee 100644
>> --- a/drivers/usb/phy/phy-msm-usb.c
>> +++ b/drivers/usb/phy/phy-msm-usb.c
>> @@ -1429,7 +1429,7 @@ static void msm_otg_debugfs_cleanup(void)
>>       debugfs_remove(msm_otg_dbg_root);
>>  }
>>
>> -static struct of_device_id msm_otg_dt_match[] = {
>> +static const struct of_device_id msm_otg_dt_match[] = {
>>       {
>>               .compatible = "qcom,usb-otg-ci",
>>               .data = (void *) CI_45NM_INTEGRATED_PHY
>> --
>> 1.7.9.5
>
