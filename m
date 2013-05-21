Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754222Ab3EUOfH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 10:35:07 -0400
Received: from co9ehsobe002.messaging.microsoft.com ([207.46.163.25]:12977
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753452Ab3EUOfF convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 10:35:05 -0400
X-Forefront-Antispam-Report: CIP:62.221.5.235;KIP:(null);UIP:(null);IPV:NLI;H:xir-gw1;RD:unknown-62-221-5-235.ipspace.xilinx.com;EFVD:NLI
X-SpamScore: 1
X-BigFish: VPS1(zzbb2dI98dI9371Ic89bh1432I4015Izz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzz8275bhz2fh95h668h839h93fhd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h190ch1946h19b4h19b5h19c3h1b0ah1be0h1d0ch1d2eh1d3fh19b6n1155h)
Date: Tue, 21 May 2013 16:34:49 +0200
From: Michal Simek <michal.simek@xilinx.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Soren Brinkmann <soren.brinkmann@xilinx.com>
CC: Michal Simek <michal.simek@xilinx.com>,
        Josh Cartwright <joshc@eso.teric.us>,
        Mike Turquette <mturquette@linaro.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Peter Crosthwaite <peter.crosthwaite@xilinx.com>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Arnd Bergmann <arnd@arndb.de>, Russell King <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>
Subject: Re: [PATCH v2 0/5] Zynq: revised CCF code
References: <1368467199-8702-1-git-send-email-soren.brinkmann@xilinx.com>
In-Reply-To: <1368467199-8702-1-git-send-email-soren.brinkmann@xilinx.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset="UTF-8"
X-RCIS-Action: ALLOW
Message-ID: <6d3d9b84-3438-4d74-9565-5c969e72b1df@CO9EHSMHS025.ehs.local>
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/13/2013 07:46 PM, Soren Brinkmann wrote:
> I rebased this series on v3.10-rc1 eliminating all dependencies and incorporated
> Greg's feedback.
> I'll push this also to my github repository.
> https://github.com/sorenb-xlnx/linux-xlnx/tree/zynq/clkc
> 
> v2:
>  - dropped the 'sort #includes' patches
> 
> 	Sören
> 
> 
> Soren Brinkmann (5):
>   tty: xuartps: Remove suspend/resume functions

This patch will go through Greg trees.

>   clk: zynq: Factor out PLL driver
>   clk: zynq: Add clock controller driver
>   arm: zynq: Migrate platform to clock controller
>   clk: zynq: Remove deprecated clock code

I have added these patches to my arm-next branch
and also to zynq/clk branch.

Thanks,
Michal


