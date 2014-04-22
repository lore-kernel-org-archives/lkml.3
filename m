Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932161AbaDVLK5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 07:10:57 -0400
Received: from co9ehsobe002.messaging.microsoft.com ([207.46.163.25]:20727
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755457AbaDVLKy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 07:10:54 -0400
X-Forefront-Antispam-Report: CIP:62.221.5.235;KIP:(null);UIP:(null);IPV:NLI;H:xir-gw1;RD:unknown-62-221-5-235.ipspace.xilinx.com;EFVD:NLI
X-SpamScore: 2
X-BigFish: VPS2(zzbb2dI98dI9371I1432I4015Izz1f42h2148h1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6h208chzz1de098h8275bh1de097hz2fh95h839h947hc61hd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h190ch1946h19b4h19b5h19c3h1b0ah1be0h224fh1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh2216h2336h2438h2461h2487h24d7h2516h2545h255eh25f6h2605h268bh26d3h2673i19b6n1155h)
Date: Tue, 22 Apr 2014 13:10:42 +0200
From: Michal Simek <michal.simek@xilinx.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Soren Brinkmann <soren.brinkmann@xilinx.com>
CC: Mike Turquette <mturquette@linaro.org>,
        Michal Simek <michal.simek@xilinx.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <git@xilinx.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Stephen Warren <swarren@nvidia.com>,
        James Hogan <james.hogan@imgtec.com>,
        Felipe Pena <felipensp@gmail.com>
Subject: Re: [PATCH] clk: zynq: Leave debug clocks in bootup state
References: <1397760052-3310-1-git-send-email-soren.brinkmann@xilinx.com>
In-Reply-To: <1397760052-3310-1-git-send-email-soren.brinkmann@xilinx.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-RCIS-Action: ALLOW
Message-ID: <9b50f9f9-0a8a-43a7-8d23-5f8f81b62a54@CO9EHSMHS015.ehs.local>
X-OriginatorOrg: xilinx.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/17/2014 08:40 PM, Soren Brinkmann wrote:
> Make sure debug clocks stay enabled if the bootloader enabled them.
> Otherwise debug HW may crash due to bus-hangs caused by stopped clocks.
> 
> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> ---
>  drivers/clk/zynq/clkc.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/drivers/clk/zynq/clkc.c b/drivers/clk/zynq/clkc.c
> index 52c09afdcfb7..246cf1226eaa 100644
> --- a/drivers/clk/zynq/clkc.c
> +++ b/drivers/clk/zynq/clkc.c
> @@ -53,6 +53,9 @@ static void __iomem *zynq_clkc_base;

Applied to zynq/clk.

Thanks,
Michal


