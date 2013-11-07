Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753803Ab3KGDS1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 22:18:27 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:10162 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751854Ab3KGDSY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 22:18:24 -0500
Date: Thu, 7 Nov 2013 11:13:56 +0800
From: Jisheng Zhang <jszhang@marvell.com>
To: Jisheng Zhang <jszhang@marvell.com>
CC: "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "baohua@kernel.org" <baohua@kernel.org>,
        "dinguyen@altera.com" <dinguyen@altera.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/4] arm: make use of common scu_a9_get_base() interface
Message-ID: <20131107111356.7575c85e@xhacker>
In-Reply-To: <1383793720-4643-1-git-send-email-jszhang@marvell.com>
References: <1383793720-4643-1-git-send-email-jszhang@marvell.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.10.8794,1.0.431,0.0.0000
 definitions=2013-11-07_01:2013-11-06,2013-11-07,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1305240000 definitions=main-1311060263
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Nov 2013 19:08:33 -0800
Jisheng Zhang <jszhang@marvell.com> wrote:

> Commit e9d6b3358ac35901ccc6a4a5a317670fa469db25 adds common APIs to
> get scu base address from CP15. This patch series connverts some platforms
> to use that interface.

OOPS, sorry, I made an mistake when generating patches. Please ignore this
serials. I'll submit V2 soon

Sorry again.
Jisheng
> 
> Jisheng Zhang (4):
>   arm: highbank: make use of common scu_a9_get_base() interface
>   arm: imx: make use of common scu_a9_get_base() interface
>   arm: prima2: make use of common scu_a9_get_base() interface
>   arm: socfgpa: make use of common scu_a9_get_base() interface
> 
>  arch/arm/mach-highbank/highbank.c | 4 ++--
>  arch/arm/mach-imx/platsmp.c       | 3 +--
>  arch/arm/mach-prima2/platsmp.c    | 3 +--
>  arch/arm/mach-socfpga/socfpga.c   | 4 ++--
>  4 files changed, 6 insertions(+), 8 deletions(-)
> 

