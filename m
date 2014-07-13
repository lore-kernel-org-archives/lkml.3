Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751568AbaGMTRR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2014 15:17:17 -0400
Received: from p3plex2out02.prod.phx3.secureserver.net ([184.168.131.14]:43425
	"EHLO p3plex2out02.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751313AbaGMTRG convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2014 15:17:06 -0400
From: Hartley Sweeten <HartleyS@visionengravers.com>
To: Chase Southwood <chase.southwood@gmail.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: "abbotti@mev.co.uk" <abbotti@mev.co.uk>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 2/2] staging: comedi: addi_apci_1564: use addi_watchdog
 module to init watchdog subdevice
Thread-Topic: [PATCH 2/2] staging: comedi: addi_apci_1564: use addi_watchdog
 module to init watchdog subdevice
Thread-Index: AQHPniLjmd9jMAfz+0KWcL43PQIqp5ueYVPn
Date: Sun, 13 Jul 2014 19:17:03 +0000
Message-ID: <DC148C5AA1CEBA4E87973D432B1C2D8825EF2E84@P3PWEX4MB008.ex4.secureserver.net>
References: <1405204956-1559-1-git-send-email-chase.southwood@gmail.com>,<1405205049-1828-1-git-send-email-chase.southwood@gmail.com>
In-Reply-To: <1405205049-1828-1-git-send-email-chase.southwood@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [24.251.30.167]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, July 12, 2014 3:44 PM, Chase Southwood wrote:
> Use the addi_watchdog module to provide support for the watchdog
> subdevice.
>
> Also, rearrange the subdevice init blocks so that the order makes sense.
> Digital input/output subdevices and subdevices for DI/DO interrupt
> support, followed by timer/counter/watchdog subdevices is the new order.
>
> Signed-off-by: Chase Southwood <chase.southwood@gmail.com>
> Cc: Ian Abbott <abbotti@mev.co.uk>
> Cc: H Hartley Sweeten <hsweeten@visionengravers.com>
> ---
>  drivers/staging/comedi/drivers/addi_apci_1564.c | 34 +++++++++++++++----------
>  1 file changed, 20 insertions(+), 14 deletions(-)

Chase,

You should also add the dependency for the addi watchdog module
to the Kconfig.

Regards,
Hartley
