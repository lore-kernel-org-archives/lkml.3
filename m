Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754850Ab3CVIRE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 04:17:04 -0400
Received: from am1ehsobe002.messaging.microsoft.com ([213.199.154.205]:26647
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754574Ab3CVIRA convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 04:17:00 -0400
X-Forefront-Antispam-Report: CIP:66.35.236.232;KIP:(null);UIP:(null);IPV:NLI;H:SJ-ITEXEDGE02.altera.priv.altera.com;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VS-3(zz98dI936eI1432Izz1f42h1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275bhz2fh2a8h668h839h93fhd24hd2bhf0ah107ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1155h)
Message-ID: <1363940208.2289.22.camel@leyfoon-vm>
Subject: Re: [PATCHv2 2/2] serial: of_serial: Handle fifo-size property
From: Ley Foon Tan <lftan@altera.com>
To: Heikki Krogerus <heikki.krogerus@linux.intel.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Rob Landley <rob@landley.net>,
        <linux-kernel@vger.kernel.org>, <linux-serial@vger.kernel.org>
Date: Fri, 22 Mar 2013 16:16:48 +0800
In-Reply-To: <1363939516-17308-1-git-send-email-heikki.krogerus@linux.intel.com>
References: <20130322074154.GA9250@xps8300>
	 <1363939516-17308-1-git-send-email-heikki.krogerus@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-OriginatorOrg: altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-03-22 at 10:05 +0200, Heikki Krogerus wrote:
> This will reduce the need for extra types in 8250.c just
> in case the fifo size differs from the standard.
Besides the fifo size, we need to have hardware flow control setting
from device tree as well.
Thanks.
> 
> Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
> ---
>  Documentation/devicetree/bindings/tty/serial/of-serial.txt |    1 +
>  drivers/tty/serial/of_serial.c                             |    4 ++++
>  2 files changed, 5 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/tty/serial/of-serial.txt b/Documentation/devicetree/bindings/tty/serial/of-serial.txt
> index 8f01cb1..c13f0ce 100644
> --- a/Documentation/devicetree/bindings/tty/serial/of-serial.txt
> +++ b/Documentation/devicetree/bindings/tty/serial/of-serial.txt
> @@ -33,6 +33,7 @@ Optional properties:
>    RTAS and should not be registered.
>  - no-loopback-test: set to indicate that the port does not implements loopback
>    test mode
> +- fifo-size: the fifo size of the UART.
>  



