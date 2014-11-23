Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753138AbaKWIZp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2014 03:25:45 -0500
Received: from mail-pd0-f181.google.com ([209.85.192.181]:34462 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751711AbaKWIZo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2014 03:25:44 -0500
Date: Sun, 23 Nov 2014 16:25:11 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Soeren Moch <smoch@web.de>
Cc: linux-arm-kernel@lists.infradead.org, Sascha Hauer <kernel@pengutronix.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: dts: imx6q-tbs2910: Enable snvs-poweroff
Message-ID: <20141123082510.GD11253@dragon>
References: <1416380089-6317-1-git-send-email-smoch@web.de>
 <546E4BA6.5020606@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <546E4BA6.5020606@web.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 20, 2014 at 09:14:30PM +0100, Soeren Moch wrote:
> On 11/19/14 07:54, Soeren Moch wrote:
> >This patch enables snvs-poweroff for TBS2910 boards.
> >
> >Signed-off-by: Soeren Moch <smoch@web.de>
> >--
> >Cc: Shawn Guo <shawn.guo@linaro.org>
> >Cc: Sascha Hauer <kernel@pengutronix.de>
> >Cc: linux-kernel@vger.kernel.org
> >---
> >  arch/arm/boot/dts/imx6q-tbs2910.dts | 4 ++++
> >  1 file changed, 4 insertions(+)
> >
> >diff --git a/arch/arm/boot/dts/imx6q-tbs2910.dts b/arch/arm/boot/dts/imx6q-tbs2910.dts
> >index d2a5743..7e7496c 100644
> >--- a/arch/arm/boot/dts/imx6q-tbs2910.dts
> >+++ b/arch/arm/boot/dts/imx6q-tbs2910.dts
> >@@ -208,6 +208,10 @@
> >  	status = "okay";
> >  };
> >+&snvs_poweroff {
> >+	status = "okay";
> >+};
> >+
> >  &spdif {
> >  	pinctrl-names = "default";
> >  	pinctrl-0 = <&pinctrl_spdif>;
> Shawn,
> 
> since snvs_poweroffis applied now, can you take this patch for 3.19?

Applied for 3.19, thanks.
