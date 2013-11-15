Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758359Ab3KOL16 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 06:27:58 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:50142 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757907Ab3KOL1t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 06:27:49 -0500
Date: Fri, 15 Nov 2013 11:26:50 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Sebastian Reichel <sre@debian.org>
Cc: Tony Lindgren <tony@atomide.com>, Anton Vorontsov <anton@enomsg.org>,
        David Woodhouse <dwmw2@infradead.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Pali =?utf-8?B?Um9ow6Fy?= <pali.rohar@gmail.com>
Subject: Re: [PATCH 2/2] dt: binding documentation for isp1704 charger
Message-ID: <20131115112650.GF1709@e106331-lin.cambridge.arm.com>
References: <1384432734-1490-1-git-send-email-sre@debian.org>
 <1384432734-1490-2-git-send-email-sre@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1384432734-1490-2-git-send-email-sre@debian.org>
Thread-Topic: [PATCH 2/2] dt: binding documentation for isp1704 charger
Accept-Language: en-GB, en-US
Content-Language: en-US
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 14, 2013 at 12:38:54PM +0000, Sebastian Reichel wrote:
> Add devicetree binding documentation for isp1704-charger.
> 
> Signed-off-by: Sebastian Reichel <sre@debian.org>
> ---
>  Documentation/devicetree/bindings/power/isp1704.txt | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/power/isp1704.txt
> 
> diff --git a/Documentation/devicetree/bindings/power/isp1704.txt b/Documentation/devicetree/bindings/power/isp1704.txt
> new file mode 100644
> index 0000000..bbeec11
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/power/isp1704.txt
> @@ -0,0 +1,17 @@
> +Binding for NXP ISP1704 USB Charger Detection
> +
> +Required properties:
> +- compatible: Should contain one of the following:
> + * "nxp,isp1704"
> +- nxp,enable-gpio: Should contain a phandle to the

Nit: phandle + gpio-specifier

Otherwise this looks fine.

Mark.
