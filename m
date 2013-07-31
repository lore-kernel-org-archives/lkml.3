Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760060Ab3GaOII (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 10:08:08 -0400
Received: from mail-yh0-f45.google.com ([209.85.213.45]:60702 "EHLO
	mail-yh0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759996Ab3GaOID (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 10:08:03 -0400
Date: Wed, 31 Jul 2013 10:07:58 -0400
From: Tejun Heo <htejun@gmail.com>
To: Mark Brown <broonie@kernel.org>
Cc: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Peter Chen <peter.chen@freescale.com>,
        Fabio Estevam <festevam@gmail.com>, alexander.shishkin@linux.intel.com,
        kernel@pengutronix.de, linux-usb@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Jeff Garzik <jeff@garzik.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Mike Turquette <mturquette@linaro.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/2] chipidea: Use devm_request_irq()
Message-ID: <20130731140758.GT2810@htj.dyndns.org>
References: <20130731090512.GD9858@sirena.org.uk>
 <20130731094434.GC1754@pengutronix.de>
 <20130731095411.GA2810@htj.dyndns.org>
 <20130731111853.GJ9858@sirena.org.uk>
 <20130731113244.GI2810@htj.dyndns.org>
 <20130731115027.GN9858@sirena.org.uk>
 <20130731115527.GR2810@htj.dyndns.org>
 <20130731132708.GQ9858@sirena.org.uk>
 <20130731134215.GS2810@htj.dyndns.org>
 <20130731135751.GT9858@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130731135751.GT9858@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 31, 2013 at 02:57:51PM +0100, Mark Brown wrote:
> That's the only API I've ever heard of doing that.  Everything else is
> just using it to do deallocation.

I'm not sure why or what you're trying to argue here but take a look
at devm_pwm_release() for example.  It calls back into low level
driver free routine.  Are you arguing that it'd be a good idea to
release pci regions before this is complete?  It's just stupid to do
any differently.  There's nothing to argue about.

-- 
tejun
