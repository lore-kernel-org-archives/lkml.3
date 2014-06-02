Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752902AbaFBHbS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 03:31:18 -0400
Received: from sam.nabble.com ([216.139.236.26]:55945 "EHLO sam.nabble.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751442AbaFBHbQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 03:31:16 -0400
Date: Mon, 2 Jun 2014 00:31:16 -0700 (PDT)
From: "sarfaraz5286@gmail.com" <sarfaraz5286@gmail.com>
To: linux-kernel@vger.kernel.org
Message-ID: <1401694276239-872314.post@n7.nabble.com>
In-Reply-To: <1363164430-19118-1-git-send-email-kishon@ti.com>
References: <1363164430-19118-1-git-send-email-kishon@ti.com>
Subject: Re: [PATCH 0/5] usb: musb/otg: cleanup and fixes
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have a battery operated android device. for charging I have a docking
station. to copy the images USB stick is attached to the docking station
while device is also inserted in docking station.

I have the following issue

when I power off the docking station my USB stick is not detected even
though my android device is attached in docking station how can I set the
vbus on in twl4030.c driver code.
there must be somewhere int he code that it checks both power supply and USB
both on to load the drivers, so at that point I can just check for the USB
and not the power supply.

Thanks.



--
View this message in context: http://linux-kernel.2935.n7.nabble.com/PATCH-0-5-usb-musb-otg-cleanup-and-fixes-tp615388p872314.html
Sent from the Linux Kernel mailing list archive at Nabble.com.
