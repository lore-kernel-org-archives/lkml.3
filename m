Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752425AbaAFBsC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jan 2014 20:48:02 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:54347 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751782AbaAFBr6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jan 2014 20:47:58 -0500
X-AuditID: cbfee68e-b7f566d000002344-1c-52ca0b4adaf3
From: Jingoo Han <jg1.han@samsung.com>
To: "'Tanmay Inamdar'" <tinamdar@apm.com>
Cc: "'Bjorn Helgaas'" <bhelgaas@google.com>,
        "'Grant Likely'" <grant.likely@linaro.org>,
        "'Catalin Marinas'" <catalin.marinas@arm.com>,
        "'Rob Landley'" <rob@landley.net>, linux-pci@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        patches@apm.com, "'Jon Masters'" <jcm@redhat.com>,
        "'Jason Gunthorpe'" <jgunthorpe@obsidianresearch.com>,
        "'Arnd Bergmann'" <arnd@arndb.de>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <1387785725-24262-1-git-send-email-tinamdar@apm.com>
 <1387785725-24262-2-git-send-email-tinamdar@apm.com>
In-reply-to: <1387785725-24262-2-git-send-email-tinamdar@apm.com>
Subject: Re: [RFC PATCH 1/3] pci: APM X-Gene PCIe controller driver
Date: Mon, 06 Jan 2014 10:47:54 +0900
Message-id: <007401cf0a81$51429250$f3c7b6f0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac7/tk/nuqJ+6YgKT8CkARmgVGoPvQKyHnaA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrCKsWRmVeSWpSXmKPExsVy+t8zQ10v7lNBBtM22Vj8nXSM3WJJU4bF
	+2U9jBbzj5xjtTjwZwejxaS1y5ktLi+8xGrx/YapxabH11gtFrYtYbG4vGsOm8XZecfZLJrP
	fGOzWPdyOovF80+fWBz4PT6u/8TosWbeGkaP378mMXos2FTq8Wr1TFaPO9f2sHlsXlLv8X1H
	L6PH+31X2Tz6tqxi9Pi8SS6AO4rLJiU1J7MstUjfLoEr49+6pywFyyQqzsz9ydjAOF+4i5GT
	Q0LAROL4r6OsELaYxIV769m6GLk4hASWMUr8eNXFCFM040QvM0RiOqPE8yfLWCCcX4wSDbsb
	mUGq2ATUJL58OczexcjBISKgLrF7igxIDbPAB2aJlrZ3YCuEBMolNk5+CTaVU8BR4vbhu2C2
	sICzROekU2wgNouAqsTF/R9YQGxeAVuJA7MaGSFsQYkfk++BxZkFtCTW7zzOBGHLS2xe85YZ
	ZK8E0N5Hf3VBwiICRhKrD2yGKheR2PfiHSPIPRICVzgkvm26zg6xS0Di2+RDLBC9shKbDjBD
	PCwpcXDFDZYJjBKzkGyehWTzLCSbZyFZsYCRZRWjaGpBckFxUnqRkV5xYm5xaV66XnJ+7iZG
	SArp28F484D1IcZkoPUTmaVEk/OBKSivJN7Q2MzIwtTE1NjI3NKMNGElcd5FD5OChATSE0tS
	s1NTC1KL4otKc1KLDzEycXBKNTDmzzxovkY0+ngrtxyj4EaTwyxNnQETA9103u/tqPx3sW1+
	vmxtl/5jBuPl0wXnLNnvtMRNsPD68gVJNi/ENPr/rCrRuL1V8n4/Z9i8tZsX3Nu17PLONN27
	c2V+2n14122wstPuzIOWGTZ2k9gCuLoOCTyQLb9bLyKo9rVKIJOpzXfNybmnTzEpsRRnJBpq
	MRcVJwIA+IHjWzcDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpkk+LIzCtJLcpLzFFi42I5/e+xoK4X96kggwt7zCz+TjrGbrGkKcPi
	/bIeRov5R86xWhz4s4PRYtLa5cwWlxdeYrX4fsPUYtPja6wWC9uWsFhc3jWHzeLsvONsFs1n
	vrFZrHs5ncXi+adPLA78Hh/Xf2L0WDNvDaPH71+TGD0WbCr1eLV6JqvHnWt72Dw2L6n3+L6j
	l9Hj/b6rbB59W1YxenzeJBfAHdXAaJORmpiSWqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGu
	pJCXmJtqq+TiE6DrlpkD9ImSQlliTilQKCCxuFhJ3w7ThNAQN10LmMYIXd+QILgeIwM0kLCO
	MePfuqcsBcskKs7M/cnYwDhfuIuRk0NCwERixoleZghbTOLCvfVsXYxcHEIC0xklnj9ZxgLh
	/GKUaNjdCFbFJqAm8eXLYfYuRg4OEQF1id1TZEBqmAU+MEu0tL1jBakREiiX2Dj5JSOIzSng
	KHH78F0wW1jAWaJz0ik2EJtFQFXi4v4PLCA2r4CtxIFZjYwQtqDEj8n3wOLMAloS63ceZ4Kw
	5SU2r3nLDLJXAmjvo7+6IGERASOJ1Qc2Q5WLSOx78Y5xAqPQLCSTZiGZNAvJpFlIWhYwsqxi
	FE0tSC4oTkrPNdQrTswtLs1L10vOz93ECE5Qz6R2MK5ssDjEKMDBqMTD++HxySAh1sSy4src
	Q4wSHMxKIrynmU4FCfGmJFZWpRblxxeV5qQWH2JMBnp0IrOUaHI+MHnmlcQbGpuYGVkamVkY
	mZibkyasJM57oNU6UEggPbEkNTs1tSC1CGYLEwenVAPjoi7utyGXlyi5e3I9Sg1452ElU5pz
	pfXz3qDZGQKTInKe+C/YcjJYxsVopWy9ePHjQ2W5723eVk356bI+58nHN7vsL77VuC/vujuq
	2rs9u4z1voTMpIvrVr19IZI06bGyqFnACvdLyZuY/154MXcFz4kr+8J3vtYPdP3uYv5Pf//j
	dQ1P5b4oKrEUZyQaajEXFScCAIl4Mk6UAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, December 23, 2013 5:02 PM, Tanmay Inamdar wrote:
