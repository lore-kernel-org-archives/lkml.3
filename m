Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753834Ab3LBMCA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 07:02:00 -0500
Received: from www.linutronix.de ([62.245.132.108]:44017 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753561Ab3LBMB6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 07:01:58 -0500
Message-ID: <529C76AF.10106@linutronix.de>
Date: Mon, 02 Dec 2013 13:01:51 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: Roger Quadros <rogerq@ti.com>
CC: Michael Trimarchi <michael@amarulasolutions.com>,
        Felipe Balbi <balbi@ti.com>, lee.jones@linaro.org,
        sameo@linux.intel.com, tomi.valkeinen@ti.com,
        Stefan Roese <sr@denx.de>, ljkenny.mailinglists@gmail.com,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] mfd: omap-usb-host: Fix USB device detection problems
 on OMAP4 Panda
References: <1385730118-26402-1-git-send-email-rogerq@ti.com>	<1385730118-26402-2-git-send-email-rogerq@ti.com> <CAOf5uwmEkzFd=e3j8m8=qdTCAMkk_-DPw0fTm=7Vzy0PbE2oDQ@mail.gmail.com> <529C55DF.3000808@ti.com>
In-Reply-To: <529C55DF.3000808@ti.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- stable@vger.kernel.org since they probably don't care about this
  unless the patch is merged.

On 12/02/2013 10:41 AM, Roger Quadros wrote:
> Michael,
> 
> On 11/29/2013 05:32 PM, Michael Trimarchi wrote:
>> Hi Roger
>>
>> On Fri, Nov 29, 2013 at 2:01 PM, Roger Quadros <rogerq@ti.com> wrote:
>>> With u-boot 2013.10, USB devices are sometimes not detected
>>> on OMAP4 Panda. To make us independent of what bootloader does
>>> with the USB Host module, we must RESET it to get it to a known
>>> good state. This patch Soft RESETs the USB Host module.
>>>
>>
>> Do you think that we need something similar of usb musb?
>> I have seen the OTG_SYSCONFIG is touched in uboot and
>> only readed in omap2430.c.
> 
> I'm not sure about musb. Maybe Sebastian/Felipe have better idea.
> In general I believe that all modules must be reset by the kernel.
> 

based on the code at the bottom it touches the first few register(s)
sysconfig. Isn't hwmod actually doing this idle stuff and resting the
device during boot?

> cheers,
> -roger
>>

Sebastian
