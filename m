Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752604AbaI3Q5U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 12:57:20 -0400
Received: from mail-lb0-f175.google.com ([209.85.217.175]:55177 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751967AbaI3Q5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 12:57:18 -0400
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
Subject: Re: [PATCH 3/6] hwrng: atmel: add DT support
References: <1412093987-30241-1-git-send-email-boris.brezillon@free-electrons.com>
	<1412093987-30241-4-git-send-email-boris.brezillon@free-electrons.com>
Date: Tue, 30 Sep 2014 18:57:12 +0200
In-Reply-To: <1412093987-30241-4-git-send-email-boris.brezillon@free-electrons.com>
	(Boris Brezillon's message of "Tue, 30 Sep 2014 18:19:44 +0200")
Message-ID: <87fvf9oxlj.fsf@dell.be.48ers.dk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Boris" == Boris Brezillon <boris.brezillon@free-electrons.com> writes:

 > Add DT support.
 > Make the driver depend on CONFIG_OF as at91sam9g45 was the only SoC making
 > use of the TRNG block and this SoC is now fully migrated to DT.

 > Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>

Acked-by: Peter Korsgaard <peter@korsgaard.com>

-- 
Bye, Peter Korsgaard
