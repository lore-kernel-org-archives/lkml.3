Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752231AbaJBLKU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 07:10:20 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:47487 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751208AbaJBLKP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 07:10:15 -0400
Date: Thu, 2 Oct 2014 12:09:31 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Michal Simek <michal.simek@xilinx.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "monstr@monstr.eu" <monstr@monstr.eu>,
        Bjorn Helgaas <bhelgaas@google.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Jiri Kosina <trivial@kernel.org>,
        Srikanth Thokala <sthokal@xilinx.com>, Arnd Bergmann <arnd@arndb.de>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] PCI: xilinx: Trivial fix in DT example
Message-ID: <20141002110931.GH5788@leverpostej>
References: <4a72f98ee8564b6b040d6301e2719e37ddfea663.1412246470.git.michal.simek@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4a72f98ee8564b6b040d6301e2719e37ddfea663.1412246470.git.michal.simek@xilinx.com>
Thread-Topic: [PATCH] PCI: xilinx: Trivial fix in DT example
Accept-Language: en-GB, en-US
Content-Language: en-US
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 02, 2014 at 11:41:19AM +0100, Michal Simek wrote:
> Good to have it properly describe for c&p cases.

Yup.

> 
> Signed-off-by: Michal Simek <michal.simek@xilinx.com>

Acked-by: Mark Rutland <mark.rutland@arm.com>

Mark.

> ---
> 
> Based on linux-next. File should be in pci tree.
> ---
>  Documentation/devicetree/bindings/pci/xilinx-pcie.txt | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Documentation/devicetree/bindings/pci/xilinx-pcie.txt b/Documentation/devicetree/bindings/pci/xilinx-pcie.txt
> index 3e2c88d97ad4..02f979a48aeb 100644
> --- a/Documentation/devicetree/bindings/pci/xilinx-pcie.txt
> +++ b/Documentation/devicetree/bindings/pci/xilinx-pcie.txt
> @@ -58,5 +58,5 @@ Example:
>  			interrupt-controller;
>  			#address-cells = <0>;
>  			#interrupt-cells = <1>;
> -		}
> +		};
>  	};
> --
> 1.8.2.3
> 


