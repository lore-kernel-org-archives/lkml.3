Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965216Ab3GLSuk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 14:50:40 -0400
Received: from mga02.intel.com ([134.134.136.20]:24777 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933247Ab3GLSui convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 14:50:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,654,1367996400"; 
   d="scan'208";a="344701897"
From: "Pandruvada, Srinivas" <srinivas.pandruvada@intel.com>
To: Jonathan Cameron <jic23@kernel.org>,
        Alexander Holler <holler@ahsoftware.de>
CC: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        Jonathan Cameron <jic23@cam.ac.uk>
Subject: RE: [PATCH 0/4] iio: hid-sensor: add module alias for autoload
Thread-Topic: [PATCH 0/4] iio: hid-sensor: add module alias for autoload
Thread-Index: AQHOfUgtyCPFJiydDUK13wutOUvtRpleft0AgAAIcwCAAatKAIAA6ReAgAC+04D//4r5UA==
Date: Fri, 12 Jul 2013 18:46:31 +0000
Message-ID: <4FA419E87744DF4DAECD5BCE1214B7A92FBDB5B4@ORSMSX110.amr.corp.intel.com>
References: <1373445120-5407-1-git-send-email-holler@ahsoftware.de>
 <51DD7D78.2020506@linux.intel.com> <51DD848E.4050206@ahsoftware.de>
 <51DEEAFE.506@linux.intel.com> <51DFAE85.9060508@ahsoftware.de>
 <51E04E99.9060105@kernel.org>
In-Reply-To: <51E04E99.9060105@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.138]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks fine, but will test on actual hardware in couple of days.

Thanks,
Srinivas

-----Original Message-----
From: Jonathan Cameron [mailto:jic23@kernel.org] 
Sent: Friday, July 12, 2013 11:45 AM
To: Alexander Holler
Cc: Srinivas Pandruvada; linux-kernel@vger.kernel.org; linux-iio@vger.kernel.org; Jonathan Cameron; Pandruvada, Srinivas
Subject: Re: [PATCH 0/4] iio: hid-sensor: add module alias for autoload

On 07/12/2013 08:21 AM, Alexander Holler wrote:
> Am 11.07.2013 19:27, schrieb Srinivas Pandruvada:
>>
>>
>> On 07/10/2013 08:58 AM, Alexander Holler wrote:
>>> Am 10.07.2013 17:27, schrieb Srinivas Pandruvada:
>>>> Hi,
>>>>
>>>> There was no intention to prevent auto loading. Did you get chance 
>>>> to test these changes?
>>>
>>> Sure, I always test patches before I send them out.
>>>
>>> Ok, I haven't tested the changes with the iio HID drivers (I don't 
>>> have any commercial HID sensor hub, so I've just compile tested 
>>> these patches here, double reading them), but I've tested the 
>>> similiar changes with a patch for rtc-hid-sensor-time I've send out yesterday.
>>> (sorry, no link, lkml.org seems dead, just search for
>>> "rtc-hid-sensor-time: add module alias")
>>>
>>> It works just fine. An example output is now
>>>
>>> Jul  9 19:27:21 dockstar3 kernel: [    5.124444] rtc_hid_sensor_time
>>> HID-SENSOR-2000a0.0: milliseconds supported
>>> Jul  9 19:27:21 dockstar3 kernel: [    5.132864] rtc_hid_sensor_time
>>> HID-SENSOR-2000a0.0: rtc core: setting system clock to 2013-07-09
>>> 17:26:51:328000 UTC (1373390811)
>>> Jul  9 19:27:21 dockstar3 kernel: [    5.146105] rtc_hid_sensor_time
>>> HID-SENSOR-2000a0.0: rtc core: registered hid-sensor-time as rtc0
>>>
>>> Before the output was e.g.
>>>
>>> HID-SENSOR-2000a0 HID-SENSOR-2000a0.0: rtc core: registered 
>>> hid-sensor-time as rtc0
>>>
>>> instead of the above with the descriptive rtc_hid_sensor_time.
>> <Agreed. This is better. >
>>> Automatic loading of modules works too and it works on ARM, Intel 
>>> and AMD as module or static linked. ;)
> 
> Do you have tested the patches with a real device? I assume you have 
> one. ;)
> 
> Regards,
> 
> Alexander Holler

Just so you two know. Given this discussion, I'll be lazy about these and wait for an Ack from Srinivas before taking these.  Look fine to me, but nice to have confirmation as you say with the actual hardware!

Jonathan
