Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756886AbaCTLek (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 07:34:40 -0400
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:38650 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750917AbaCTLeh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 07:34:37 -0400
X-Forefront-Antispam-Report: CIP:62.221.5.235;KIP:(null);UIP:(null);IPV:NLI;H:xir-gw1;RD:unknown-62-221-5-235.ipspace.xilinx.com;EFVD:NLI
X-SpamScore: 2
X-BigFish: VPS2(zzbb2dI98dI9371I1432I4015Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzz1de098h8275bh8275dh1de097h186068hz2fh95h839h947hc61hd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h190ch1946h19b4h19b5h19c3h1b0ah1be0h224fh1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh2216h2336h2438h2461h2487h24d7h2516h2545h255eh25f6h2605h2668h2673i19b6n1155h)
Date: Thu, 20 Mar 2014 12:34:23 +0100
From: Michal Simek <michal.simek@xilinx.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Soren Brinkmann <soren.brinkmann@xilinx.com>
CC: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        Michal Simek <michal.simek@xilinx.com>,
        Wolfram Sang <wsa@the-dreams.de>,
        Grant Likely <grant.likely@linaro.org>,
        Mike Looijmans <mike.looijmans@topic.nl>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-doc@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-i2c@vger.kernel.org>, Harini Katakam <harinik@xilinx.com>
Subject: Re: [PATCH v3 1/2] i2c: Add driver for Cadence I2C controller
References: <1394556613-11692-1-git-send-email-soren.brinkmann@xilinx.com>
In-Reply-To: <1394556613-11692-1-git-send-email-soren.brinkmann@xilinx.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-RCIS-Action: ALLOW
Message-ID: <96ea5cd7-0873-4352-b835-5c5a0dbad685@TX2EHSMHS037.ehs.local>
X-OriginatorOrg: xilinx.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/11/2014 05:50 PM, Soren Brinkmann wrote:
> Add a driver for the Cadence I2C controller. This controller is for
> example found in Xilinx Zynq.
> 
> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> ---
> v3:
>  - incorporate signal handling changes from Mike Looijmans
>    <mike.looijmans@topic.nl> (https://lkml.org/lkml/2014/3/11/64)
> v2:
>  - make driver depend on COMMON_CLK instead of ARCH_ZYNQ
> ---
>  .../devicetree/bindings/i2c/i2c-cadence.txt        |  21 +
>  MAINTAINERS                                        |   1 +
>  drivers/i2c/busses/Kconfig                         |   7 +
>  drivers/i2c/busses/Makefile                        |   1 +
>  drivers/i2c/busses/i2c-cadence.c                   | 898 +++++++++++++++++++++
>  5 files changed, 928 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/i2c/i2c-cadence.txt
>  create mode 100644 drivers/i2c/busses/i2c-cadence.c

For boot test on zynq zc702 3.14.0-rc6.
Tested-by: Michal Simek <michal.simek@xilinx.com>

Thanks,
Michal


