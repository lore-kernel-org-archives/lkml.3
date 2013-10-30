Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754356Ab3J3NxM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 09:53:12 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:57129 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752935Ab3J3NxJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 09:53:09 -0400
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCHv2 1/3] Input: twl4030-keypad - add device tree support
To: Pavel Machek <pavel@ucw.cz>, linux-input@vger.kernel.org,
        "'Beno?t Cousson'" <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org
In-Reply-To: <20131027114753.GB14901@amd.pavel.ucw.cz>
References: <1382446042-27099-1-git-send-email-sre@debian.org> <1382446042-27099-2-git-send-email-sre@debian.org> <20131027111715.GA2437@xo-6d-61-c0.localdomain> <20131027114026.GB14091@earth.universe> <20131027114753.GB14901@amd.pavel.ucw.cz>
Date: Wed, 30 Oct 2013 06:53:07 -0700
Message-Id: <20131030135307.D8CE1C402A0@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 27 Oct 2013 12:47:53 +0100, Pavel Machek <pavel@ucw.cz> wrote:
> > > > +#if IS_ENABLED(CONFIG_OF)
> > > I'm probably missing something here, but why not #ifdef CONFIG_OF?
> > 
> > I have been told for other drivers, that IS_ENABLED() is
> > the prefered way to check for configuration these days.
> 
> CONFIG_OF can not be module, using IS_ENABLED() on it is just wrong.

That makes no sense. There is absolutely nothing wrong with using
IS_ENABLED() for CONFIG_OF.

g.
