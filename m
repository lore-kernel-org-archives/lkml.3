Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935436Ab3BTNX1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 08:23:27 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:52904 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934923Ab3BTNX0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 08:23:26 -0500
Date: Wed, 20 Feb 2013 13:23:21 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        sameo@linux.intel.com, arnd@arndb.de, linus.walleij@stericsson.com,
        Jonas Aaberg <jonas.aberg@stericsson.com>
Subject: Re: [PATCH 02/35] mfd: ab8500-gpadc: Allow tvout regulator to be
 missing
Message-ID: <20130220132321.GC13049@sirena.org.uk>
References: <1360933026-30325-1-git-send-email-lee.jones@linaro.org>
 <1360933026-30325-3-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360933026-30325-3-git-send-email-lee.jones@linaro.org>
X-Cookie: That's what she said.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 15, 2013 at 12:56:33PM +0000, Lee Jones wrote:

> +	if (gpadc->regu)
> +		regulator_disable(gpadc->regu);

No explanation for this in the changelog and missing error handling like
this is pretty much always terrible style.  Why are we doing this?
