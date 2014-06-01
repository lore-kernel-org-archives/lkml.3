Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756913AbaFAAOb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2014 20:14:31 -0400
Received: from donald.hachti.de ([188.40.85.216]:37227 "EHLO donald.hachti.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752609AbaFAAOa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2014 20:14:30 -0400
Message-ID: <538A7063.8010205@hachti.de>
Date: Sun, 01 Jun 2014 02:14:27 +0200
From: Philipp Hachtmann <hachti@hachti.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: jhovold@gmail.com, gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] usb/ftdi_sio: Add support for setting CBUS pins on
 FT232H
References: <1401579066-8298-1-git-send-email-hachti@hachti.de> <1401579066-8298-3-git-send-email-hachti@hachti.de> <20140601000059.27360.qmail@stuge.se>
In-Reply-To: <20140601000059.27360.qmail@stuge.se>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01.06.2014 02:00, Peter Stuge wrote:
> Philipp Hachtmann wrote:
>> This patch adds a sysfs attribute "cbus" which allows to set the
>> four CBUS pins on the FT232H.
>
> I think this should be implemented with the gpio subsystem instead.
The GPIO subsystem seems to be made for GPIO pins connected directly to the 
computer. The Beaglebone with its AM335x SoC seems to be a good example of
a computer with many GPIOs in the sense of the GPIO subsystem.
And the GPIO pins have fixed unique numbers. No, I don't think that the GPIO 
subsystem has anything to do with the additional pins on some USB device.
Please correct me if I'm completely wrong.

Kind regards,

Philipp


