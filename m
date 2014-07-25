Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932844AbaGYIuV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 04:50:21 -0400
Received: from top.free-electrons.com ([176.31.233.9]:54037 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751220AbaGYIuS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 04:50:18 -0400
Date: Fri, 25 Jul 2014 10:50:14 +0200
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Boris BREZILLON <boris.brezillon@free-electrons.com>
Cc: =?utf-8?B?SmnFmcOt?= Prchal <jiri.prchal@aksignal.cz>,
        devicetree@vger.kernel.org, nicolas.ferre@atmel.com,
        linux-arm-kernel@lists.infradead.org, Bo Shen <voice.shen@atmel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: at91: at91sam9x5: sets NPCS0 (PA14) back to GPIO
Message-ID: <20140725085014.GE9532@piout.net>
References: <1405074175-22444-1-git-send-email-voice.shen@atmel.com>
 <53D10C50.50305@aksignal.cz>
 <20140724162645.4e19c26c@bbrezillon>
 <53D12103.3020103@aksignal.cz>
 <20140724175848.44f5da10@bbrezillon>
 <53D1F5D0.1080006@aksignal.cz>
 <20140725083053.GD9532@piout.net>
 <20140725103645.7fbf5b63@bbrezillon>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140725103645.7fbf5b63@bbrezillon>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25/07/2014 at 10:36:45 +0200, Boris Brezillon wrote :
> Hi Alexandre,
> 
> On Fri, 25 Jul 2014 10:30:54 +0200
> Alexandre Belloni <alexandre.belloni@free-electrons.com> wrote:
> 
> > Hi,
> > 
> > On 25/07/2014 at 08:14:40 +0200, Jiří Prchal wrote :
> > > I'm using custom board. My spi node:
> > > 			spi0: spi@f0000000 {
> > 
> > You should override the pinctrl here as you are using gpios for the cs.
> > 				pinctrl-0 = <&pinctrl_spi0_custom>;
> 
> I guess you meant:
> 			pinctrl-0 <&pinctrl_spi0 &pinctrl_spi0_custom>;
> 

Sure, you are right

> I suggested the same thing, however I'm pretty sure this is not the
> source of the problem. As I said, gpio_request already mux the
> associated pin to GPIO function.
> 
> Best Regards,
> 
> Boris
> 
> 
> -- 
> Boris Brezillon, Free Electrons
> Embedded Linux and Kernel engineering
> http://free-electrons.com

-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
