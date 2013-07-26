Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758515Ab3GZKhZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 06:37:25 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:47004 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754659Ab3GZKhY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 06:37:24 -0400
Message-ID: <51F2515F.8060001@ti.com>
Date: Fri, 26 Jul 2013 13:37:19 +0300
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Arend van Spriel <arend@broadcom.com>
CC: Joel Fernandes <joelf@ti.com>, <tony@atomide.com>,
        <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Regression 3.11-rc1: omap4panda: no usb and consequently no ethernet
References: <51E7AA24.6080600@broadcom.com> <51E7CEF3.5000408@ti.com> <51E7D080.6070401@broadcom.com> <51E7D1D2.1060006@ti.com> <51E7E1B7.6090104@broadcom.com> <51E7E2AD.8020106@ti.com> <51F122D5.80205@broadcom.com> <51F1E39D.2030902@ti.com> <51F1E65B.4020005@ti.com> <51F24BD6.9010405@broadcom.com> <51F24C47.8060802@broadcom.com> <51F24E38.4090008@broadcom.com>
In-Reply-To: <51F24E38.4090008@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/26/2013 01:23 PM, Arend van Spriel wrote:
> On 07/26/2013 12:15 PM, Arend van Spriel wrote:
>> On 07/26/2013 12:13 PM, Arend van Spriel wrote:
>>> On 07/26/2013 05:00 AM, Joel Fernandes wrote:
>>>> On 07/25/2013 09:49 PM, Joel Fernandes wrote:
>>>>
>>>> [..]
>>>>
>>>>>> Can I get back on this topic. When USB and ethernet was working for me
>>>>>> as stated above, I was not doing tftpboot. When I use tftpboot the
>>>>>> images are obtained from the tftp server, but after kernel has started
>>>>>> there is nothing in /sys/bus/usb/devices/.
>>>>>
>>>>> I quickly tried 3.11-rc2 + Roger's USB PHY clock patch on
>>>>> omap4-panda-es
>>>>> and enabled following USB options:
>>>>>
>>>>> CONFIG_USB_MUSB_HDRC=y
>>>>> CONFIG_USB_PHY=y
>>>>> CONFIG_OMAP_USB2=y
>>>>> CONFIG_OMAP_CONTROL_USB=y
>>>>> CONFIG_USB_MUSB_OMAP2PLUS=y
>>>>> CONFIG_MFD_OMAP_USB_HOST=y
>>>>> CONFIG_USB_EHCI_HCD=y
>>
>> Aaargh. Missing this one. Will retry.
> 
> Yes. That is working although it seems I don't need the MUSB stuff.

MUSB is required for the micro OTG port and not USB host ports.

cheers,
-roger

