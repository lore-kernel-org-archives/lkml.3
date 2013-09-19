Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753120Ab3ISG0Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 02:26:24 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42283 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752486Ab3ISG0X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 02:26:23 -0400
Message-ID: <1379571981.8608.2.camel@linux-fkkt.site>
Subject: Re: unsupported usb bluetooth device
From: Oliver Neukum <oneukum@suse.de>
To: "Ken O'Brien" <kernel@kenobrien.org>
Cc: marcel@holtmann.org, linux-kernel@vger.kernel.org
Date: Thu, 19 Sep 2013 08:26:21 +0200
In-Reply-To: <1379552845.4788.6.camel@mjolnir.site>
References: <1379552845.4788.6.camel@mjolnir.site>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.9.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-09-19 at 02:07 +0100, Ken O'Brien wrote:
> Hi,
> 
> I've acquired a Belkin "Mini Bluetooth v4.0 Adapter" F8T065bf
> 8830bf12557 Rev. A01.
> 
> I'm running Linux 3.7.10-1.16 (openSUSE 12.3) and this device is not
> detecting beyond what I can see in lsusb.

That usually means that it is not advertising itself as a class
device.

> What steps can I take to aid in patching the kernel to support this
> device? I am a proficient C/asm programmer but I've not done kernel
> driver dev before.

You can try to add it to btusb.c. There's a table of BT adapters
that advertise themselves as vendor specific.

	Regards
		Oliver


