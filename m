Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757527AbaFYPhW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 11:37:22 -0400
Received: from mail-qa0-f50.google.com ([209.85.216.50]:42292 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757066AbaFYPhU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 11:37:20 -0400
MIME-Version: 1.0
In-Reply-To: <1403710120.22753.15.camel@joe-AO725>
References: <CAJKoSVTGC+-v09aCDTV5HfnpDMVuPiGTe5-Y9TMu+2E+EzMotw@mail.gmail.com>
	<1403710120.22753.15.camel@joe-AO725>
Date: Wed, 25 Jun 2014 23:37:20 +0800
Message-ID: <CAJKoSVS-_jd8x71yhBLdtt9yJA-wqA48Hy2F76vDSi51yYRE2w@mail.gmail.com>
Subject: Re: [PATCH 1/2] staging: wlan-ng/hfa384x_usb.c: remove return
 statements for void function
From: Cheng-Wei Lee <lee.rhapsody@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sherif Shehab Aldin <shehabaldin.sherif@gmail.com>,
        Avinash Kumar <avi.kp.137@gmail.com>,
        Peter Senna Tschudin <peter.senna@gmail.com>,
        devel <devel@driverdev.osuosl.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear all,

Thanks Joe's reminder. I've resent patch.

Sincerely,
Quentin

2014-06-25 23:28 GMT+08:00, Joe Perches <joe@perches.com>:
> On Wed, 2014-06-25 at 23:24 +0800, Cheng-Wei Lee wrote:
>> This patch fixes the following checkpatch.pl issues in hfa384x_usb.c:
>> WARNING: void function return statements are not generally useful
>
> subject/code mismatch.
>
>> Signed-off-by: Quentin Lee <lee.rhapsody@gmail.com>
>> ---
>>  drivers/staging/wlan-ng/hfa384x_usb.c |    1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/drivers/staging/wlan-ng/hfa384x_usb.c
>> b/drivers/staging/wlan-ng/hfa384x_usb.c
>> index 98343ff7..07cee56 100644
>> --- a/drivers/staging/wlan-ng/hfa384x_usb.c
>> +++ b/drivers/staging/wlan-ng/hfa384x_usb.c
>> @@ -3705,6 +3705,7 @@ static void hfa384x_usbout_callback(struct urb
>> *urb)
>>  		case -EPIPE:
>>  			{
>>  				hfa384x_t *hw = wlandev->priv;
>> +
>>  				netdev_warn(hw->wlandev->netdev,
>>  					    "%s tx pipe stalled: requesting reset\n",
>>  					    wlandev->netdev->name);
>
>
>
>
