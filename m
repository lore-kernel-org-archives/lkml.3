Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752779Ab3GPHAV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 03:00:21 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:34756 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751715Ab3GPHAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 03:00:19 -0400
Message-ID: <51E4EF70.3040502@ti.com>
Date: Tue, 16 Jul 2013 12:30:00 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Daniel Mack <zonque@gmail.com>
CC: Aaro Koskinen <aaro.koskinen@iki.fi>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: v3.11-rc1 USB regressions
References: <20130715225647.GE3296@blackmetal.musicnaut.iki.fi> <51E4E922.2040707@gmail.com>
In-Reply-To: <51E4E922.2040707@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tuesday 16 July 2013 12:03 PM, Daniel Mack wrote:
> Hi Aaro,
> 
> On 16.07.2013 00:56, Aaro Koskinen wrote:
>> Hi,
>>
>> I think USB tree introduced regressions in v3.11-rc1, at least for some
>> OMAP devices using legacy boot.
> 
> Thanks for checking the tree so early.
> 
>> I have only bisected these; I have no
>> idea what the real fixes are but the following reverts make Nokia OMAP2+
>> boards again usable for kernel development work (they need working USB
>> connection for interacting with the device):
>>
>> 1) USB peripheral mode (g_ether) is broken on Nokia N900, N950 and N9
>>    (USB_MUSB_OMAP2PLUS). To make it it work, I need to revert three
>>    commits:
>>
>> 	09fc7d22b024692b2fe8a943b246de1af307132b
>> 	usb: musb: fix incorrect usage of resource pointer
>> 	(Reverting this fixes the g_ether probe failure "couldn't find
>> 	 an available UDC")

I've posted a patch fixing the issue
http://comments.gmane.org/gmane.linux.usb.general/89541
There were some comments on it. I'll be posting a new version for it.

Thanks
Kishon
