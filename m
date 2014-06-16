Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755096AbaFPJTt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 05:19:49 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:55271 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755078AbaFPJTs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 05:19:48 -0400
Date: Mon, 16 Jun 2014 10:19:42 +0100
From: Peter Griffin <peter.griffin@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        maxime.coquelin@st.com, patrice.chotard@st.com,
        srinivas.kandagatla@gmail.com, gabriel.fernandez@st.com,
        daniel.thompson@linaro.org
Subject: Re: [PATCH] ARM: STi: DT: Properly define sti-ethclk & stmmaceth for
 stih415/6
Message-ID: <20140616091942.GA27978@griffinp-ThinkPad-X1-Carbon-2nd>
References: <1402345355-5682-1-git-send-email-peter.griffin@linaro.org>
 <20140616090146.GI14323@lee--X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140616090146.GI14323@lee--X1>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lee,

> >  		ethernet1: dwmac@fef08000 {
> > @@ -189,11 +189,11 @@
> >  			st,syscon		= <&syscfg_sbc>;
> >  
> >  			resets			= <&softreset STIH415_ETH1_SOFTRESET>;
> > -			reset-names		= "stmmaceth";
> > +			reset-names		= "stmmaceth", "sti-ethclk";
> >  			pinctrl-names 	= "default";
> >  			pinctrl-0	= <&pinctrl_mii1>;
> >  			clock-names	= "stmmaceth";
> > -			clocks		= <&clk_s_a0_ls CLK_ETH1_PHY>;
> > +			clocks		= <&clk_s_a0_ls CLK_ICN_REG>, <&clk_s_a0_ls CLK_ETH1_PHY>;
> 
> This looks wrong to me.  You appear to have changed the reset-names
> instead of the clock-names here.

Whoops, your right, I'll send a V2 shortly.

Pete.

