Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762198Ab3DCQb1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 12:31:27 -0400
Received: from va3ehsobe010.messaging.microsoft.com ([216.32.180.30]:5968 "EHLO
	va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758616Ab3DCQbZ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 12:31:25 -0400
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: -2
X-BigFish: VPS-2(zz98dIc89bh936eI1432Izz1f42h1fc6h1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275bhz2fh95h668h839h93fhd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1b0ah906i1155h)
Date: Wed, 3 Apr 2013 09:31:14 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Mike Turquette <mturquette@linaro.org>
CC: Shawn Guo <shawn.guo@linaro.org>, Rajendra Nayak <rnayak@ti.com>,
        Andrew Lunn <andrew@lunn.ch>, James Hogan <james.hogan@imgtec.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] clk: divider: Introduce CLK_DIVIDER_ALLOW_ZERO flag
References: <1364942216-4575-1-git-send-email-soren.brinkmann@xilinx.com>
 <20130403154027.8177.58419@quantum>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20130403154027.8177.58419@quantum>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <8fd6da66-dd3b-4e02-b958-095dee577330@VA3EHSMHS017.ehs.local>
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 03, 2013 at 08:40:27AM -0700, Mike Turquette wrote:
> Quoting Soren Brinkmann (2013-04-02 15:36:56)
> > Dividers which have CLK_DIVIDER_ONE_BASED set have a redundant state,
> > being a divider value of zero. Some hardware implementations allow a
> > zero divider which simply doesn't alter the frequency. I.e. it acts like
> > a divide by one or bypassing the divider.
> > This flag is used to handle such HW in the clk-divider model.
> > 
> > Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> 
> This version looks good.  Taken into clk-next.
Thanks.

	Sören


