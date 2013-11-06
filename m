Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755489Ab3KFTar (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 14:30:47 -0500
Received: from mail-pb0-f54.google.com ([209.85.160.54]:46727 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754582Ab3KFTap (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 14:30:45 -0500
Date: Wed, 6 Nov 2013 11:30:41 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Sebastian Andrzej Siewior <bigeasy@breakpoint.cc>
Cc: Pantelis Antoniou <panto@antoniou-consulting.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <robherring2@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Matt Porter <matt.porter@linaro.org>,
        Koen Kooi <koen@dominion.thruhere.net>,
        Alison Chaiken <Alison_Chaiken@mentor.com>,
        Dinh Nguyen <dinh.linux@gmail.com>, Jan Lubbe <jluebbe@lasnet.de>,
        Alexander Sverdlin <alexander.sverdlin@nsn.com>,
        Michael Stickel <ms@mycable.de>, Dirk Behme <dirk.behme@gmail.com>,
        Alan Tull <delicious.quinoa@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Michael Bohan <mbohan@codeaurora.org>,
        Ionut Nicu <ioan.nicu.ext@nsn.com>, Michal Simek <monstr@monstr.eu>,
        Matt Ranostay <mranostay@gmail.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3 - V2] Introducing Device Tree Overlays
Message-ID: <20131106193041.GA26796@roeck-us.net>
References: <1383676898-29819-1-git-send-email-panto@antoniou-consulting.com>
 <20131106190152.GA8662@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131106190152.GA8662@breakpoint.cc>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 06, 2013 at 08:01:52PM +0100, Sebastian Andrzej Siewior wrote:
> On 05.11.13, Pantelis Antoniou wrote:
> > The following patchset introduces Device Tree overlays, a method
> > of dynamically altering the kernel's live Device Tree, along with
> > a generic interface to use it in a board agnostic manner.
> 
> In case this has been discussed and I missed it: Why are we doing this?
> Isn't it possible to d o the overlay thingy in u-boot and pass a
> complete device tree to the kernel?
> Are you trying to do something like hotplug-PCI where the PCI card can
> be replaced at runtime?
> 

At least that is our use case. u-boot doesn't know which cards are going to be
inserted at runtime. Even PCIe hotplug itself is insufficient, as the PCIe
configuration differs per card, and the cards support a variety of i2c devices
as well as other card specific devices such LEDs and multi-function FPGAs.

Guenter
