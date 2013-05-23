Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759473Ab3EWOpE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 10:45:04 -0400
Received: from mail-wg0-f53.google.com ([74.125.82.53]:38720 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758002Ab3EWOpC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 10:45:02 -0400
Date: Thu, 23 May 2013 15:44:53 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Mark Brown <broonie@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@linaro.org, arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com
Subject: Re: [PATCH] regulator: ab8500-ext: Don't register without
 initialisation data
Message-ID: <20130523144453.GL22683@gmail.com>
References: <1369226853-16978-1-git-send-email-lee.jones@linaro.org>
 <1369226853-16978-3-git-send-email-lee.jones@linaro.org>
 <20130522155347.GJ1627@sirena.org.uk>
 <20130522165353.GB18714@gmail.com>
 <20130522174516.GT1627@sirena.org.uk>
 <20130523070905.GD18714@gmail.com>
 <20130523142419.GG2412@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130523142419.GG2412@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 May 2013, Mark Brown wrote:

> On Thu, May 23, 2013 at 08:09:05AM +0100, Lee Jones wrote:
> > On Wed, 22 May 2013, Mark Brown wrote:
> 
> > > OK, so the regulator driver is buggy and insisting on having constraints
> > > passed in for every regulator then?
> 
> > If that's not how it's meant to work then, yes.
> 
> Yes, that's the intention - it should be possible to just not pass in
> anything in and have the driver start up in read only mode (partly to
> save having to do things like what you're doing).

Okay, noted.

Well, whatever happens I'm going to be able to refactor the driver in
the -rc:s, so we still need this fix, or the world will end.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
