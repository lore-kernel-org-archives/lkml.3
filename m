Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756229Ab3KFUid (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 15:38:33 -0500
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:54077 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755168Ab3KFUic (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 15:38:32 -0500
Date: Wed, 6 Nov 2013 21:38:21 +0100
From: Sebastian Andrzej Siewior <bigeasy@breakpoint.cc>
To: Guenter Roeck <linux@roeck-us.net>
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
Message-ID: <20131106203821.GC8662@breakpoint.cc>
References: <1383676898-29819-1-git-send-email-panto@antoniou-consulting.com>
 <20131106190152.GA8662@breakpoint.cc>
 <20131106193041.GA26796@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131106193041.GA26796@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06.11.13, Guenter Roeck wrote:
> At least that is our use case. u-boot doesn't know which cards are going to be
> inserted at runtime. Even PCIe hotplug itself is insufficient, as the PCIe
> configuration differs per card, and the cards support a variety of i2c devices
> as well as other card specific devices such LEDs and multi-function FPGAs.

So you have your FPGA behind PCIe and you use the DT to describe the
chips behind i2c? And then you update your FPGA and want update the
devices in DT without reboot?

> 
> Guenter

Sebastian
