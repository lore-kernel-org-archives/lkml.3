Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754020AbaFWVxY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 17:53:24 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:60877 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753721AbaFWVxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 17:53:22 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18sRu6Gj5I6ojCnEGOpE/JT/tNo4qe3GLo=
X-DKIM: OpenDKIM Filter v2.0.1 titan D82A5597BFD
Date: Mon, 23 Jun 2014 17:53:09 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Gregory CLEMENT <gregory.clement@free-electrons.com>
Cc: Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        sergei.shtylyov@cogentembedded.com,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: mvebu: Fix the improper use of the compatible
 string armada38x using a wildcard
Message-ID: <20140623215309.GD10202@titan.lakedaemon.net>
References: <1403533011-21339-1-git-send-email-gregory.clement@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403533011-21339-1-git-send-email-gregory.clement@free-electrons.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 23, 2014 at 04:16:51PM +0200, Gregory CLEMENT wrote:
> Wildcards in compatible strings should be avoid. "marvell,armada38x"
> was recently introduced but was not yet used.
> 
> The armada 385 SoC is a superset of the armada 380 SoC (with more CPUs
> and more PCIe slots). So this patch replaces the use of
> "marvell,armada38x" by the "marvell,armada380" string.
> 
> Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
> ---
> Hi,
> 
> This fix should be merged in 3.16 and maybe sent as a fix for 3.15
> too.
> 
> The initial patch (ARM: mvebu: Fix missing binding documentation for
> Armada 38x) was re-written after the review about the use of the
> wildcards here:
> http://thread.gmane.org/gmane.linux.kernel/1728755/focus=79339 and
> there:
> http://thread.gmane.org/gmane.linux.ports.arm.kernel/334225/focus=334311
> 
> 
> Thanks,
> Gregory
> 
>  Documentation/devicetree/bindings/arm/armada-38x.txt | 14 ++++++++++++--
>  arch/arm/boot/dts/armada-380.dtsi                    |  2 +-
>  arch/arm/boot/dts/armada-385-db.dts                  |  2 +-
>  arch/arm/boot/dts/armada-385-rd.dts                  |  2 +-
>  arch/arm/boot/dts/armada-385.dtsi                    |  2 +-
>  arch/arm/boot/dts/armada-38x.dtsi                    |  2 +-
>  6 files changed, 17 insertions(+), 7 deletions(-)

Applied to mvebu/dt with Andrew's Ack.

thx,

Jason.
