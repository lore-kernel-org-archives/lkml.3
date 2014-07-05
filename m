Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753390AbaGEO4B (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2014 10:56:01 -0400
Received: from mail001.aei.ca ([206.123.6.130]:53439 "EHLO mail001.aei.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751559AbaGEO4A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2014 10:56:00 -0400
From: Ed Tomlinson <edt@aei.ca>
To: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [USB spamming log] with 3.16-rc (git) my pl2303 is spaming my logs
Date: Sat, 05 Jul 2014 10:55:57 -0400
Message-ID: <4878627.a0D3mPHSVv@grover>
Organization: me
User-Agent: KMail/4.13.2 (Linux/3.16.0-1-git; KDE/4.13.2; x86_64; ; )
In-Reply-To: <1404459477.27680.10.camel@x220>
References: <1404459477.27680.10.camel@x220>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I have a raspberry PI sending its console to my box via a pl2303 

[    5.184385] usbserial: USB Serial support registered for pl2303
[    5.184398] pl2303 1-2.6:1.0: pl2303 converter detected
[    5.185353] usb 1-2.6: pl2303 converter now attached to ttyUSB0

and with the latest fixes from git on 3.16 its now started spamming my logs with: 

[55507.155354] pl2303 ttyUSB0: usb_serial_generic_read_bulk_callback - nonzero urb status: -71
[55510.736558] pl2303 ttyUSB0: usb_serial_generic_read_bulk_callback - nonzero urb status: -71
[55517.238586] pl2303 ttyUSB0: usb_serial_generic_read_bulk_callback - nonzero urb status: -71
[55521.099938] pl2303 ttyUSB0: usb_serial_generic_read_bulk_callback - nonzero urb status: -71
[55521.778520] pl2303 ttyUSB0: usb_serial_generic_read_bulk_callback - nonzero urb status: -71
[55523.229808] pl2303 ttyUSB0: usb_serial_generic_read_bulk_callback - nonzero urb status: -71
[55523.229846] pl2303 ttyUSB0: usb_serial_generic_read_bulk_callback - nonzero urb status: -71
[55525.074519] pl2303 ttyUSB0: usb_serial_generic_read_bulk_callback - nonzero urb status: -71
[55527.270207] pl2303 ttyUSB0: usb_serial_generic_read_bulk_callback - nonzero urb status: -71

Please fix.

Thanks
Ed Tomlinson
