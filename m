Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754197Ab3AaGND (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 01:13:03 -0500
Received: from co9ehsobe001.messaging.microsoft.com ([207.46.163.24]:51820
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750941Ab3AaGM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 01:12:58 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz98dI1432Izz1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275dh8275bhz2dh87h2a8h668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Thu, 31 Jan 2013 14:12:50 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Anson Huang <b20788@freescale.com>
CC: <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <grant.likely@secretlab.ca>,
        <rob.herring@calxeda.com>, <rob@landley.net>,
        <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH V3] regulators: anatop: add set_voltage_time_sel interface
Message-ID: <20130131061248.GF2765@S2101-09.ap.freescale.net>
References: <1359649433-3691-1-git-send-email-b20788@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1359649433-3691-1-git-send-email-b20788@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 31, 2013 at 11:23:53AM -0500, Anson Huang wrote:
> some of anatop's regulators(cpu, vddpu and vddsoc) have
> register settings about LDO's step time, which will impact
> the LDO ramp up speed, need to use set_voltage_time_sel
> interface to add necessary delay everytime LDOs' voltage
> is increased.
> 
> offset 0x170:
> bit [24-25]: cpu
> bit [26-27]: vddpu
> bit [28-29]: vddsoc
> 
> field definition:
> 0'b00: 64 cycles of 24M clock;
> 0'b01: 128 cycles of 24M clock;
> 0'b02: 256 cycles of 24M clock;
> 0'b03: 512 cycles of 24M clock;
> 
> Signed-off-by: Anson Huang <b20788@freescale.com>

Acked-by: Shawn Guo <shawn.guo@linaro.org>

