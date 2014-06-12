Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933089AbaFLKVf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 06:21:35 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:48711 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932894AbaFLKVd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 06:21:33 -0400
Date: Thu, 12 Jun 2014 18:19:19 +0800
From: Jisheng Zhang <jszhang@marvell.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "sebastian.hesselbarth@gmail.com" <sebastian.hesselbarth@gmail.com>,
        "alexandre.belloni@free-electrons.com" 
	<alexandre.belloni@free-electrons.com>,
        "antoine.tenart@free-electrons.com" 
	<antoine.tenart@free-electrons.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: dts: berlin2q.dtsi: set L2CC tag and data latency
 as 2 cycles
Message-ID: <20140612181919.038012f5@xhacker>
In-Reply-To: <20140612181503.06562a38@xhacker>
References: <1402565920-5636-1-git-send-email-jszhang@marvell.com>
	<20140612094423.GC23430@n2100.arm.linux.org.uk>
	<20140612181503.06562a38@xhacker>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.14,0.0.0000
 definitions=2014-06-12_04:2014-06-12,2014-06-12,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1402240000 definitions=main-1406120125
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Russell,

On Thu, 12 Jun 2014 03:15:03 -0700
Jisheng Zhang <jszhang@marvell.com> wrote:

> Hi Russell,
> 
> On Thu, 12 Jun 2014 02:44:23 -0700
> Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:
> 
> > On Thu, Jun 12, 2014 at 05:38:40PM +0800, Jisheng Zhang wrote:
> > > For all BG2Q SoCs, 2 cycles is the best/correct value
> > 
> > It would be a good idea to set all these parameters if you need to set
> > them at all - in other words, setting arm,dirty-latency as well, as
> > that's all part of the timing specification.
> > 
> 
> Thanks for reviewing this patch. I will check with SoC people to find the
> correct dirty-latency value.

The BG2Q L2 cache controller is PL310, so no "dirty-latency"

Thanks,
Jisheng
