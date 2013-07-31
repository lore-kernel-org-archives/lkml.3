Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760426Ab3GaP3m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 11:29:42 -0400
Received: from mail-ye0-f175.google.com ([209.85.213.175]:51935 "EHLO
	mail-ye0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759951Ab3GaP3k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 11:29:40 -0400
Date: Wed, 31 Jul 2013 11:29:32 -0400
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
Message-ID: <20130731152932.GV2810@htj.dyndns.org>
References: <20130731095411.GA2810@htj.dyndns.org>
 <20130731111853.GJ9858@sirena.org.uk>
 <20130731113244.GI2810@htj.dyndns.org>
 <20130731115027.GN9858@sirena.org.uk>
 <20130731115527.GR2810@htj.dyndns.org>
 <20130731132708.GQ9858@sirena.org.uk>
 <20130731134215.GS2810@htj.dyndns.org>
 <20130731135751.GT9858@sirena.org.uk>
 <20130731140758.GT2810@htj.dyndns.org>
 <20130731152523.GW9858@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130731152523.GW9858@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 31, 2013 at 04:25:23PM +0100, Mark Brown wrote:
> What I'm saying is that in essentially all the users I've seen devm is
> only being used for things like kfree() or clk_put() which aren't really
> connected in any way and can happen in any order.  This (coupled with
> the lack of documentation that this is supported) is why people are
> nervous about anything that relies on ordering with this stuff - aside
> from ATA everything is just using this for straight frees.

Yeah, sure, thank you very much for your input.  It is of course
strictly ordered and the documentation needs to be updated.

-- 
tejun
