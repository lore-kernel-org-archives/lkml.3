Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755032AbaFWOXt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 10:23:49 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:16337 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753861AbaFWOXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 10:23:48 -0400
Message-ID: <1403533425.3804.35.camel@hornet>
Subject: Re: [PATCH v7 1/2] video: ARM CLCD: Add DT support
From: Pawel Moll <pawel.moll@arm.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Mark Rutland <Mark.Rutland@arm.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Kumar Gala <galak@codeaurora.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        arm-mail-list <linux-arm-kernel@lists.infradead.org>
Date: Mon, 23 Jun 2014 15:23:45 +0100
In-Reply-To: <20140623141022.GJ32514@n2100.arm.linux.org.uk>
References: <1403018494-10264-1-git-send-email-pawel.moll@arm.com>
	 <CAFEAcA-NZiRDDeUc7n+6hxgjG1V3qYXPAwyfSdtyz=ZCcD8kiw@mail.gmail.com>
	 <1403531535.3804.11.camel@hornet>
	 <20140623141022.GJ32514@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-06-23 at 15:10 +0100, Russell King - ARM Linux wrote:
> As far as the CLD outputs are concerned, they are standard.  The PLD on
> their outputs routes the CLD bits to the 8-bit red, green and blue
> channels according to the configuration of SYS_CLCD to achieve the
> various colour formats which the CLCD does not natively provide for.
> 
> So, it /is/ a PL110 with an independent external muxer.

Cool, this means that one can still use this property do define which
CLDs are wired to R/G/B-0s and make an informed decision in the driver
based on this (although with a separate compatible value it won't be
really necessary).

Pawel

