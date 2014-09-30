Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753564AbaI3RWG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 13:22:06 -0400
Received: from top.free-electrons.com ([176.31.233.9]:57435 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752075AbaI3RWD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 13:22:03 -0400
Date: Tue, 30 Sep 2014 19:21:49 +0200
From: Boris Brezillon <boris.brezillon@free-electrons.com>
To: Peter Korsgaard <peter@korsgaard.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Andrew Victor <linux@maxim.org.za>,
        Peter Korsgaard <jacmet@sunsite.dk>, Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-arm-kernel@lists.infradead.org, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/6] hwrng: atmel: Add TRNG DT binding doc
Message-ID: <20140930192149.464ac50f@bbrezillon>
In-Reply-To: <87bnpxoww9.fsf@dell.be.48ers.dk>
References: <1412093987-30241-1-git-send-email-boris.brezillon@free-electrons.com>
	<1412093987-30241-5-git-send-email-boris.brezillon@free-electrons.com>
	<87bnpxoww9.fsf@dell.be.48ers.dk>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On Tue, 30 Sep 2014 19:12:22 +0200
Peter Korsgaard <peter@korsgaard.com> wrote:

> >>>>> "Boris" == Boris Brezillon <boris.brezillon@free-electrons.com> writes:
> 
>  > Document DT bindings of Atmel's TRNG (True Random Number Generator) IP.
>  > Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
>  > ---
>  >  Documentation/devicetree/bindings/hwrng/atmel-trng.txt | 16 ++++++++++++++++
>  >  1 file changed, 16 insertions(+)
>  >  create mode 100644 Documentation/devicetree/bindings/hwrng/atmel-trng.txt
> 
>  > diff --git a/Documentation/devicetree/bindings/hwrng/atmel-trng.txt b/Documentation/devicetree/bindings/hwrng/atmel-trng.txt
>  > new file mode 100644
>  > index 0000000..4ac5aaa
>  > --- /dev/null
>  > +++ b/Documentation/devicetree/bindings/hwrng/atmel-trng.txt
>  > @@ -0,0 +1,16 @@
>  > +Atmel TRNG (True Random Number Generator) block
>  > +
>  > +Required properties:
>  > +- compatible : Should be "atmel,at91sam9g45-trng"
>  > +- reg : Offset and length of the register set of this block
>  > +- interrupts : the interrupt number for the TRNG block
> 
> The interrupt isn't strictly speaking required as it isn't used by the
> driver, but as 9G45 has the signal wired up I guess it makes sense.

This irq might be used in a near future (in order to wait for data as
requested by hwrng code when the wait argument is true).
Thus I prefer to keep it as required.

Best Regards,

Boris

-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
