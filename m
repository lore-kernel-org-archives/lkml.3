Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751885AbaDUMWa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 08:22:30 -0400
Received: from top.free-electrons.com ([176.31.233.9]:42090 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750908AbaDUMWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 08:22:24 -0400
Date: Mon, 21 Apr 2014 14:22:05 +0200
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Wenyou Yang <wenyou.yang@atmel.com>
Cc: devicetree@vger.kernel.org, nicolas.ferre@atmel.com,
        linux-kernel@vger.kernel.org, robh+dt@kernel.org, broonie@kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: dts: at91-sama5d3_xplained: add the regulator
 device node
Message-ID: <20140421122205.GB3461@piout.net>
References: <1398054547-5834-1-git-send-email-wenyou.yang@atmel.com>
 <20140421095443.GA3461@piout.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140421095443.GA3461@piout.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21/04/2014 at 11:54:43 +0200, Alexandre Belloni wrote :
> Hi,
> 
> On 21/04/2014 at 12:29:07 +0800, Wenyou Yang wrote :
> > +
> > +						vddana_reg: LDO_REG2 {
> > +							regulator-name = "VDDANA";
> > +							regulator-min-microvolt = <3300000>;
> > +							regulator-max-microvolt = <3300000>;
> > +							regulator-always-on;
> 
> I'm pretty sure that one is not always on as you actually have to
> configure it to get any voltage. Are you sure you want to set the
> regulator-always-on property here ?
> 

Just to clarify my though, wouldn't it be better to make the ADC driver
handle that regulator instead of using regulator-always-on ?

-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
