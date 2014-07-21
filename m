Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754010AbaGUJEa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 05:04:30 -0400
Received: from top.free-electrons.com ([176.31.233.9]:51375 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753266AbaGUJE1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 05:04:27 -0400
Date: Mon, 21 Jul 2014 11:04:23 +0200
From: Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>,
        sebastian.hesselbarth@gmail.com, tj@kernel.org, kishon@ti.com,
        alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org,
        linux-ide@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v10 2/8] Documentation: bindings: add the Berlin SATA PHY
Message-ID: <20140721090423.GD32208@kwain>
References: <1405686607-8126-1-git-send-email-antoine.tenart@free-electrons.com>
 <1405686607-8126-3-git-send-email-antoine.tenart@free-electrons.com>
 <53C95900.9050200@cogentembedded.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <53C95900.9050200@cogentembedded.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Jul 18, 2014 at 09:27:28PM +0400, Sergei Shtylyov wrote:
> On 07/18/2014 04:30 PM, Antoine Ténart wrote:
> 
> >diff --git a/Documentation/devicetree/bindings/phy/berlin-sata-phy.txt b/Documentation/devicetree/bindings/phy/berlin-sata-phy.txt
> >new file mode 100644
> >index 000000000000..88f8c23384c0
> >--- /dev/null
> >+++ b/Documentation/devicetree/bindings/phy/berlin-sata-phy.txt
> >@@ -0,0 +1,34 @@
> >+Berlin SATA PHY
> >+---------------
> >+
> >+Required properties:
> >+- compatible: should be "marvell,berlin2q-sata-phy"
> >+- address-cells: should be 1
> >+- size-cells: should be 0
> >+- phy-cells: from the generic PHY bindings, must be 1
> 
>    It's "#address-cells", "#size-cells", and "#phy-cells".

Sure.

> 
> >+- reg: address and length of the register
> >+- clocks: reference to the clock entry
> >+
> >+Sub-nodes:
> >+Each PHY should be represented as a sub-node.
> 
>    Then "#phy-cells" should also belong to the sub-nodes.

No, because the PHY provider is still the parent.

Antoine

-- 
Antoine Ténart, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
