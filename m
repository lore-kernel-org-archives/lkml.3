Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755572AbaGQIlW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 04:41:22 -0400
Received: from mail1.bemta5.messagelabs.com ([195.245.231.146]:57204 "EHLO
	mail1.bemta5.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754522AbaGQIlU convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 04:41:20 -0400
X-Env-Sender: stwiss.opensource@diasemi.com
X-Msg-Ref: server-10.tower-178.messagelabs.com!1405586476!39910999!1
X-Originating-IP: [94.185.165.51]
X-StarScan-Received: 
X-StarScan-Version: 6.11.3; banners=-,-,-
X-VirusChecked: Checked
From: "Opensource [Steve Twiss]" <stwiss.opensource@diasemi.com>
To: Alessandro Zummo <a.zummo@towertech.it>
CC: Andrew Morton <akpm@linux-foundation.org>,
        LINUX-KERNEL <linux-kernel@vger.kernel.org>,
        Lee Jones <lee.jones@linaro.org>,
        RTC-LINUX <rtc-linux@googlegroups.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "David Dajun Chen" <david.chen@diasemi.com>,
        Mark Brown <broonie@linaro.org>,
        "Philipp Zabel" <p.zabel@pengutronix.de>,
        Support Opensource <Support.Opensource@diasemi.com>
Subject: RE: [RFC V1] mfd: da9063: Add support for AD silicon variant
Thread-Topic: [RFC V1] mfd: da9063: Add support for AD silicon variant
Thread-Index: AQHPoRbRL7Ty11j0A0WbCnSX9KX415ui40sAgAEQISA=
Date: Thu, 17 Jul 2014 08:41:15 +0000
Message-ID: <6ED8E3B22081A4459DAC7699F3695FB7D0B26F49@SW-EX-MBX02.diasemi.com>
References: <201407161655.s6GGtsHS030285@swsrvapps-01.diasemi.com>
 <20140716192646.4a981b31@linux.lan.towertech.it>
In-Reply-To: <20140716192646.4a981b31@linux.lan.towertech.it>
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


On 16 July 2014 18:27 Alessandro Zummo wrote:

>From: Alessandro Zummo [mailto:a.zummo@towertech.it]
>Sent: 16 July 2014 18:27
>To: Opensource [Steve Twiss]
>Cc: Andrew Morton; LINUX-KERNEL; Lee Jones; RTC-LINUX; Samuel Ortiz; David
>Dajun Chen; Mark Brown; Philipp Zabel; Support Opensource
>Subject: Re: [RFC V1] mfd: da9063: Add support for AD silicon variant
>
>On Wed, 16 Jul 2014 17:39:20 +0100
>"Opensource [Steve Twiss]" <stwiss.opensource@diasemi.com> wrote:
>
>> The DA9063 probe function has been modified to use the compile time
>> directive CONFIG_MFD_DA9063_AD. This configuration option will allow
>> AD support only if this boolean is true, otherwise it will default to
>> support BB (or greater) silicon.
>
> any particular reason for not supporting both at the same time,
> either with a module option, platform data, dt, etc ?

Hi Alessandro,

If run-time distinction between AD and BB is used this makes the change
bigger, more complicated and difficult to understand.

These problems were discussed in a previous posting back in February
https://lkml.org/lkml/2014/2/16/29 

This change is just a supporting option for people who have the older AD silicon
in their hardware.

Regards,
Steve

>
>--
>
> Best regards,
>
> Alessandro Zummo,
>  Tower Technologies - Torino, Italy
>
>  http://www.towertech.it

