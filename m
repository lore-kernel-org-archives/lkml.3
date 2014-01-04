Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754304AbaADACV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 19:02:21 -0500
Received: from mail-pd0-f175.google.com ([209.85.192.175]:43382 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753866AbaADACU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 19:02:20 -0500
Date: Fri, 3 Jan 2014 16:02:13 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Mark Brown <broonie@kernel.org>
Cc: Fabio Estevam <festevam@gmail.com>, shawn.guo@linaro.org,
        Anson.Huang@freescale.com, linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: Re: [PATCH v3 1/2] regulator: anatop-regulator: Fix the error
 handling on probe
Message-ID: <20140104000213.GA23926@core.coreip.homeip.net>
References: <1387809881-16092-1-git-send-email-festevam@gmail.com>
 <20131224130357.GD30815@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131224130357.GD30815@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 24, 2013 at 01:03:57PM +0000, Mark Brown wrote:
> On Mon, Dec 23, 2013 at 12:44:40PM -0200, Fabio Estevam wrote:
> > From: Fabio Estevam <fabio.estevam@freescale.com>
> > 
> > Currently when of_get_parent() or syscon_node_to_regmap() fail 
> > 'kfree(sreg->name)' is not called, which is incorrect.
> 
> Applied both, thanks.

Sorry for being too later, but why are we making copy to begin with? It
is not like DT data will disappear later on.

Thanks.

-- 
Dmitry
