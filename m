Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751888Ab3JURXx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 13:23:53 -0400
Received: from p3plex2out01.prod.phx3.secureserver.net ([184.168.131.12]:56281
	"EHLO p3plex2out01.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751826Ab3JURXv convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 13:23:51 -0400
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
Thread-Index: AQHOzRFHnRgbqp/qd0SS0vqfPk3S8Zn/aZEA
Date: Mon, 21 Oct 2013 17:23:49 +0000
Message-ID: <DC148C5AA1CEBA4E87973D432B1C2D8817DB953A@P3PWEX4MB008.ex4.secureserver.net>
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
>> Acked-by: Alan Stern <stern@rowland.harvard.edu>
>> Cc: Ryan Mallon <rmallon@gmail.com>
>> Cc: Lennert Buytenhek <kernel@wantstofly.org>
>> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> Cc: Olof Johansson <olof@lixom.net>
>> Cc: Russell King <linux@arm.linux.org.uk>
>> ---
>>  arch/arm/configs/ep93xx_defconfig |   1 +
>>  arch/arm/mach-ep93xx/clock.c      |   2 +-
>>  arch/arm/mach-ep93xx/core.c       |  38 +++++++-
>>  drivers/usb/host/ohci-ep93xx.c    | 184 --------------------------------------
>>  drivers/usb/host/ohci-hcd.c       |  18 ----
>>  5 files changed, 36 insertions(+), 207 deletions(-)
>>  delete mode 100644 drivers/usb/host/ohci-ep93xx.c
>
> This patch doesn't apply to my usb-next branch of usb.git at all, what
> happened?  Did Alan's other recent changes interfere with this?

With the temporary linux-next shutdown it appears that I based this on
the mainline git tree. Sorry about that.

> Can you refresh this against my tree and resend it so that I can apply
> it?  I've applied the 1/2 patch already.

I'll try to pull usb-next today and rebase this.

Regards,
Hartley

