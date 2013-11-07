Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754612Ab3KGUGr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 15:06:47 -0500
Received: from li42-95.members.linode.com ([209.123.162.95]:40612 "EHLO
	li42-95.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752191Ab3KGUGk convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 15:06:40 -0500
Subject: Re: [PATCH 0/3 - V2] Introducing Device Tree Overlays
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=windows-1252
From: Pantelis Antoniou <panto@antoniou-consulting.com>
In-Reply-To: <20131107192558.GA11453@breakpoint.cc>
Date: Thu, 7 Nov 2013 22:06:31 +0200
Cc: Guenter Roeck <linux@roeck-us.net>,
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
Content-Transfer-Encoding: 8BIT
Message-Id: <4F47D5F8-F3C7-45CA-9D88-2D814BDC1BC7@antoniou-consulting.com>
References: <1383676898-29819-1-git-send-email-panto@antoniou-consulting.com> <20131106190152.GA8662@breakpoint.cc> <20131106193041.GA26796@roeck-us.net> <20131106203821.GC8662@breakpoint.cc> <20131106211754.GA29300@roeck-us.net> <20131107192558.GA11453@breakpoint.cc>
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
X-Mailer: Apple Mail (2.1085)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sebastian,

On Nov 7, 2013, at 9:25 PM, Sebastian Andrzej Siewior wrote:

> On 06.11.13, Guenter Roeck wrote:
> |…
> thanks for the explanation.
> 
>> We use DT overlays to describe the hardware on those boards and, if necessary,
>> its configuration. For example, if there is a PCIe switch, the overlay would
>> describe its memory and bus number configuration.
> 
> So have your "fix" configuration and a few overlays you switch at
> runtime. The problem you have is that you want to switch a specific part
> if your configuration at runtime. I assume you run DT on ARM. What
> happens if you swtich from ARM to x86 and you "keep" your FPGA
> configuration requirement? You can't use both, DT and ACPI, right? So
> what happens then?
> 

FWIW DT has been ported to x86. And is present on arm/powerpc/mips/arc and possibly
others.

So what are we talking about again? If you care about the non-DT case, why
don't you make a patch about how you could support Guenter's use case on
the x86.

His use case is not uncommon, believe it or not, and x86 would benefit from
something this flexible.

>> 
>> Guenter
> 
> Sebastian

Regards

-- Pantelis