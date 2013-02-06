Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758256Ab3BFXQp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 18:16:45 -0500
Received: from utopia.booyaka.com ([74.50.51.50]:38731 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755163Ab3BFXQn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 18:16:43 -0500
Date: Wed, 6 Feb 2013 23:16:42 +0000 (UTC)
From: Paul Walmsley <paul@pwsan.com>
To: Wim Van Sebroeck <wim@iguana.be>
cc: Aaro Koskinen <aaro.koskinen@iki.fi>, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
Subject: Re: [PATCH v5] watchdog: introduce retu_wdt driver
In-Reply-To: <20130128151223.GH23053@blackmetal.musicnaut.iki.fi>
Message-ID: <alpine.DEB.2.00.1302062315321.12769@utopia.booyaka.com>
References: <1356641909-8598-1-git-send-email-aaro.koskinen@iki.fi> <20130128151223.GH23053@blackmetal.musicnaut.iki.fi>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wim,

On Mon, 28 Jan 2013, Aaro Koskinen wrote:

> On Thu, Dec 27, 2012 at 10:58:29PM +0200, Aaro Koskinen wrote:
> > Introduce Retu watchdog driver.
> 
> Wim, any comments about this driver? Do you think it could be queued
> for 3.9?

It'd be really great if this could go in for v3.9.  Without it, Nokia N800 
boards crash shortly after boot because the Retu watchdog isn't being 
tickled :-(


- Paul
