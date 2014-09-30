Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752103AbaI3RM3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 13:12:29 -0400
Received: from mail-lb0-f177.google.com ([209.85.217.177]:50703 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751047AbaI3RM1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 13:12:27 -0400
From: Peter Korsgaard <peter@korsgaard.com>
To: Boris Brezillon <boris.brezillon@free-electrons.com>
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
References: <1412093987-30241-1-git-send-email-boris.brezillon@free-electrons.com>
	<1412093987-30241-5-git-send-email-boris.brezillon@free-electrons.com>
Date: Tue, 30 Sep 2014 19:12:22 +0200
In-Reply-To: <1412093987-30241-5-git-send-email-boris.brezillon@free-electrons.com>
	(Boris Brezillon's message of "Tue, 30 Sep 2014 18:19:45 +0200")
Message-ID: <87bnpxoww9.fsf@dell.be.48ers.dk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Boris" == Boris Brezillon <boris.brezillon@free-electrons.com> writes:

 > Document DT bindings of Atmel's TRNG (True Random Number Generator) IP.
 > Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
 > ---
 >  Documentation/devicetree/bindings/hwrng/atmel-trng.txt | 16 ++++++++++++++++
 >  1 file changed, 16 insertions(+)
 >  create mode 100644 Documentation/devicetree/bindings/hwrng/atmel-trng.txt

 > diff --git a/Documentation/devicetree/bindings/hwrng/atmel-trng.txt b/Documentation/devicetree/bindings/hwrng/atmel-trng.txt
 > new file mode 100644
 > index 0000000..4ac5aaa
 > --- /dev/null
 > +++ b/Documentation/devicetree/bindings/hwrng/atmel-trng.txt
 > @@ -0,0 +1,16 @@
 > +Atmel TRNG (True Random Number Generator) block
 > +
 > +Required properties:
 > +- compatible : Should be "atmel,at91sam9g45-trng"
 > +- reg : Offset and length of the register set of this block
 > +- interrupts : the interrupt number for the TRNG block

The interrupt isn't strictly speaking required as it isn't used by the
driver, but as 9G45 has the signal wired up I guess it makes sense.

Acked-by: Peter Korsgaard <peter@korsgaard.com>

-- 
Bye, Peter Korsgaard
