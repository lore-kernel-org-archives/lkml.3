Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753084AbaBCOhL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 09:37:11 -0500
Received: from mail-ee0-f49.google.com ([74.125.83.49]:62765 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753047AbaBCOhG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 09:37:06 -0500
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH v2] of: make of_get_phy_mode parse 'phy-connection-type'
To: Florian Fainelli <f.fainelli@gmail.com>
Cc: rob.herring@calxeda.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <52E47B51.3030308@gmail.com>
References: <20131114074711.9A8C5C402E1@trevor.secretlab.ca> < 1384496612-28392-1-git-send-email-f.fainelli@gmail.com> <20131116122451. 3F0B9C4038F@trevor.secretlab.ca> <52E47B51.3030308@gmail.com>
Date: Mon, 03 Feb 2014 14:37:02 +0000
Message-Id: <20140203143702.14B27C40619@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 25 Jan 2014 19:04:49 -0800, Florian Fainelli <f.fainelli@gmail.com> wrote:
> Le 16/11/2013 04:24, Grant Likely a écrit :
> > On Fri, 15 Nov 2013 06:23:32 +0000, Florian Fainelli <f.fainelli@gmail.com> wrote:
> >> Per the ePAPR v1.1 specification, 'phy-connection-type' is the canonical
> >> property name for describing an Ethernet to PHY connection type. Make
> >> sure that of_get_phy_mode() also attempts to parse that property and
> >> update the comments mentioning 'phy-mode' to also include
> >> 'phy-connection-type'.
> >>
> >> Acked-by: Grant Likely <grant.likely@linaro.org>
> >> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> >
> > Applied, thanks
> 
> Grant, where is that patch, and will it be part of a pull request to 3.14?

I accidentally dropped it for v3.14. It will be in 3.15

g.
