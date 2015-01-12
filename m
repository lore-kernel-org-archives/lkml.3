Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751530AbbALLUk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 06:20:40 -0500
Received: from mail-we0-f172.google.com ([74.125.82.172]:37642 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751361AbbALLUi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 06:20:38 -0500
Date: Mon, 12 Jan 2015 06:20:33 -0500
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
To: Olivier Sobrie <olivier@sobrie.be>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Cc: "David S. Miller" <davem@davemloft.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Linux-CAN <linux-can@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 3/4] can: kvaser_usb: Add support for the Usbcan-II
 family
Message-ID: <20150112112033.GB9213@linux>
References: <20141223154654.GB6460@vivalin-002>
 <20150111200544.GA8855@linux>
 <20150111201116.GB8855@linux>
 <20150111201519.GC8855@linux>
 <20150111203612.GA8999@linux>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150111203612.GA8999@linux>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Marc,

On Sun, Jan 11, 2015 at 03:36:12PM -0500, Ahmed S. Darwish wrote:
> From: Ahmed S. Darwish <ahmed.darwish@valeo.com>
> 
> CAN to USB interfaces sold by the Swedish manufacturer Kvaser are
> divided into two major families: 'Leaf', and 'UsbcanII'.  From an
> Operating System perspective, the firmware of both families behave
> in a not too drastically different fashion.
> 
> This patch adds support for the UsbcanII family of devices to the
> current Kvaser Leaf-only driver.
> 
> CAN frames sending, receiving, and error handling paths has been
> tested using the dual-channel "Kvaser USBcan II HS/LS" dongle. It
> should also work nicely with other products in the same category.
> 

Please delay applying this to as I've just discovered that
removal of two of the device family checks introduced two
un-necessary GCC warnings.

Will send and updated version soon.

Thanks,
Darwish
