Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934371Ab3BTQj3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 11:39:29 -0500
Received: from mail-wi0-f177.google.com ([209.85.212.177]:64851 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933961Ab3BTQjG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 11:39:06 -0500
Date: Wed, 20 Feb 2013 16:38:56 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        sameo@linux.intel.com, arnd@arndb.de, linus.walleij@stericsson.com,
        Jonas Aaberg <jonas.aberg@stericsson.com>
Subject: Re: [PATCH 02/35] mfd: ab8500-gpadc: Allow tvout regulator to be
 missing
Message-ID: <20130220163856.GC4417@gmail.com>
References: <1360933026-30325-1-git-send-email-lee.jones@linaro.org>
 <1360933026-30325-3-git-send-email-lee.jones@linaro.org>
 <20130220132321.GC13049@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130220132321.GC13049@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Feb 2013, Mark Brown wrote:

> On Fri, Feb 15, 2013 at 12:56:33PM +0000, Lee Jones wrote:
> 
> > +	if (gpadc->regu)
> > +		regulator_disable(gpadc->regu);
> 
> No explanation for this in the changelog and missing error handling like
> this is pretty much always terrible style.  Why are we doing this?

No idea, and Jonas is on parental leave.

Perhaps one of the other guys have an explanation?

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
