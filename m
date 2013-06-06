Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751864Ab3FFQSi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 12:18:38 -0400
Received: from 8.mo5.mail-out.ovh.net ([178.32.116.78]:44535 "EHLO
	mo5.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750910Ab3FFQSh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 12:18:37 -0400
Date: Thu, 6 Jun 2013 18:14:21 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, manabian@gmail.com,
        linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux@dominikbrodowski.net, fabio.porcedda@gmail.com,
        Andrew Morton <akpm@linux-foundation.org>, laurent.navet@gmail.com,
        linux-arm-kernel@lists.infradead.org
X-Ovh-Mailout: 178.32.228.5 (mo5.mail-out.ovh.net)
Subject: Re: [PATCH v3 0/7] pcmcia: at91_cf: clean up and add DT support
Message-ID: <20130606161421.GM23653@game.jcrosoft.org>
References: <cover.1370506678.git.nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1370506678.git.nicolas.ferre@atmel.com>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 13136718639938579308
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiiedrfeejucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiiedrfeejucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10:24 Thu 06 Jun     , Nicolas Ferre wrote:
> These patches clean up at91_cf a bit and add DT bindings.
> They are based on a previous series from Joachim Eastwood and other cleanup
> patches by Fabio and Laurent.
> I have collected them together as they are lying around for some time.
> 
> Greg kindly told me that he can take them through his char/misc driver
> tree, so I resend the series.
> 
> Thanks for your help, best regards.
> 
> v3: rebased on top of 3.10-rc4
> 
> v2: add 2 more cleanup patches:
> 	- move to module_platform_driver_probe()
> 	- little trivial indentation fix
on all Acked-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>

Best Regards,
J.
> 
> Fabio Porcedda (1):
>   pcmcia: at91_cf: use module_platform_driver_probe()
> 
> Joachim Eastwood (5):
>   pcmcia: at91_cf: fix gpio_get_value in at91_cf_get_status
>   pcmcia: at91_cf: convert to dev_ print functions
>   pcmcia: at91_cf: use devm_ functions for allocations
>   pcmcia: at91_cf: clean up header includes
>   pcmcia: at91_cf: add support for DT
> 
> Laurent Navet (1):
>   pcmcia/trivial: at91_cf: fix checkpatch error
> 
>  .../devicetree/bindings/ata/atmel-at91_cf.txt      |  19 +++
>  drivers/pcmcia/Kconfig                             |   2 +-
>  drivers/pcmcia/at91_cf.c                           | 176 ++++++++++-----------
>  3 files changed, 108 insertions(+), 89 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/ata/atmel-at91_cf.txt
> 
> -- 
> 1.8.2.2
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
