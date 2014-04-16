Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755302AbaDPJO2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 05:14:28 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:15888 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755032AbaDPJOW convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 05:14:22 -0400
Date: Wed, 16 Apr 2014 17:11:12 +0800
From: Jisheng Zhang <jszhang@marvell.com>
To: Antoine =?UTF-8?B?VMOpbmFydA==?= 
	<antoine.tenart@free-electrons.com>
CC: "sebastian.hesselbarth@gmail.com" <sebastian.hesselbarth@gmail.com>,
        "alexandre.belloni@free-electrons.com" 
	<alexandre.belloni@free-electrons.com>,
        Jimmy Xu <zmxu@marvell.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 0/2] ARM: berlin: add GPIO support for the BG2Q
Message-ID: <20140416171112.31757110@xhacker>
In-Reply-To: <1397634395-7456-1-git-send-email-antoine.tenart@free-electrons.com>
References: <1397634395-7456-1-git-send-email-antoine.tenart@free-electrons.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.96,1.0.14,0.0.0000
 definitions=2014-04-16_02:2014-04-15,2014-04-16,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=1
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1402240000 definitions=main-1404160122
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Apr 2014 00:46:33 -0700
Antoine Ténart <antoine.tenart@free-electrons.com> wrote:

> This series add the support for the GPIOs of the Berlin BG2Q. We use the
> newly integrated dwapb GPIO driver here.
> 
> This applies on top of Alexandre's BG2Q symbol introduction[1] and the dwapb
> gpio patch fixing IRQ initialization[2].
> 
> [1] https://patchwork.kernel.org/patch/3876141/
> [2] https://lkml.org/lkml/2014/4/7/96
> 
> Changes since v1:
> 	- s/gpio-controller@/gpio-port@/ in device tree
> 	- moved ARCH_REQUIRE_GPIOLIB to ARCH_BERLIN in Kconfig
> 
> Antoine Ténart (2):
>   ARM: berlin: add the LIBGPIO as a dependency for the BG2Q
>   ARM: dts: berlin: add GPIO nodes for the BG2Q
> 
>  arch/arm/boot/dts/berlin2q.dtsi | 102
> ++++++++++++++++++++++++++++++++++++++++ arch/arm/mach-berlin/Kconfig
> |   1 + 2 files changed, 103 insertions(+)
> 

All the two patches look good

Thanks very much
