Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753779AbaFBBs6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 21:48:58 -0400
Received: from donald.hachti.de ([188.40.85.216]:49935 "EHLO donald.hachti.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753681AbaFBBs5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 21:48:57 -0400
Message-ID: <538BD805.5040306@hachti.de>
Date: Mon, 02 Jun 2014 03:48:53 +0200
From: Philipp Hachtmann <hachti@hachti.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: jhovold@gmail.com, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] usb/ftdi_sio: Add support for setting CBUS pins on
 FT232H
References: <1401579066-8298-1-git-send-email-hachti@hachti.de> <1401579066-8298-3-git-send-email-hachti@hachti.de> <20140601000059.27360.qmail@stuge.se> <538A7063.8010205@hachti.de> <20140601023106.GA4961@kroah.com> <538BCC03.3090606@hachti.de> <20140602013839.GA831@kroah.com>
In-Reply-To: <20140602013839.GA831@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02.06.2014 03:38, Greg KH wrote:

 >> Yes but... I should have avoided the term "GPIO".> No, you used the right 
term :)
Sorry for using the right term :)

 > No, I am not going to add custom ioctls to a single driver for this.
I did neither request nor expect that - did it sound that way?

 > It would not be lost at all, you can see that relationship in sysfs
 > between the gpio device and the tty device, they are both attached to
 > the same "parent" usb interface.
Ok, I understand. This is a real argument for the GPIO stuff. I'm just beginning 
to understand that using the GPIO stuff will make everyone happy.

 > This comes up every 6 months or so, you aren't the first to ask for
 > custom ioctls / sysfs files for this chip.  But no one seems to want to
 > to do the work to make it a proper gpio device, which is sad :(
Ok, ok. I will do it but it will take some time. I will resend my two patches then.

Kind regards

Philipp
