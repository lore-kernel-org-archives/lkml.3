Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751818AbaAIBWc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 20:22:32 -0500
Received: from mail-pd0-f176.google.com ([209.85.192.176]:33727 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832AbaAIBW1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 20:22:27 -0500
Message-ID: <52CDF9CD.8010402@gmail.com>
Date: Wed, 08 Jan 2014 17:22:21 -0800
From: walt <w41ter@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
CC: Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        David Laight <david.laight@aculab.com>, linux-usb@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 3.12 033/118] usb: xhci: Link TRB must not occur within
 a USB payload burst
References: <20131218211219.461663463@linuxfoundation.org> <20131218211220.412278148@linuxfoundation.org> <52C32BB0.90600@gmail.com> <20140102191510.GA9621@xanatos> <52C6D9F1.9000709@gmail.com> <20140103195455.GA4193@xanatos> <52C729CE.9050307@gmail.com> <20140103232929.GD4193@xanatos>
In-Reply-To: <20140103232929.GD4193@xanatos>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/03/2014 03:29 PM, Sarah Sharp wrote:

> I'll let you know when I have some diagnostic patches ready.

Hi Sarah.  I see today gregkh committed the patches you've already sent
me, so I assume someone (other than me) has tested those patches and
discovered some benefit from them?

I'm still wondering if I'm suffering from hardware quirks.  From the
first day I installed my usb3 adapter card and the usb3 disk docking
station I've noticed some quirky behavior.

e.g. I boot the machine with the docking station powered-off, and then
later I power it on, the usb3 disk is not detected at all -- until I
reboot the machine with the docking station still powered on.

Minor stuff, yes, but maybe relevant?  I dunno.
