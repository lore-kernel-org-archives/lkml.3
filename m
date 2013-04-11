Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934940Ab3DKNCs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 09:02:48 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:53673 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752426Ab3DKNCq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 09:02:46 -0400
Message-ID: <5166B450.1000404@ahsoftware.de>
Date: Thu, 11 Apr 2013 15:02:08 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.4
MIME-Version: 1.0
To: Roger Quadros <rogerq@ti.com>
CC: balbi@ti.com, Greg KH <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Subject: Re: [PATCH] USB: ehci-omap: Select USB_PHY
References: <5166856C.3080906@ti.com> <20130411100435.GB14394@arwen.pp.htv.fi> <516695A4.2050804@ti.com> <20130411105557.GE14394@arwen.pp.htv.fi> <5166AFD2.4070108@ti.com>
In-Reply-To: <5166AFD2.4070108@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 11.04.2013 14:42, schrieb Roger Quadros:
> On 04/11/2013 01:55 PM, Felipe Balbi wrote:

>> I would avoid 'select' completely and just update omap2plus_defconfig
>> adding those two as modules.
>>
> 
> OK, makes sense. I will update the patch to remove "select NOP_USB_XCEIV".

Sorry, but this just will end up with many users having broken configs
because of disabled stuff they don't know why they have to enable them.
And thus with a never ending stream of questions and thus with a needed
FAQ entry.

Regards,

Alexander

