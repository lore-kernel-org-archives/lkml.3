Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753448Ab3H0MoM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 08:44:12 -0400
Received: from 6.mo1.mail-out.ovh.net ([46.105.43.205]:56670 "EHLO
	mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752907Ab3H0MoL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 08:44:11 -0400
Message-ID: <521C9EEF.1010303@overkiz.com>
Date: Tue, 27 Aug 2013 14:43:27 +0200
From: boris brezillon <b.brezillon@overkiz.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Boris BREZILLON <b.brezillon@overkiz.com>
CC: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        Russell King <linux@arm.linux.org.uk>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        "David S. Miller" <davem@davemloft.net>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
X-Ovh-Mailout: 178.32.228.1 (mo1.mail-out.ovh.net)
Subject: Re: [PATCH v2] ARM: at91/dt: fix phy address in sama5xmb to match
 the reg property
References: <1377605096-20903-1-git-send-email-b.brezillon@overkiz.com> <1377607313-21331-1-git-send-email-b.brezillon@overkiz.com>
In-Reply-To: <1377607313-21331-1-git-send-email-b.brezillon@overkiz.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 11452653853649172601
X-Ovh-Remote: 80.245.18.66 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -85
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeikedrheehucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenogetfedtuddqtdduucdludehmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -85
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeikedrheehucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenogetfedtuddqtdduucdludehmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for the noise, but the previous commit message was not clear enough.

On 27/08/2013 14:41, Boris BREZILLON wrote:
> Fix phy0 address to match the reg property defined in phy0 node.
>
> Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
> Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> ---
> Changes since v1:
>   - better commit message
>
>   arch/arm/boot/dts/sama5d3xmb.dtsi |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/arm/boot/dts/sama5d3xmb.dtsi b/arch/arm/boot/dts/sama5d3xmb.dtsi
> index e9521d5..dba739b 100644
> --- a/arch/arm/boot/dts/sama5d3xmb.dtsi
> +++ b/arch/arm/boot/dts/sama5d3xmb.dtsi
> @@ -84,7 +84,7 @@
>   
>   				#address-cells = <1>;
>   				#size-cells = <0>;
> -				phy0: ethernet-phy@0 {
> +				phy0: ethernet-phy@1 {
>   					interrupt-parent = <&pioE>;
>   					interrupts = <30 IRQ_TYPE_EDGE_FALLING>;
>   					reg = <1>;

