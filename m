Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754644Ab3H1TMi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 15:12:38 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:37848 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754223Ab3H1TMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 15:12:35 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: merging device tree binding dirs for serial bindings
To: Kumar Gala <galak@codeaurora.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devicetree@vger.kernel.org,
        "linux-kernel@vger.kernel.org list" <linux-kernel@vger.kernel.org>,
        linux-serial@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>,
        "shawn.guo@linaro.org Guo" <shawn.guo@linaro.org>,
        "s.hauer@pengutronix.de Hauer" <s.hauer@pengutronix.de>
In-Reply-To: <0F60E12D-C0BF-4185-85FF-0BC879B3C1F0@codeaurora.org>
References: <F93329E6-1426-4197-871D-211F34455DDE@codeaurora.org> <20130828183534.GC14627@kroah.com> <0F60E12D-C0BF-4185-85FF-0BC879B3C1F0@codeaurora.org>
Date: Wed, 28 Aug 2013 20:12:37 +0100
Message-Id: <20130828191237.123F83E04C7@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Aug 2013 13:49:13 -0500, Kumar Gala <galak@codeaurora.org> wrote:
> 
> On Aug 28, 2013, at 1:35 PM, Greg Kroah-Hartman wrote:
> 
> > On Wed, Aug 28, 2013 at 01:02:14PM -0500, Kumar Gala wrote:
> >> We appear to have:
> >> 
> >> Documentation/devicetree/bindings/serial/
> >> 
> >> and
> >> 
> >> Documentation/devicetree/bindings/tty/serial/
> >> 
> >> Which one do we want to keep, I'd pick the first, but I don't care too much.
> > 
> > I don't care, I never created either one, and don't do any devicetree
> > stuff, so it's up to the devicetree maintainers to pick one.
> > 
> > thanks,
> > 
> > greg k-h
> 
> Since you don't care we'll go with bindings/serial.
> 
> I'll send a patch to merge and clean this up.

Sounds good to me.

g.

