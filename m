Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933178AbaCRUUa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 16:20:30 -0400
Received: from smtprelay0019.hostedemail.com ([216.40.44.19]:32929 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932685AbaCRUU0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 16:20:26 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::,RULES_HIT:41:355:379:541:599:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1538:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:2915:3138:3139:3140:3141:3142:3350:3622:3865:3866:3867:3868:3870:3871:3872:4321:5007:6691:7652:10004:10400:10848:11232:11658:11914:12517:12519:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk
X-HE-Tag: part20_35f3cf868425
X-Filterd-Recvd-Size: 1580
Message-ID: <1395174021.2812.84.camel@joe-AO722>
Subject: Re: [PATCH 0/3] usbip: move usbip out of staging
From: Joe Perches <joe@perches.com>
To: Valentina Manea <valentina.manea.m@gmail.com>
Cc: gregkh@linuxfoundation.org, tulinizer@gmail.com, stern@rowland.harvard.edu,
        mail@beyermatthias.de, hdegoede@redhat.com, f.manzan@gmail.com,
        kurt@garloff.de, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, firefly@lists.rosedu.org,
        andy.grover@gmail.com
Date: Tue, 18 Mar 2014 13:20:21 -0700
In-Reply-To: <1395173483-27542-1-git-send-email-valentina.manea.m@gmail.com>
References: <1395173483-27542-1-git-send-email-valentina.manea.m@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-03-18 at 22:11 +0200, Valentina Manea wrote:
> After migrating userspace code to libudev, converting usbip-host
> to a device driver and various bug fixes and enhancements, USB/IP
> is fully functional and can be moved out of staging.
> 
> This patch series moves it as following:
> * userspace code to tools/usb/usbip
> * kernel code to drivers/usb/usbip
> 
> Besides this, a warning generated in the kernel code is solved.

Please use "git format-patch -M"

It'll make the patch _much_ smaller and easier to verify.


