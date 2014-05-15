Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755688AbaEOTVI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 15:21:08 -0400
Received: from filtteri1.pp.htv.fi ([213.243.153.184]:50452 "EHLO
	filtteri1.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751401AbaEOTVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 15:21:05 -0400
Date: Thu, 15 May 2014 22:16:31 +0300
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: Sebastian Reichel <sre@kernel.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Dmitry Torokhov <dtor@mail.ru>, linux-input@vger.kernel.org,
        Tony Lindgren <tony@atomide.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3 0/5] tsc2005 DT binding
Message-ID: <20140515191631.GA4752@drone.musicnaut.iki.fi>
References: <1398470179-20880-1-git-send-email-sre@kernel.org>
 <20140515142315.GA15716@earth.universe>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140515142315.GA15716@earth.universe>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, May 15, 2014 at 04:23:16PM +0200, Sebastian Reichel wrote:
> On Sat, Apr 26, 2014 at 01:56:14AM +0200, Sebastian Reichel wrote:
> > This adds device tree support for the tsc2005 touchscreen
> > controller, which is currently only used by the Nokia N900
> > board.
> > 
> > The patch does not update the reset pin handling for platform
> > data based probe to avoid merge conflicts. The n900 platform
> > code will be removed in the near future (3.16?) and the driver
> > can be simplified once that has happened.
> 
> Ping. It would be nice to see this patchset in 3.16, since its
> the last important hardware component missing for N900 DT boot.

FWIW, for all these patches feel free to add:

	Acked-by: Aaro Koskinen <aaro.koskinen@iki.fi>

Thanks for great work,

A.
