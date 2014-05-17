Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757221AbaEQIFN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2014 04:05:13 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:50881 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751727AbaEQIE6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2014 04:04:58 -0400
X-AuditID: cbfee691-b7f3e6d000002ce8-46-5377182745e4
Date: Sat, 17 May 2014 17:04:55 +0900
From: Cho KyongHo <pullip.cho@samsung.com>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Arnd Bergmann <arnd@arndb.de>,
        Grant Grundler <grundler@chromium.org>,
        Dave Martin <Dave.Martin@arm.com>, Marc Zyngier <marc.zyngier@arm.com>,
        Will Deacon <will.deacon@arm.com>, Joerg Roedel <joro@8bytes.org>,
        Stephen Warren <swarren@wwwdotorg.org>, devicetree@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-arm-kernel@lists.infradead.org,
        linux-tegra@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] devicetree: Add generic IOMMU device tree bindings
Message-id: <20140517170455.08e181f16d3abf36d1ec6274@samsung.com>
In-reply-to: <1400242998-437-1-git-send-email-thierry.reding@gmail.com>
References: <1400242998-437-1-git-send-email-thierry.reding@gmail.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.10.14; i686-pc-mingw32)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprDKsWRmVeSWpSXmKPExsVy+t8zI111ifJgg00/dS3+TjrGbtE0dw+j
	xfwj51gt+t8sZLV4deQHk8W5VysZLRbst7bonL2B3WLT42usFpd3zWGzmHF+H5NF55dZbBZ/
	7/xjs1h6/SKTxYTpa1ksWvceYbd4dbCNxeLnrnksFi8/nmBxEPZ4cnAek8eaeWsYPX7/msTo
	MbvhIovH5b5eJo+ds+6ye6xc/oXNY9OqTjaPzUvqPSbfWM7o8XmTnMfGuaEBPFFcNimpOZll
	qUX6dglcGUs2v2IsaFWr6H1ygamBsUmui5GTQ0LARGLezZnsELaYxIV769m6GLk4hASWMUrM
	OnieFabo7eQ/jBCJRYwSu5ecZ4ZwJjNJrFq4A6ydRUBV4vDGb8wgNpuAlsTquccZQWwRAV2J
	/6ffsIA0MAt0sko8fbQNrEFYwF3i3YEJbCA2r4CjxNKZK8DWcQLFz/xoALOFBNwknm/cyghx
	hoXEhaYOdoh6QYkfk++xgNjMQMs2b2tihbDlJTaveQt2nYTAFQ6Jfxv7WCCuE5D4NvkQkM0B
	lJCV2HSAGWKmpMTBFTdYJjCKzUIydhaSsbOQjF3AyLyKUTS1ILmgOCm9yFSvODG3uDQvXS85
	P3cTIyRlTNzBeP+A9SHGZKCVE5mlRJPzgSknryTe0NjMyMLUxNTYyNzSjDRhJXHe9EdJQUIC
	6YklqdmpqQWpRfFFpTmpxYcYmTg4pRoYcw4VWM+c+DHrTLi54Kr6tv/nmx2v9zj/vco2LTJg
	RtpNxfSUqnU3Gubx7z3sGdRxknWneYBZ3c8cy+w5S+dPcmk02cC2gyvmyY34c1uO/zDcYH34
	5+PmWs0f9xOeCDmfuHfacT5v/L7Y2aU58xhZvxlb39tZw36YV65e5idXtwVPj1gP2wleJZbi
	jERDLeai4kQA0ETlxi8DAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrJKsWRmVeSWpSXmKPExsVy+t9jAV11ifJgg31X1Sz+TjrGbtE0dw+j
	xfwj51gt+t8sZLV4deQHk8W5VysZLRbst7bonL2B3WLT42usFpd3zWGzmHF+H5NF55dZbBZ/
	7/xjs1h6/SKTxYTpa1ksWvceYbd4dbCNxeLnrnksFi8/nmBxEPZ4cnAek8eaeWsYPX7/msTo
	MbvhIovH5b5eJo+ds+6ye6xc/oXNY9OqTjaPzUvqPSbfWM7o8XmTnMfGuaEBPFENjDYZqYkp
	qUUKqXnJ+SmZeem2St7B8c7xpmYGhrqGlhbmSgp5ibmptkouPgG6bpk5QD8qKZQl5pQChQIS
	i4uV9O0wTQgNcdO1gGmM0PUNCYLrMTJAAwnrGDOWbH7FWNCqVtH75AJTA2OTXBcjJ4eEgInE
	28l/GCFsMYkL99azdTFycQgJLGKU2L3kPDOEM5lJYtXCHewgVSwCqhKHN35jBrHZBLQkVs89
	DtYtIqAr8f/0GxaQBmaBTlaJp4+2gTUIC7hLvDswgQ3E5hVwlFg6cwUriM0JFD/zowHMFhJw
	k3i+cSvUGRYSF5o62CHqBSV+TL7HAmIzAy3bvK2JFcKWl9i85i3zBEaBWUjKZiEpm4WkbAEj
	8ypG0dSC5ILipPRcI73ixNzi0rx0veT83E2M4IT0THoH46oGi0OMAhyMSjy8HLZlwUKsiWXF
	lbmHGCU4mJVEeE34yoOFeFMSK6tSi/Lji0pzUosPMSYDg2Mis5Rocj4wWeaVxBsam5gZWRqZ
	WRiZmJuTJqwkznuw1TpQSCA9sSQ1OzW1ILUIZgsTB6dUA6PQvtaPSxc4cJqnigZ+Ombz20g1
	7gZ/73t+HUtFZktj8xJXDYn1PWbmkmJLhGf0RGoqpk3JEFoVc0CL+/CZyctj+adF6e/9tnW1
	1YQzLYprHC1+7LvPtff4gpjkWv1NwIhebbjIv1hlR/Oj2pCnG7Wf/tMt286xQXrv6tC6JsMV
	ly5cOWj0RImlOCPRUIu5qDgRAOd6WOyMAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 May 2014 14:23:18 +0200, Thierry Reding wrote:
