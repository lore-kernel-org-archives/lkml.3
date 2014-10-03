Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751908AbaJCLqO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 07:46:14 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:58778 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751266AbaJCLqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 07:46:11 -0400
Date: Fri, 3 Oct 2014 13:46:03 +0200 (CEST)
From: Stefan Wahren <stefan.wahren@i2se.com>
Reply-To: Stefan Wahren <stefan.wahren@i2se.com>
To: Mark Rutland <mark.rutland@arm.com>, festevam@gmail.com
Cc: "kernel@pengutronix.de" <kernel@pengutronix.de>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "broonie@kernel.org" <broonie@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Message-ID: <20237989.191677.1412336763673.JavaMail.open-xchange@oxbaltgw03.schlund.de>
In-Reply-To: <20140929132334.GE2432@leverpostej>
References: <1411779588-22031-1-git-send-email-stefan.wahren@i2se.com> <1411779588-22031-2-git-send-email-stefan.wahren@i2se.com> <20140929110919.GB2432@leverpostej> <54294832.8000702@i2se.com> <20140929124137.GD2432@leverpostej> <54295A2F.3070700@i2se.com> <20140929132334.GE2432@leverpostej>
Subject: Re: [PATCH 1/2] DT: add binding for mxs regulator
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Priority: 3
Importance: Medium
X-Mailer: Open-Xchange Mailer v7.6.0-Rev19
X-Originating-Client: com.openexchange.ox.gui.dhtml
X-Provags-ID: V02:K0:AntQyUDkJgDwnCso/prW0IFegDNYHvHKfGSxNc//1Lj
 Q0kov3hiiU/17vomh/mL42FiYTY1mkuOeLwdtgHwy+81DmSVlA
 u/f+jXGpTxXPFhmDiTg/4eUDmBaLQwrU/r8kmUrngZ+0/MERui
 R89tSO6AfzR5yLA5muTRNCcYMRUxB8VyQs5SOE+Z0DHXNVUPCZ
 T4F7xYXVAXG64sHA3bnfsF1IPzhHEG4HNaFB+mIc0+p1jjAw5c
 uu8uDn6j5+TcJtypo8Ky9pDMGw3Vbj6Hx/2UawOi0uj2cJfOQz
 b/hTM7mLhEyaeRWdLYBrB+qmmzW+4HTSg6tfRNDho15ViVVNt3
 T1ledNrZDkyXnNAqAG0JE1XZV67UDqHHJFdcKtsbAjqwjuBZRd
 gvsXzHPsjd9Z5P3bf/powWk7Bec3vM5i/arXFfA3Ej3HrD+ZNA
 Iys4m
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,
hi Fabio,

> Mark Rutland <mark.rutland@arm.com> hat am 29. September 2014 um 15:23
> geschrieben:
>
> I would prefer a top level node for the subsystem that is not a
> simple-bus.
>
> Give it a compatible string and a well-defined set of base properties
> (looks like you just need the reg for now). Match that and probe the
> child nodes as appropriate.
>
> > >> Do we need a extra driver?
> > > Perhaps, but it's relatively simple to match on a compatible string and
> > > probe children if you just wantto start small for now.
>
> Mark.

i would name the driver for the power subsystem "mxs_power.c" and use the
compatibel string "fsl,imx28-power" for i.MX28.

Now the question: where should i take?

arch/arm/mach-mxs/ or drivers/power/

Regards

Stefan
