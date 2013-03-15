Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754610Ab3COPwO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 11:52:14 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:52832 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754365Ab3COPwM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 11:52:12 -0400
Message-ID: <514343A2.5010702@ti.com>
Date: Fri, 15 Mar 2013 21:22:02 +0530
From: kishon <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: <balbi@ti.com>
CC: <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <tony@atomide.com>, <notasas@gmail.com>
Subject: Re: [PATCH 1/4] usb: Fix linker errors during build
References: <1363354132-27523-1-git-send-email-kishon@ti.com> <20130315142556.GA23930@arwen.pp.htv.fi>
In-Reply-To: <20130315142556.GA23930@arwen.pp.htv.fi>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 15 March 2013 07:55 PM, Felipe Balbi wrote:
> On Fri, Mar 15, 2013 at 06:58:49PM +0530, Kishon Vijay Abraham I wrote:
>> commit 63378a (usb: phy: remove CONFIG_USB_OTG_UTILS) removed
>> CONFIG_USB_OTG_UTILS from Kconfig but failed to removed from Makefile.
>> Fixed it here.
>>
>> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
>
> I can fold it in original commit since that's not in mainline yet,
> thanks

Sure.

Thanks
Kishon