> From: Thierry Reding <treding@nvidia.com>
> 
> This commit introduces a generic device tree binding for IOMMU devices.
> Only a very minimal subset is described here, but it is enough to cover
> the requirements of both the Exynos System MMU and Tegra SMMU as
> discussed here:
> 
>     https://lkml.org/lkml/2014/4/27/346
> 
> More advanced functionality such as the dma-ranges property can easily
> be added in a backwards-compatible way. In the absence of a dma-ranges
> property it should be safe to default to the whole address space.
> 
> Signed-off-by: Thierry Reding <treding@nvidia.com>
> ---
>  Documentation/devicetree/bindings/iommu/iommu.txt | 109 ++++++++++++++++++++++
>  1 file changed, 109 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/iommu/iommu.txt
> 
> diff --git a/Documentation/devicetree/bindings/iommu/iommu.txt b/Documentation/devicetree/bindings/iommu/iommu.txt
> new file mode 100644
> index 000000000000..2d67b52b656e
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/iommu/iommu.txt
> @@ -0,0 +1,109 @@
> +This document describes the generic device tree binding for IOMMUs and their
> +master(s).
> +
> +
> +IOMMU device node:
> +==================
> +
> +An IOMMU can provide the following services:
> +
> +* Remap address space to allow devices to access physical memory ranges that
> +  they otherwise wouldn't be capable of accessing.
> +
> +  Example: 32-bit DMA to 64-bit physical addresses
> +
> +* Implement scatter-gather at page level granularity so that the device does
> +  not have to.
> +
> +* Provide system protection against "rogue" DMA by forcing all accesses to go
> +  through the IOMMU and faulting when encountering accesses to unmapped
> +  address regions.
> +
> +* Provide address space isolation between multiple contexts.
> +
> +  Example: Virtualization
> +
> +Device nodes compatible with this binding represent hardware with some of the
> +above capabilities.
> +
> +IOMMUs can be single-master or multiple-master. Single-master IOMMU devices
> +typically have a fixed association to the master device, whereas multiple-
> +master IOMMU devices can translate accesses from more than one master.
> +
> +Required properties:
> +--------------------
> +- #iommu-cells: The number of cells in an IOMMU specifier. The meaning of the
> +  cells is defined by the binding for the IOMMU device.
> +
> +  Typical values include:
> +  * 0: Single-master IOMMU devices are often not configurable, therefore the
> +    specifying doesn't need to encode any information and can be empty.
> +
> +  * 1: Multiple-master IOMMU devices need to know for which master they should
> +    enable translation. Typically the single cell in the specifier corresponds
> +    to the master device's ID.
> +
> +
> +IOMMU master node:
> +==================
> +
> +Devices that access memory through an IOMMU are called masters. A device can
> +have multiple master interfaces (to one or more IOMMU devices).
> +
> +Required properties:
> +--------------------
> +- iommus: A list of phandle and IOMMU specifier pairs that describe the IOMMU
> +  master interfaces of the device. One entry in the list describes one master
> +  interface of the device.
> +
> +Optional properties:
> +--------------------
> +- iommu-names: A list of names identifying each entry in the iommus property.
> +
> +
> +Examples:
> +=========
> +
> +Single-master IOMMU:
> +--------------------
> +
> +	iommu {
> +		#iommu-cells = <0>;
> +	};
> +
> +	master {
> +		iommu = <&/iommu>;
> +	};
> +

Great work, Thierry.

One simple comment.

This should be also applicable to multi-master IOMMUs that the masters
of an IOMMU is not configurable with ID or something.
I think the title needs to be changed to cover such IOMMUs which always
translate master's transactions and unable to change the configuration
of the relationship between the masters and IOMMUs by S/W.

Regards,

KyongHo

> +Multi-master IOMMU:
> +-------------------
> +
> +	iommu {
> +		/* the specifier represents the ID of the master */
> +		#iommu-cells = <1>;
> +	};
> +
> +	master {
> +		/* device has master ID 42 in the IOMMU */
> +		iommu = <&/iommu 42>;
> +	};
> +
> +Multi-master device:
> +--------------------
> +
> +	/* single-master IOMMU */
> +	iommu@1 {
> +		#iommu-cells = <0>;
> +	};
> +
> +	/* multi-master IOMMU */
> +	iommu@2 {
> +		/* the specifier represents the ID of the master */
> +		#iommu-cells = <1>;
> +	};
> +
> +	/* device with two master interfaces */
> +	master {
> +		iommus = <&/iommu@1>,    /* master of the single-master IOMMU */
> +			 <&/iommu@2 42>; /* ID 42 in multi-master IOMMU */
> +	};
> -- 
> 1.9.2
> 
