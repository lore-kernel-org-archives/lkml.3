Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753905Ab3KGT0Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 14:26:25 -0500
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:57653 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751743Ab3KGT0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 14:26:17 -0500
Date: Thu, 7 Nov 2013 20:25:58 +0100
From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
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
Message-ID: <20131107192558.GA11453@breakpoint.cc>
References: <1383676898-29819-1-git-send-email-panto@antoniou-consulting.com>
 <20131106190152.GA8662@breakpoint.cc>
 <20131106193041.GA26796@roeck-us.net>
 <20131106203821.GC8662@breakpoint.cc>
 <20131106211754.GA29300@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20131106211754.GA29300@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06.11.13, Guenter Roeck wrote:
|…
thanks for the explanation.

> We use DT overlays to describe the hardware on those boards and, if necessary,
> its configuration. For example, if there is a PCIe switch, the overlay would
> describe its memory and bus number configuration.

So have your "fix" configuration and a few overlays you switch at
runtime. The problem you have is that you want to switch a specific part
if your configuration at runtime. I assume you run DT on ARM. What
happens if you swtich from ARM to x86 and you "keep" your FPGA
configuration requirement? You can't use both, DT and ACPI, right? So
what happens then?

> 
> Guenter

Sebastian
