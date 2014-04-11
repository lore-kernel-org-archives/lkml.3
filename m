Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755807AbaDKLpi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 07:45:38 -0400
Received: from mail1.bemta14.messagelabs.com ([193.109.254.119]:52403 "EHLO
	mail1.bemta14.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754209AbaDKLpf convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 07:45:35 -0400
X-Env-Sender: stwiss.opensource@diasemi.com
X-Msg-Ref: server-10.tower-194.messagelabs.com!1397216733!14261819!1
X-Originating-IP: [94.185.165.51]
X-StarScan-Received: 
X-StarScan-Version: 6.11.1; banners=-,-,-
X-VirusChecked: Checked
From: "Opensource [Steve Twiss]" <stwiss.opensource@diasemi.com>
To: Alessandro Zummo <a.zummo@towertech.it>
CC: David Dajun Chen <david.chen@diasemi.com>,
        LKML <linux-kernel@vger.kernel.org>,
        RTC linux <rtc-linux@googlegroups.com>,
        "Lee Jones" <lee.jones@linaro.org>
Subject: RE: [PATCH V1 2/2] rtc: da9063: RTC driver
Thread-Topic: [PATCH V1 2/2] rtc: da9063: RTC driver
Thread-Index: AQHPOehDw5sFhoHiRkWedpjOzr5k2ZsMeJ/Q
Date: Fri, 11 Apr 2014 11:45:33 +0000
Message-ID: <6ED8E3B22081A4459DAC7699F3695FB7A7A71727@SW-EX-MBX02.diasemi.com>
References: <cover.1394124002.git.stwiss.opensource@diasemi.com>
	<93327cde91bcaef9a467adc6c7b34c3231d9e1e7.1394124002.git.stwiss.opensource@diasemi.com>
 <20140307103310.3444cef6@linux.lan.towertech.it>
In-Reply-To: <20140307103310.3444cef6@linux.lan.towertech.it>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.20.26.61]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07 March 2014 09:33, Alessandro Zummo wrote,
>On Thu, 6 Mar 2014 16:40:02 +0000
>"Opensource [Steve Twiss]" <stwiss.opensource@diasemi.com> wrote:
>> Change History:
>> Changes made to this driver since previous RFC V1
>> Comments by Alessandro Zummo
>> - http://www.kernelhub.org/?p=2&msg=426327
>> - Use return PTR_ERR(rtc->rtc_dev); instead of goto err; return err.
>> - Request the interrupt before the RTC device is registered with the
>>   call to devm_rtc_device_register.
> Acked-by: Alessandro Zummo <a.zummo@towertech.it>

Hi Alessandro,

Is it possible to merge my RTC patch so it appears in linux-next please?

You originally Acked it around 1 month ago
https://lkml.org/lkml/2014/3/7/112

But I've been unable to get it merged because that part needs your consent.
https://lkml.org/lkml/2014/3/25/240

Regards,
Steve

>--
>
> Best regards,
>
> Alessandro Zummo,
>  Tower Technologies - Torino, Italy
>
>  http://www.towertech.it


