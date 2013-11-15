Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752009Ab3KON1L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 08:27:11 -0500
Received: from senator.holtmann.net ([87.106.208.187]:60104 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034Ab3KON1B convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 08:27:01 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 7.0 \(1822\))
Subject: Re: [PATCH] Staging: btmtk_usb: Add hdev parameter to hdev->send driver callback
From: Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20131115130820.GS5302@mwanda>
Date: Fri, 15 Nov 2013 22:26:41 +0900
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, devel@driverdev.osuosl.org,
        Johan Hedberg <johan.hedberg@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Yu-Chen Cho <acho@suse.com>,
        "linux-kernel@vger.kernel.org list" <linux-kernel@vger.kernel.org>,
        "linux-bluetooth@vger.kernel.org development" 
	<linux-bluetooth@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <F615BA13-BEC1-457B-8002-BC6C149039EA@holtmann.org>
References: <1384517231-1605-1-git-send-email-geert@linux-m68k.org> <D32EAC93-D2DE-431C-9DCB-885C5AA10A3A@holtmann.org> <20131115130820.GS5302@mwanda>
To: Dan Carpenter <dan.carpenter@oracle.com>
X-Mailer: Apple Mail (2.1822)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dan,

>> while this is patch is correct, I do not really care about staging drivers that actually bluntly violate my copyright.
>> 
> 
> That's very cryptic.
> 
> What is going on here?  I googled it and I wasn't able to find what you
> are talking about.  Care to give us a hint and what you want us to do
> here?

the last time I checked, the majority of drivers/bluetooth/btusb.c has been written by myself. Now go and compare btusb.c to btmtk_usb.[ch].

> I have also added Johan Hedberg to the CC list because he also helped
> break the build.  Don't do that.

Yes, we are doing exactly that. It is a staging driver. I could not care less if a staging drivers breaks the build or not.

If anybody cares about this driver, then take the time to merge it upstream. It has never been submitted to linux-bluetooth mailing list.

There are drivers that should have never been merged into staging. This is one of them. Look for yourself and explain to me why this driver is part of staging in the first place.

Regards

Marcel

