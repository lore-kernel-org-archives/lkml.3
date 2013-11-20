Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754827Ab3KTSns (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 13:43:48 -0500
Received: from 3.mo5.mail-out.ovh.net ([46.105.40.108]:45648 "EHLO
	mo5.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754083Ab3KTSnq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 13:43:46 -0500
Date: Wed, 20 Nov 2013 19:21:02 +0100
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org,
        grygorii.strashko@ti.com, Pawel Moll <pawel.moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>, gregkh@linuxfoundation.org,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@kernel.crashing.org>,
        Rob Herring <rob.herring@calxeda.com>, linux-kernel@vger.kernel.org,
        linux-mtd@lists.infradead.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/2] memory: ti-aemif: add bindings for AEMIF driver
Message-ID: <20131120182102.GK14627@ns203013.ovh.net>
References: <1384962416-14862-1-git-send-email-ivan.khoronzhuk@ti.com>
 <1384962416-14862-3-git-send-email-ivan.khoronzhuk@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1384962416-14862-3-git-send-email-ivan.khoronzhuk@ti.com>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Ovh-Tracer-Id: 18230852767981611834
X-Ovh-Remote: 91.121.171.124 (ns203013.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrjedvucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.515953/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrjedvucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +				the chip select signal.
> +				Minimum value is 1 (0 treated as 1).
> +
> +- ti,cs-wsetup:		write setup width, ns
> +				Time between the beginning of a memory cycle
> +				and the activation of write strobe.
> +				Minimum value is 1 (0 treated as 1).
> +
> +- ti,cs-wstrobe:	write strobe width, ns
> +				Time between the activation and deactivation of
> +				the write strobe.
> +				Minimum value is 1 (0 treated as 1).
> +
> +- ti,cs-whold:		write hold width, ns
> +				Time between the deactivation of the write
> +				strobe and the end of the cycle (which may be
> +				either an address change or the deactivation of
> +				the chip select signal.
> +				Minimum value is 1 (0 treated as 1).
> +
> +If any of the above parameters are absent, current parameter value will be taken
> +from the corresponding HW reg.
> +
> +The name for cs node must be in format csN, where N is the cs number.

this is wired we should use reg instead to represent the cs as done for SPI
or a an other property

Best Regards,
J.
