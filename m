Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752765AbaCGJvB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 04:51:01 -0500
Received: from mail1.bemta5.messagelabs.com ([195.245.231.151]:59148 "EHLO
	mail1.bemta5.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751049AbaCGJu7 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 04:50:59 -0500
X-Env-Sender: stwiss.opensource@diasemi.com
X-Msg-Ref: server-4.tower-179.messagelabs.com!1394185856!30469220!1
X-Originating-IP: [94.185.165.51]
X-StarScan-Received: 
X-StarScan-Version: 6.9.16; banners=-,-,-
X-VirusChecked: Checked
From: "Opensource [Steve Twiss]" <stwiss.opensource@diasemi.com>
To: Alessandro Zummo <a.zummo@towertech.it>
CC: David Dajun Chen <david.chen@diasemi.com>,
        LKML <linux-kernel@vger.kernel.org>,
        RTC linux <rtc-linux@googlegroups.com>
Subject: RE: [PATCH V1 2/2] rtc: da9063: RTC driver
Thread-Topic: [PATCH V1 2/2] rtc: da9063: RTC driver
Thread-Index: AQHPOehDw5sFhoHiRkWedpjOzr5k2ZrVYU5w
Date: Fri, 7 Mar 2014 09:50:55 +0000
Message-ID: <6ED8E3B22081A4459DAC7699F3695FB7A0C6C367@SW-EX-MBX02.diasemi.com>
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


>From: Alessandro Zummo [mailto:a.zummo@towertech.it]
>Sent: 07 March 2014 09:33
>
>On Thu, 6 Mar 2014 16:40:02 +0000
>"Opensource [Steve Twiss]" <stwiss.opensource@diasemi.com> wrote:
>
>> Change History:
>>
>> Changes made to this driver since previous RFC V1
>> Comments by Alessandro Zummo
>> - http://www.kernelhub.org/?p=2&msg=426327
>> - Use return PTR_ERR(rtc->rtc_dev); instead of goto err; return err.
>> - Request the interrupt before the RTC device is registered with the
>>   call to devm_rtc_device_register.
>
>
> Acked-by: Alessandro Zummo <a.zummo@towertech.it>
>

Thank you.
Regards,
Steve
