Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932068Ab3GZMPS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 08:15:18 -0400
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:54569
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757321Ab3GZMPO convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 08:15:14 -0400
X-Forefront-Antispam-Report: CIP:62.221.5.235;KIP:(null);UIP:(null);IPV:NLI;H:xir-gw1;RD:unknown-62-221-5-235.ipspace.xilinx.com;EFVD:NLI
X-SpamScore: 1
X-BigFish: VPS1(zzbb2dI98dI9371Ic89bh1432I4015Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzzz2fh95h668h839h93fhd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h190ch1946h19b4h19b5h19c3h1b0ah1be0h1d0ch1d2eh1d3fh1dfeh1dffh19b6n1155h192ch)
Date: Fri, 26 Jul 2013 14:15:06 +0200
From: Michal Simek <michal.simek@xilinx.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Soren Brinkmann <soren.brinkmann@xilinx.com>
CC: Michal Simek <michal.simek@xilinx.com>,
        Russell King <linux@arm.linux.org.uk>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 0/3] arm: zynq: SLCR clean up
References: <1374081015-31431-1-git-send-email-soren.brinkmann@xilinx.com>
In-Reply-To: <1374081015-31431-1-git-send-email-soren.brinkmann@xilinx.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="UTF-8"
X-RCIS-Action: ALLOW
Message-ID: <529db7d7-70f5-4dae-8482-cc982c3319cb@VA3EHSMHS026.ehs.local>
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/17/2013 07:10 PM, Soren Brinkmann wrote:
> These are just a few patches cleaning up the driver - well at least I
> find it cleaner this way.
> 3/3 though adds correct read-modify-write for some register accesses.
> The current implementation doesn't seem to do any harm, but this looks
> better, IMHO.
> 
> 	Sören
> 
> Soren Brinkmann (3):
>   arm: zynq: slcr: Remove redundant header #includes
>   arm: zynq: slcr: Clean up #defines
>   arm: zynq: slcr: Use read-modify-write for register writes
> 
>  arch/arm/mach-zynq/slcr.c | 45 +++++++++++++++++----------------------------
>  1 file changed, 17 insertions(+), 28 deletions(-)

Applied to zynq/cleanup branch.

Thanks,
Michal


