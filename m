Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935463Ab3DHSQu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 14:16:50 -0400
Received: from mail-we0-f180.google.com ([74.125.82.180]:55795 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935365Ab3DHSQt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 14:16:49 -0400
Message-ID: <5163098E.7000604@openwrt.org>
Date: Mon, 08 Apr 2013 20:16:46 +0200
From: Florian Fainelli <florian@openwrt.org>
Organization: OpenWrt
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: stern@rowland.harvard.edu, linux-kernel@vger.kernel.org, arnd@arndb.de,
        linux-usb@vger.kernel.org, balbi@ti.com
Subject: Re: [PATCH 0/5 v3] USB: Kconfig cleanups
References: <1365091048-16229-1-git-send-email-florian@openwrt.org> <20130408163242.GA2184@kroah.com>
In-Reply-To: <20130408163242.GA2184@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 08/04/2013 18:32, Greg KH a écrit :
> On Thu, Apr 04, 2013 at 05:57:23PM +0200, Florian Fainelli wrote:
>>
>> These 5 patches contain my Kconfig cleanup on which I based the removal
>> of the USB_ARCH_HAS_* patches. They have been suggested by Alan Stern
>> as part of an earlier conversations.
>>
>> Let me know what you think about it so I can post subsequent work based
>> on it.
>
> This series doesn't apply to my tree at the moment.  Can you refresh it
> based on linux-next and resend it, with Alan's acks added?

Sure, it was based on usb-next, I will refresh that, thanks!
--
Florian
