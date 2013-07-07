Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753084Ab3GGS3Y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jul 2013 14:29:24 -0400
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:60061 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752427Ab3GGS3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jul 2013 14:29:21 -0400
Date: Sun, 7 Jul 2013 20:29:11 +0200
From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: linux-next: build warning after merge of the mfd tree
Message-ID: <20130707182911.GA1799@breakpoint.cc>
References: <20130703155655.9fbacfa867af35fd743099e2@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130703155655.9fbacfa867af35fd743099e2@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 03, 2013 at 03:56:55PM +1000, Stephen Rothwell wrote:
> Hi Samuel,
Hi Stephen,

> Introduced by commit 18926edebcb8 ("iio: ti_am335x_adc: Allow to specify
> input line").  CONFIG_OF is not set in this build.
> 
> Maybe someone could come up with a way to make these arguments to
> of_property_for_each_u32() etc look used in the !CONFIG_OF case.

Already posted:

  https://lists.ozlabs.org/pipermail/devicetree-discuss/2013-June/035703.html

Sebastian
