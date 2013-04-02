Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762045Ab3DBRK7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 13:10:59 -0400
Received: from mail-wg0-f54.google.com ([74.125.82.54]:60630 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761994Ab3DBRK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 13:10:56 -0400
Message-ID: <515B110D.7050905@openwrt.org>
Date: Tue, 02 Apr 2013 19:10:37 +0200
From: Florian Fainelli <florian@openwrt.org>
Organization: OpenWrt
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Florian Fainelli <florian@openwrt.org>
CC: stern@rowland.harvard.edu, linux-kernel@vger.kernel.org, arnd@arndb.de,
        gregkh@linuxfoundation.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH 0/5] USB: Kconfig cleanups
References: <1364321177-12146-1-git-send-email-florian@openwrt.org> <1364922314-30639-1-git-send-email-florian@openwrt.org>
In-Reply-To: <1364922314-30639-1-git-send-email-florian@openwrt.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 04/02/13 19:05, Florian Fainelli a écrit :
> Hello Alan, Greg,
>
> These 5 patches contain my Kconfig cleanup on which I based the removal
> of the USB_ARCH_HAS_* patches. They have been suggested by Alan Stern
> as part of an earlier conversations.
>
> Let me know what you think about it so I can post subsequent work based
> on it. This time I dropped the RFC from the subject.

Ok, this serie contains a small mistake in patch 1, please discard it 
and use v2 instead.

Thanks!
--
Florian
