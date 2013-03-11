Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753549Ab3CKRmw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 13:42:52 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:57255 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751749Ab3CKRmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 13:42:50 -0400
Message-ID: <513E1797.4010808@wwwdotorg.org>
Date: Mon, 11 Mar 2013 11:42:47 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: Laxman Dewangan <ldewangan@nvidia.com>,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, pdeschrijver@nvidia.com
Subject: Re: [PATCH V2 3/5] ARM: DT: tegra114:add aliases and DMA requestor
 for serial controller
References: <1362852678-13421-1-git-send-email-ldewangan@nvidia.com> <1362852678-13421-4-git-send-email-ldewangan@nvidia.com> <20130310224219.GG4743@avionic-0098.mockup.avionic-design.de>
In-Reply-To: <20130310224219.GG4743@avionic-0098.mockup.avionic-design.de>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/10/2013 04:42 PM, Thierry Reding wrote:
> On Sat, Mar 09, 2013 at 11:41:16PM +0530, Laxman Dewangan wrote: 
> [...]
>> diff --git a/arch/arm/boot/dts/tegra114.dtsi 
>> b/arch/arm/boot/dts/tegra114.dtsi
> [...]
>> @@ -99,38 +106,50 @@ 0x70003000 0x40c>;	/* Mux registers */ };
>> 
>> -	serial@70006000 { +	/* +	 * There are two serial driver i.e. 
>> 8250 based simple serial +	 * driver and APB DMA based serial 
>> driver for higher baudrate +	 * and performace. To enable the 
>> 8250 based driver, the compatible +	 * is
>> "nvidia,tegra114-uart", "nvidia,tegra20-uart" and to enable +	 *
>> the APB DMA based serial driver, the comptible is +	 *
>> "nvidia,tegra114-hsuart", "nvidia,tegra30-hsuart". +	 */ +	uarta:
>> serial@70006000 {
> 
> I'm not sure if this is a good place for this comment. Perhaps it 
> should go into the binding documentation?

It is at least consistent with previous tegra20/30.dtsi. The two
compatible values are separate bindings, so a clue here re: which one
to go look at isn't a bad idea, although I agree that having each
binding document mention the other one would also be good.
