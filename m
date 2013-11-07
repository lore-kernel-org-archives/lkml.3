Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754734Ab3KGH1T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 02:27:19 -0500
Received: from li42-95.members.linode.com ([209.123.162.95]:46858 "EHLO
	li42-95.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753225Ab3KGH1M convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 02:27:12 -0500
Subject: Re: [PATCH 0/3 - V2] Introducing Device Tree Overlays
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
From: Pantelis Antoniou <panto@antoniou-consulting.com>
In-Reply-To: <20131106211754.GA29300@roeck-us.net>
Date: Thu, 7 Nov 2013 09:27:06 +0200
Cc: Sebastian Andrzej Siewior <bigeasy@breakpoint.cc>,
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
Message-Id: <D7FC4B45-D6EC-4294-B0B4-58546CC9DA49@antoniou-consulting.com>
References: <1383676898-29819-1-git-send-email-panto@antoniou-consulting.com> <20131106190152.GA8662@breakpoint.cc> <20131106193041.GA26796@roeck-us.net> <20131106203821.GC8662@breakpoint.cc> <20131106211754.GA29300@roeck-us.net>
To: Guenter Roeck <linux@roeck-us.net>
X-Mailer: Apple Mail (2.1085)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guenter,

On Nov 6, 2013, at 11:17 PM, Guenter Roeck wrote:

> On Wed, Nov 06, 2013 at 09:38:21PM +0100, Sebastian Andrzej Siewior wrote:
>> On 06.11.13, Guenter Roeck wrote:
>>> At least that is our use case. u-boot doesn't know which cards are going to be
>>> inserted at runtime. Even PCIe hotplug itself is insufficient, as the PCIe
>>> configuration differs per card, and the cards support a variety of i2c devices
>>> as well as other card specific devices such LEDs and multi-function FPGAs.
>> 
>> So you have your FPGA behind PCIe and you use the DT to describe the
>> chips behind i2c? And then you update your FPGA and want update the
>> devices in DT without reboot?
>> 
> No.
> 
> We have a variety of boards ...
[snip]

TL;DR the real world...

> 
> We use DT overlays to describe the hardware on those boards and, if necessary,
> its configuration. For example, if there is a PCIe switch, the overlay would
> describe its memory and bus number configuration.
> 
> Guenter

Glad it's been useful...

Regards

-- Pantelis