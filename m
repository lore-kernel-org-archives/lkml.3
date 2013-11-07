Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755910Ab3KGWvk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 17:51:40 -0500
Received: from mail-pd0-f171.google.com ([209.85.192.171]:42697 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755794Ab3KGWvd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 17:51:33 -0500
Date: Thu, 7 Nov 2013 14:51:30 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Pantelis Antoniou <panto@antoniou-consulting.com>
Cc: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
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
Message-ID: <20131107225130.GB24450@roeck-us.net>
References: <1383676898-29819-1-git-send-email-panto@antoniou-consulting.com>
 <20131106190152.GA8662@breakpoint.cc>
 <20131106193041.GA26796@roeck-us.net>
 <20131106203821.GC8662@breakpoint.cc>
 <20131106211754.GA29300@roeck-us.net>
 <20131107192558.GA11453@breakpoint.cc>
 <4F47D5F8-F3C7-45CA-9D88-2D814BDC1BC7@antoniou-consulting.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4F47D5F8-F3C7-45CA-9D88-2D814BDC1BC7@antoniou-consulting.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 07, 2013 at 10:06:31PM +0200, Pantelis Antoniou wrote:
> Hi Sebastian,
> 
> On Nov 7, 2013, at 9:25 PM, Sebastian Andrzej Siewior wrote:
> 
> > On 06.11.13, Guenter Roeck wrote:
> > |…
> > thanks for the explanation.
> > 
> >> We use DT overlays to describe the hardware on those boards and, if necessary,
> >> its configuration. For example, if there is a PCIe switch, the overlay would
> >> describe its memory and bus number configuration.
> > 
> > So have your "fix" configuration and a few overlays you switch at
> > runtime. The problem you have is that you want to switch a specific part
> > if your configuration at runtime. I assume you run DT on ARM. What

powerpc

> > happens if you swtich from ARM to x86 and you "keep" your FPGA
> > configuration requirement? You can't use both, DT and ACPI, right? So
> > what happens then?
> > 
> 
> FWIW DT has been ported to x86. And is present on arm/powerpc/mips/arc and possibly
> others.
> 
> So what are we talking about again? If you care about the non-DT case, why
> don't you make a patch about how you could support Guenter's use case on
> the x86.
> 
> His use case is not uncommon, believe it or not, and x86 would benefit from
> something this flexible.
> 
Together with the work Thierry has done a couple of years ago, using DT
to augment ACPI data on x86 platforms, I don't really see a major problem
with using DT overlays on x86. Sure, it will require some work, and the
resulting patches may not be accepted for upstream integration,
but the concept is already there, and we plan to make good use of it.

Guenter
