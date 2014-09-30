Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752050AbaI3Rfo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 13:35:44 -0400
Received: from mail-lb0-f169.google.com ([209.85.217.169]:48062 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751320AbaI3Rfm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 13:35:42 -0400
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
	<87bnpxoww9.fsf@dell.be.48ers.dk> <20140930192149.464ac50f@bbrezillon>
Date: Tue, 30 Sep 2014 19:35:37 +0200
In-Reply-To: <20140930192149.464ac50f@bbrezillon> (Boris Brezillon's message
	of "Tue, 30 Sep 2014 19:21:49 +0200")
Message-ID: <877g0lovti.fsf@dell.be.48ers.dk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Boris" == Boris Brezillon <boris.brezillon@free-electrons.com> writes:

Hi,

 >> The interrupt isn't strictly speaking required as it isn't used by the
 >> driver, but as 9G45 has the signal wired up I guess it makes sense.

 > This irq might be used in a near future (in order to wait for data as
 > requested by hwrng code when the wait argument is true).
 > Thus I prefer to keep it as required.

Ok, fine by me.

-- 
Bye, Peter Korsgaard
