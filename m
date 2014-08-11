Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751621AbaHKI2c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 04:28:32 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:63877 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720AbaHKI2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 04:28:31 -0400
Date: Mon, 11 Aug 2014 09:28:26 +0100
From: Peter Griffin <peter.griffin@linaro.org>
To: Simon Horman <horms@verge.net.au>
Cc: Christian Kujau <lists@nerdbynature.de>,
        LKML <linux-kernel@vger.kernel.org>, Tomasz Figa <t.figa@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Magnus Damm <magnus.damm@gmail.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sangbeom Kim <sbkim73@samsung.com>,
        Cesar Eduardo Barros <cesarb@cesarb.eti.br>
Subject: Re: [PATCH] remove non-existent files from MAINTAINERS
Message-ID: <20140811082826.GA9534@griffinp-ThinkPad-X1-Carbon-2nd>
References: <alpine.DEB.2.19.4.1408092332350.2758@trent.utfs.org>
 <20140811005140.GF26570@verge.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140811005140.GF26570@verge.net.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> >     * drivers/mmc/host/sdhci-st.c
> > 
> >       This one was sent to be included in June 2014 but got dropped shortly after:
> >       "mmc: sdhci-st: Intial support for ST SDHCI controller"
> >       https://lkml.org/lkml/2014/6/4/446
> >       https://lkml.org/lkml/2014/7/9/340

NAK.

This only got dropped temporarily, the V4 series got applied by Ulf the next day, see here: -
http://lists.infradead.org/pipermail/linux-arm-kernel/2014-July/271183.html.

I think the file is currently missing because Ulf hasn't sent his pull request yet, but 
the patches *are* still in his 'next' branch here 
https://git.linaro.org/people/ulf.hansson/mmc.git/shortlog/refs/heads/next.

The patch for MAINTAINERS went via Maxime the arch maintainer, so come 3.17-rc1 the file
should be there.

regards,

Peter.
