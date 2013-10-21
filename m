Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751878Ab3JUUlX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 16:41:23 -0400
Received: from [184.168.131.12] ([184.168.131.12]:37665 "EHLO
	p3plex2out01.prod.phx3.secureserver.net" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751665Ab3JUUlW convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 16:41:22 -0400
From: Hartley Sweeten <HartleyS@visionengravers.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        ARM Kernel <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Ryan Mallon <rmallon@gmail.com>,
        "stern@rowland.harvard.edu" <stern@rowland.harvard.edu>,
        Lennert Buytenhek <buytenh@wantstofly.org>,
        "olof@lixom.net" <olof@lixom.net>,
        Russell King <linux@arm.linux.org.uk>
Subject: RE: [PATCH 2/2 v4] usb: ohci: remove ep93xx bus glue platform driver
Thread-Topic: [PATCH 2/2 v4] usb: ohci: remove ep93xx bus glue platform
 driver
Thread-Index: AQHOzRFHnRgbqp/qd0SS0vqfPk3S8Zn/oR4w
Date: Mon, 21 Oct 2013 20:41:00 +0000
Message-ID: <DC148C5AA1CEBA4E87973D432B1C2D8817DB9D93@P3PWEX4MB008.ex4.secureserver.net>
References: <201310171329.12434.hartleys@visionengravers.com>
 <20131019212213.GA5341@kroah.com>
In-Reply-To: <20131019212213.GA5341@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [184.183.19.121]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, October 19, 2013 2:22 PM, Greg KH wrote:
> On Thu, Oct 17, 2013 at 01:29:11PM -0700, H Hartley Sweeten wrote:
>> Convert ep93xx to use the OHCI platform driver and remove the
>> ohci-ep93xx bus glue driver.
>> 
>> Enable CONFIG_OHCI_HCD_PLATFORM in the ep93xx_defconfig so that USB
>> is still enabled by default on the EP93xx platform.
>> 
>> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>

[snip]

> This patch doesn't apply to my usb-next branch of usb.git at all, what
> happened?  Did Alan's other recent changes interfere with this?
>
> Can you refresh this against my tree and resend it so that I can apply
> it?  I've applied the 1/2 patch already.

Greg,

I just refreshed this patch against usb-next and sent it as v5.

Thanks,
Hartley

