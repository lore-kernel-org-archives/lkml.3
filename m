Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751183AbaKYOid (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 09:38:33 -0500
Received: from mail-lb0-f169.google.com ([209.85.217.169]:61804 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041AbaKYOia convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 09:38:30 -0500
Content-Type: text/plain; charset=koi8-r
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: [PATCH v2] omap: i2c: don't check bus state IP rev3.3 and earlier
From: Alexander Kochetkov <al.kochet@gmail.com>
In-Reply-To: <20141125141924.GD1843@katana>
Date: Tue, 25 Nov 2014 17:38:23 +0300
Cc: Tony Lindgren <tony@atomide.com>, linux-omap@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        Felipe Balbi <balbi@ti.com>, Kevin Hilman <khilman@kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <7E0A0B24-91D5-41A4-B007-004C5965D0D7@gmail.com>
References: <20141124210809.GG2817@atomide.com> <1416867655-22232-1-git-send-email-al.kochet@gmail.com> <20141125141924.GD1843@katana>
To: Wolfram Sang <wsa@the-dreams.de>
X-Mailer: Apple Mail (2.1878.6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


25 нояб. 2014 г., в 17:19, Wolfram Sang <wsa@the-dreams.de> написал(а):

> I'll push out this evening to make the boot tests work again. If there
> is more to be investigated, either hurry up and post v3 ;) or let me
> know that you need more time.

Ok, thank you. Let the fix go to the kernel-next.
Maybe small fix to subject "omap: i2c:" to "i2c: omap:"

I still guessing what some boards have broken i2c pull-ups.
And real fix must go in the board file.
http://www.spinics.net/lists/linux-i2c/msg17750.html

I could create a patch to confirm this.
But I don't have omap3530 boards to run.
I'll be very appreciated if someone could run the patch.

Regards,
Alexander.