> 
> This patch adds the AppliedMicro X-gene SOC PCIe controller driver.
> APM X-Gene PCIe controller supports maximum upto 8 lanes and
> GEN3 speed. X-Gene has maximum 5 PCIe ports supported.

(+cc Jason Gunthorpe, Arnd Bergmann)

Hi Tanmay Inamdar,

I added some minor comments. :-)

> 
> Signed-off-by: Tanmay Inamdar <tinamdar@apm.com>
> ---
>  drivers/pci/host/Kconfig      |    5 +
>  drivers/pci/host/Makefile     |    1 +
>  drivers/pci/host/pcie-xgene.c | 1017 +++++++++++++++++++++++++++++++++++++++++

Would you change the file name to 'pci-xgene.c'?
Now, all PCI host drivers are using the prefix 'pci-', not 'pcie-'.

[.....]

> +#include <linux/module.h>
> +#include <linux/delay.h>
> +#include <linux/pci.h>
> +#include <linux/slab.h>
> +#include <linux/memblock.h>
> +#include <linux/io.h>
> +#include <linux/platform_device.h>
> +#include <linux/of.h>
> +#include <linux/of_address.h>
> +#include <linux/of_irq.h>
> +#include <linux/of_pci.h>
> +#include <linux/jiffies.h>
> +#include <linux/clk-private.h>

Would you re-order these headers alphabetically?
It enhances the readability.

[.....]

> +static int xgene_pcie_parse_map_ranges(struct xgene_pcie_port *port)
> +{
> +	struct device_node *np = port->node;
> +	struct of_pci_range range;
> +	struct of_pci_range_parser parser;
> +	struct device *dev = port->dev;
> +	u32 cfg_map_done = 0;
> +	int ret;
> +
> +	if (of_pci_range_parser_init(&parser, np)) {
> +		dev_err(dev, "missing ranges property\n");
> +		return -EINVAL;
> +	}
> +
> +	/* Get the I/O, memory, config ranges from DT */
> +	for_each_of_pci_range(&parser, &range) {
> +		struct resource *res = NULL;
> +		u64 restype = range.flags & IORESOURCE_TYPE_BITS;
> +		u64 end = range.cpu_addr + range.size - 1;
> +		dev_dbg(port->dev, "0x%08x 0x%016llx..0x%016llx -> 0x%016llx\n",
> +			range.flags, range.cpu_addr, end, range.pci_addr);
> +
> +		switch (restype) {
> +		case IORESOURCE_IO:
> +			res = &port->res[XGENE_IO];
> +			of_pci_range_to_resource(&range, np, res);
> +			xgene_pcie_setup_ob_reg(port->csr_base, OMR1BARL,
> +						XGENE_IO, res);
> +			break;
> +		case IORESOURCE_MEM:
> +			res = &port->res[XGENE_MEM];
> +			of_pci_range_to_resource(&range, np, res);
> +			xgene_pcie_setup_ob_reg(port->csr_base, OMR2BARL,
> +						XGENE_MEM, res);
> +			break;
> +		case 0:
> +			if (!cfg_map_done) {
> +				/* config region */
> +				if (port->type == PTYPE_ROOT_PORT) {
> +					ret = xgene_pcie_map_cfg(port, &range);
> +					if (ret)
> +						return ret;
> +				}
> +				cfg_map_done = 1;
> +			} else {
> +				/* msi region */
> +				res = &port->res[XGENE_MSI];
> +				of_pci_range_to_resource(&range, np, res);

As Jason Gunthorpe said, the DT 'range' property should not
handle MSI. Please refer to other PCI host drivers such as
pci-mvebu.c, pci-tegra.c and pcie-designware.c.

Currently, 'struct msi_chip', ' struct irq_domain' are used 
for implementing MSI feature.

Best regards,
Jingoo Han

