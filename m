Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755696AbbALTS2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 14:18:28 -0500
Received: from down.free-electrons.com ([37.187.137.238]:57208 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753667AbbALTSY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 14:18:24 -0500
Date: Mon, 12 Jan 2015 20:18:16 +0100
From: Boris Brezillon <boris.brezillon@free-electrons.com>
To: <balbi@ti.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        David Laight <David.Laight@ACULAB.COM>
Subject: Re: [PATCH v3 3/5] ARM: at91/dt: update udc compatible strings
Message-ID: <20150112201816.6e57fe74@bbrezillon>
In-Reply-To: <20150112182349.GJ6525@saruman>
References: <1421060278-27329-1-git-send-email-boris.brezillon@free-electrons.com>
	<1421060278-27329-4-git-send-email-boris.brezillon@free-electrons.com>
	<20150112182349.GJ6525@saruman>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Felipe,

On Mon, 12 Jan 2015 12:23:49 -0600
Felipe Balbi <balbi@ti.com> wrote:

> On Mon, Jan 12, 2015 at 11:57:56AM +0100, Boris Brezillon wrote:
> > at91sam9g45, at91sam9x5 and sama5 SoCs should not use
> > "atmel,at91sam9rl-udc" for their USB device compatible property since
> > this compatible is attached to a specific hardware bug fix.
> > 
> > Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
> > Acked-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> 
> WARNING: DT compatible string "atmel,at91sam9g45-udc" appears un-documented -- check ./Documentation/devicetree/bindings/
> #177: FILE: drivers/usb/gadget/udc/atmel_usba_udc.c:1827:
> +       { .compatible = "atmel,at91sam9g45-udc" },
> 
> WARNING: DT compatible string "atmel,sama5d3-udc" appears un-documented -- check ./Documentation/devicetree/bindings/
> #178: FILE: drivers/usb/gadget/udc/atmel_usba_udc.c:1828:
> +       { .compatible = "atmel,sama5d3-udc" },
> 
> please fix and resend. Also, when resending, could you add Nicolas'
> Acked-by since he's already given it ?

Actually these compatible strings are documented in the first patch
(where they were introduced), but I'll send a v4 with Nicolas' ack.

Thanks,

Boris



-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
