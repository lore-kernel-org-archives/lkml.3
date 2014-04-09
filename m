Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758471AbaDIMiR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 08:38:17 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:23107 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932681AbaDIMiM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 08:38:12 -0400
X-AuditID: cbfec7f4-b7f796d000005a13-28-53453f327c04
Message-id: <53453F2E.40606@samsung.com>
Date: Wed, 09 Apr 2014 14:38:06 +0200
From: Tomasz Figa <t.figa@samsung.com>
Organization: Samsung R&D Institute Poland
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.4.0
MIME-version: 1.0
To: Vivek Gautam <gautam.vivek@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: kishon <kishon@ti.com>, Linux USB Mailing List <linux-usb@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>, Felipe Balbi <balbi@ti.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Kamil Debski <k.debski@samsung.com>, Jingoo Han <jg1.han@samsung.com>
Subject: Re: [PATCH] phy: exynos5-usbdrd: Add facility to toggle vbus gpio
 on/off
References: <1397044485-26483-1-git-send-email-gautam.vivek@samsung.com>
 <534538F6.2010009@samsung.com>
 <CAFp+6iHf5Ndt3yNbdAaayXi08-A54Sk8LDTiASm4RTw09GuWvg@mail.gmail.com>
In-reply-to: <CAFp+6iHf5Ndt3yNbdAaayXi08-A54Sk8LDTiASm4RTw09GuWvg@mail.gmail.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGLMWRmVeSWpSXmKPExsVy+t/xy7pG9q7BBps+8VocvF9vMf/IOVaL
	tisH2S2aF69ns7i88BKrxY/XF9gsehdcZbO48LSHzWLT42usFpd3zWGzmHF+H5PFomWtzBaH
	37SzOvB67J+7ht1j85J6j74tqxg9jt/YzuTxeZNcAGsUl01Kak5mWWqRvl0CV8aEx4kFf9gq
	Ju39xdrAuI+1i5GTQ0LAROLLlVVQtpjEhXvr2boYuTiEBJYySmybs4QdJCEk8JlR4sUdUxCb
	V0BD4u6ea4wgNouAqsS1K71MIDabgJrE54ZHbCA2v4CWxJqm6ywgtqhAhMS9xsOsEL2CEj8m
	3wOLiwhESTyb08kOsoxZYA6LxN+ZG8ASwgLBEj8PPWKEuGIDo8SnN9/BruAESpw+cB1sErOA
	tcTKSdsYIWx5ic1r3jJPYBSchWTJLCRls5CULWBkXsUomlqaXFCclJ5rqFecmFtcmpeul5yf
	u4kREjdfdjAuPmZ1iFGAg1GJh1fB0iVYiDWxrLgy9xCjBAezkghvm4FrsBBvSmJlVWpRfnxR
	aU5q8SFGJg5OqQZGn7JpgmaLjZ8dVFzzNmTdF9mHf0xWRkznim/KyY0UKWuMDjW96jD1yFSV
	sBNxnB05glvzXxzQ2Lfn2OnobfcvCi/s0T3osLf1eLajo5zBQb2zWnY8p6xLnA6lee/7wnDG
	R2xZoK7a/akFbUe2Hpwdt/T7BJGQjPXfDxUpnve5feUfl+DMNP4iJZbijERDLeai4kQA7ryA
	+3kCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 09.04.2014 14:24, Vivek Gautam wrote:
> Hi Sylwester,
>
>
> On Wed, Apr 9, 2014 at 5:41 PM, Sylwester Nawrocki
> <s.nawrocki@samsung.com> wrote:
>> Hi Vivek,
>>
>> On 09/04/14 13:54, Vivek Gautam wrote:
>>> Adding support to enable/disable VBUS hooked to a gpio
>>> to enable vbus supply on the port.
>>
>> Does the GPIO control a fixed voltage regulator ? If so, shouldn't
>> it be modelled by the regulator API instead ?
>
> No, this GPIO controls a 'current limiting power distribution switch',
> which gives the output vbus to usb controller.
> Should i model this as a fixed regulator ?

If I understand this correctly, this is just a switch that lets you 
control whether vbus is provided to the USB connector or not. If so, 
this doesn't look like an Exynos-specific thing at all and should rather 
be modeled on higher level.

Best regards,
Tomasz
