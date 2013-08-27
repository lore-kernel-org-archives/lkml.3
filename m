Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752860Ab3H0Htj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 03:49:39 -0400
Received: from 20.mo3.mail-out.ovh.net ([178.33.47.94]:36196 "EHLO
	mo3.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752267Ab3H0Hth (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 03:49:37 -0400
Message-ID: <521C59E6.2050000@overkiz.com>
Date: Tue, 27 Aug 2013 09:48:54 +0200
From: boris brezillon <b.brezillon@overkiz.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: "David S. Miller" <davem@davemloft.net>
CC: Boris BREZILLON <b.brezillon@overkiz.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        Russell King <linux@arm.linux.org.uk>,
        Nicolas Ferre <nicolas.ferre@atmel.com>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
X-Ovh-Mailout: 178.32.228.3 (mo3.mail-out.ovh.net)
Subject: Re: [PATCH v3 0/2] net/cadence/macb: add support for dt phy definition
References: <1377589007-3684-1-git-send-email-b.brezillon@overkiz.com>
In-Reply-To: <1377589007-3684-1-git-send-email-b.brezillon@overkiz.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 6491657389649983525
X-Ovh-Remote: 80.245.18.66 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeikedrheegucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeikedrheegucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello David,

Sorry, I forgot to add your email in the cc list.

Do you want me to send you the whole series ?

Best Regards,

Boris

On 27/08/2013 09:36, Boris BREZILLON wrote:
> Hello,
>
> This patch series adds support for ethernet phy definition using device
> tree.
>
> This may help in moving some at91 boards to dt (some of them define an
> interrupt pin).
>
> Tested on samad31ek.
>
> Best Regards,
> Boris
>
> Changes since v2:
>   - fix wrong address of phy0 dt node
>
> Changes since v1:
>   - fix wrong macb_mii_init return code when no PHY device is discovered
>
> Boris BREZILLON (2):
>    net/cadence/macb: add support for dt phy definition
>    ARM: at91/dt: define phy available on sama5d3 mother board
>
>   arch/arm/boot/dts/sama5d3xmb.dtsi   |    8 ++++++
>   drivers/net/ethernet/cadence/macb.c |   48 +++++++++++++++++++++++++++--------
>   2 files changed, 46 insertions(+), 10 deletions(-)
>

