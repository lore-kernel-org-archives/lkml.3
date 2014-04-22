Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757346AbaDVQJn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 12:09:43 -0400
Received: from smtp.adetelgroup.com ([94.247.26.71]:32035 "EHLO
	hbg-pa71.hmc-pa.adm" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757327AbaDVQJj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 12:09:39 -0400
Message-ID: <1398182952.1593.20.camel@EMBLYSD005.adetelgroup.com>
Subject: Re: [PATCH] ARM: i.MX6: Add OF configuration support for ksz9031
From: Hubert Chaumette <hchaumette@adeneo-embedded.com>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: linux-kernel@vger.kernel.org, kernel@pengutronix.de,
        linux@arm.linux.org.uk, f.fainelli@gmail.com,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        agust@denx.de
Date: Tue, 22 Apr 2014 18:09:12 +0200
In-Reply-To: <20140416080322.GA11602@dragon>
References: <1397466496-24750-1-git-send-email-hchaumette@adeneo-embedded.com>
	 <20140416080322.GA11602@dragon>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b3 
Mime-Version: 1.0
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 16 avril 2014 à 16:03 +0800, Shawn Guo a écrit :
> On Mon, Apr 14, 2014 at 11:08:16AM +0200, Hubert Chaumette wrote:
> > - Adds support for ksz9031 PAD skew configuration over devicetree
> > - Removes hard-coded pad skew configuration for imx6q-sabrelite, now redundant
> >   with arch/arm/boot/dts/imx6qdl-sabrelite.dtsi
> > 
> > Tested on congatec conga-QEVAL board with conga-QMX6 module.
> > 
> > This patch is based on Anatolij Gustschin's patch from
> > http://www.spinics.net/lists/arm-kernel/msg319771.html
> > 
> > Signed-off-by: Hubert Chaumette <hchaumette@adeneo-embedded.com>
> > ---
> >  arch/arm/mach-imx/mach-imx6q.c |  45 ----------
> >  drivers/net/phy/micrel.c       | 185 ++++++++++++++++++++++++++++++++++++++++-
> 
> You should probably leave mach-imx6q.c unchanged, because dropping the
> phy fix-up from there may break old DTBs.  And the changes on micrel.c
> should be submitted to net maintainer.
> 
> Shawn

I've re-sent it without the changes to mach-imx6q.c. Thanks for your
review.

Regards,
Hubert

