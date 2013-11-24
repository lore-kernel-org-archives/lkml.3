Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753461Ab3KXQzH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Nov 2013 11:55:07 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:38955 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753134Ab3KXQzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Nov 2013 11:55:03 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 108.39.110.144
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/31g71XjA0gFCIbIeKwAk2YWgB6ixkkls=
Date: Sun, 24 Nov 2013 11:54:53 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: Srinivas Kandagatla <srinivas.kandagatla@st.com>
Cc: linux-arm-kernel@lists.infradead.org,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Russell King <linux@arm.linux.org.uk>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: dove: Fix typo in device_type property of phy node
Message-ID: <20131124165453.GF29241@titan.lakedaemon.net>
References: <1384440899-3622-1-git-send-email-srinivas.kandagatla@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1384440899-3622-1-git-send-email-srinivas.kandagatla@st.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 14, 2013 at 02:54:59PM +0000, Srinivas Kandagatla wrote:
> This patch fixes a typo for device_type property of phy node.
> This can work as of today but once a checks are added in generic code
> this typo will stop phy from working.
> 
> Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@st.com>
> ---
>  arch/arm/boot/dts/dove.dtsi |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)

Applied to mvebu/dt with Andrew's Ack.  I had to hand add it due to the
reworking of dove.dtsi last time around.  I've attached my version, let
me know if it looks amiss.

thx,

Jason.

----------->8---------------------
commit 9e52c63992c19b1d2e9a6b6b8ba61aaf35e9fd17
Author: Srinivas Kandagatla <srinivas.kandagatla@st.com>
Date:   Sun Nov 24 16:47:51 2013 +0000

    ARM: dove: Fix typo in device_type property of phy node
    
    This patch fixes a typo for device_type property of phy node.
    This can work as of today but once a checks are added in generic code
    this typo will stop phy from working.
    
    Acked-by: Andrew Lunn <andrew@lunn.ch>
    Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@st.com>

diff --git a/arch/arm/boot/dts/dove.dtsi b/arch/arm/boot/dts/dove.dtsi
index 113a8bc7bee7..abd7a6fd77f1 100644
--- a/arch/arm/boot/dts/dove.dtsi
+++ b/arch/arm/boot/dts/dove.dtsi
@@ -559,7 +559,7 @@
 				status = "disabled";
 
 				ethphy: ethernet-phy {
-					device-type = "ethernet-phy";
+					device_type = "ethernet-phy";
 					/* set phy address in board file */
 				};
 			};
