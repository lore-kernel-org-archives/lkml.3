Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753755AbaDKGf0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 02:35:26 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:17842 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750751AbaDKGfY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 02:35:24 -0400
Date: Fri, 11 Apr 2014 14:33:18 +0800
From: Jisheng Zhang <jszhang@marvell.com>
To: Antoine =?UTF-8?B?VMOpbmFydA==?= 
	<antoine.tenart@free-electrons.com>
CC: "sebastian.hesselbarth@gmail.com" <sebastian.hesselbarth@gmail.com>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "alexandre.belloni@free-electrons.com" 
	<alexandre.belloni@free-electrons.com>,
        Jimmy Xu <zmxu@marvell.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RESEND 4/5] Documentation: add the Marvell Berlin
 pinctrl documentation
Message-ID: <20140411143318.67e55a17@xhacker>
In-Reply-To: <1397135274-10764-5-git-send-email-antoine.tenart@free-electrons.com>
References: <1397135274-10764-1-git-send-email-antoine.tenart@free-electrons.com>
	<1397135274-10764-5-git-send-email-antoine.tenart@free-electrons.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.96,1.0.14,0.0.0000
 definitions=2014-04-11_03:2014-04-11,2014-04-11,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=2
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1402240000 definitions=main-1404110114
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Apr 2014 06:07:53 -0700
Antoine Ténart <antoine.tenart@free-electrons.com> wrote:

> Signed-off-by: Antoine Ténart <antoine.tenart@free-electrons.com>
> ---
>  .../bindings/pinctrl/marvell,berlin-pinctrl.txt    | 43
> ++++++++++++++++++++++ 1 file changed, 43 insertions(+)
>  create mode 100644
> Documentation/devicetree/bindings/pinctrl/marvell,berlin-pinctrl.txt
> 
> diff --git
> a/Documentation/devicetree/bindings/pinctrl/marvell,berlin-pinctrl.txt
> b/Documentation/devicetree/bindings/pinctrl/marvell,berlin-pinctrl.txt new
> file mode 100644 index 000000000000..e21538a37734 --- /dev/null
> +++ b/Documentation/devicetree/bindings/pinctrl/marvell,berlin-pinctrl.txt
> @@ -0,0 +1,43 @@
> +* Pinctrl driver for the Marvell Berlin SoCs
> +
> +The pins controlled by the Marvell Berlin controller are organized in
> groups. +Configuration is done by group, so no actual pin information is
> needed. +
> +Required properties:
> +- compatible:	"marvell-berlin2cd-pinctrl",
> +		"marvell-berlin2-pinctrl",
> +		"marvell-berlin2q-pinctrl"
> +- reg: registers physical addresses and lengths of the pin controller.
> +- reg-names: name of the register regions.
> +
> +Please refer to pinctrl-bindings.txt in this directory for details of the
> +common pinctrl bindings used by client devices.
> +
> +A pinctrl should contains subnodes representing the pinctrl pin group
> +configurations, one per group. Each subnode has the group name and the
> muxing +function used.
> +
> +Required subnode-properties:
> +- berlin,group: a string describing the group's name.
> +- berlin,function: the function used to mux the group.

Would it be better to s/function/mode? Because in mrvl internal technology
discussion and docs, we usually say "set pinmux Gy as mode z".


Thanks,
Jisheng
