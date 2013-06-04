Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759997Ab3FDHVY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 03:21:24 -0400
Received: from mail-ea0-f171.google.com ([209.85.215.171]:60066 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759355Ab3FDHVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 03:21:21 -0400
Date: Tue, 4 Jun 2013 08:21:15 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: J Keerthy <j-keerthy@ti.com>, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        broonie@opensource.wolfsonmicro.com, rob.herring@calxeda.com,
        rob@landley.net, mturquette@linaro.org, sameo@linux.intel.com,
        wim@iguana.be, lgirdwood@gmail.com, gg@slimlogic.co.uk,
        t-kristo@ti.com, Ian Lartey <ian@slimlogic.co.uk>
Subject: Re: [PATCH] mfd: DT bindings for the palmas family MFD
Message-ID: <20130604072115.GI3370@gmail.com>
References: <1370261333-5121-1-git-send-email-j-keerthy@ti.com>
 <20130603141851.GG3370@gmail.com>
 <51ACFECA.10209@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <51ACFECA.10209@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 03 Jun 2013, Stephen Warren wrote:

> On 06/03/2013 08:18 AM, Lee Jones wrote:
> > On Mon, 03 Jun 2013, J Keerthy wrote:
> >> Add the various binding files for the palmas family of chips. There is a
> >> top level MFD binding then a seperate binding for regulators IP blocks on chips.
> 
> >> diff --git a/Documentation/devicetree/bindings/mfd/palmas.txt b/Documentation/devicetree/bindings/mfd/palmas.txt
> 
> >> +Example:
> >> +
> >> +palmas {
> > 
> > Should this be 'palmas@48 {', as it has an address?
> 
> It's common to only include the unit-address (@48) if it's needed to
> make the node name unique (i.e. if you had multiple palmas devices).

I was working on the basis of, if it has a 'reg' value, it should be
highlighted in the node name, but if this is the common way of doing
things then fair enough.

> >> diff --git a/Documentation/devicetree/bindings/regulator/palmas-pmic.txt b/Documentation/devicetree/bindings/regulator/palmas-pmic.txt
> 
> > See: Documentation/devicetree/bindings/regulator/gpio-regulator.txt
> > 
> >> +	       ti,sleep-mode - mode to adopt in pmic sleep 0 - off, 1 - auto,
> >> +	       2 - eco, 3 - forced pwm
> > 
> > I've seen lots of sleep-mode properties, can't we define a generic
> > one?
> 
> Isn't it HW-specific?

Yes, they're not all identical. I haven't studied them all in detail,
but I assumed a we would be able to do something in order to
consolidate them somewhat. If they are vastly different then no
problem, it was just an idea to cut down on vendor specific
properties. 

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
