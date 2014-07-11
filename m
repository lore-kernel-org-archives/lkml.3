Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753587AbaGKHn3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 03:43:29 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:33668 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753349AbaGKHnX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 03:43:23 -0400
X-AuditID: cbfee68e-b7fb96d000004bfc-55-53bf959983e4
From: Jingoo Han <jg1.han@samsung.com>
To: "'Liviu Dudau'" <Liviu.Dudau@arm.com>
Cc: "'linux-pci'" <linux-pci@vger.kernel.org>,
        "'Bjorn Helgaas'" <bhelgaas@google.com>,
        "'Catalin Marinas'" <Catalin.Marinas@arm.com>,
        "'Will Deacon'" <Will.Deacon@arm.com>,
        "'Benjamin Herrenschmidt'" <benh@kernel.crashing.org>,
        "'Arnd Bergmann'" <arnd@arndb.de>,
        "'linaro-kernel'" <linaro-kernel@lists.linaro.org>,
        "'Tanmay Inamdar'" <tinamdar@apm.com>,
        "'Grant Likely'" <grant.likely@secretlab.ca>,
        "'Sinan Kaya'" <okaya@codeaurora.org>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Suravee Suthikulanit'" <suravee.suthikulpanit@amd.com>,
        "'LKML'" <linux-kernel@vger.kernel.org>,
        "'Device Tree ML'" <devicetree@vger.kernel.org>,
        "'LAKML'" <linux-arm-kernel@lists.infradead.org>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <1404240214-9804-1-git-send-email-Liviu.Dudau@arm.com>
 <1404240214-9804-9-git-send-email-Liviu.Dudau@arm.com>
In-reply-to: <1404240214-9804-9-git-send-email-Liviu.Dudau@arm.com>
Subject: Re: [PATCH v8 8/9] pci: Add support for creating a generic host_bridge
 from device tree
Date: Fri, 11 Jul 2014 16:43:21 +0900
Message-id: <004601cf9cdb$ca08f7f0$5e1ae7d0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac+VXH1fDZvKLuATQz24Iuyh7TFKYQHful/A
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrIKsWRmVeSWpSXmKPExsVy+t8zQ92ZU/cHG0zdLmXxd9IxdosPTa3M
	FkuaMizeL+thtJh/5ByrxaszG9ksLi+8xGrRu+Aqm8X7Q8+YLTY9vsZqcXnXHDaLs/OOs1kc
	WNrOYtE4aRuTxcQfCxgtnn/6xGLx8uMJFgdBj9ZLf9k8Pq7/xOixZt4aRo/fvyYxelzu62Xy
	WLCp1KPnTQurx+Yl9R63/z1m9ujbsorR4+dLHY/Pm+QCeKK4bFJSczLLUov07RK4MmYsmMBc
	0CRaMXkfVwPjL4EuRk4OCQETiYnXP7FB2GISF+6tB7K5OIQEljFKvNlxlRGmqOPcY0aIxHRG
	iTXvTrFCOL8ZJc7OmQfWziagJvHly2F2EFtEQF3i7pNjLCBFzALHWCX6Lm8CGyUkUC3RsPER
	UBEHB6eAs8T1PVkgprBAksSG7VUgFSwCqhLzJ0xiBrF5BWwlNsxvY4ewBSV+TL7HAmIzC2hJ
	rN95nAnClpfYvOYtM8gYCaC1j/7qQlxgJLGrZyMzRImIxL4X78DulxB4wiGxbNEeJohdAhLf
	Jh9igeiVldh0gBniX0mJgytusExglJiFZPMsJJtnIdk8C8mKBYwsqxhFUwuSC4qT0ouM9IoT
	c4tL89L1kvNzNzFCkkvfDsabB6wPMSYDrZ/ILCWanA9MTnkl8YbGZkYWpiamxkbmlmakCSuJ
	8y56mBQkJJCeWJKanZpakFoUX1Sak1p8iJGJg1OqgbFt1+MTtoE8Kv07lu+w3pRsv36a8tJa
	5kZ113M7z9w+vSnM7JSO8v6WV66+gWva90253PDh0c3jk2z1ma4UeS4LmPWx8bGv56GZRoUL
	VjNcCs9aqZV561Tu9cUHdwumL5jAfmjd0v2LXr9YK5hhZxTJqM6573y/+vK/vByz9K9wX656
	suuFVpCuEktxRqKhFnNRcSIAfOwulkQDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrAKsWRmVeSWpSXmKPExsVy+t9jQd2ZU/cHGyyfIWrxd9IxdosPTa3M
	FkuaMizeL+thtJh/5ByrxaszG9ksLi+8xGrRu+Aqm8X7Q8+YLTY9vsZqcXnXHDaLs/OOs1kc
	WNrOYtE4aRuTxcQfCxgtnn/6xGLx8uMJFgdBj9ZLf9k8Pq7/xOixZt4aRo/fvyYxelzu62Xy
	WLCp1KPnTQurx+Yl9R63/z1m9ujbsorR4+dLHY/Pm+QCeKIaGG0yUhNTUosUUvOS81My89Jt
	lbyD453jTc0MDHUNLS3MlRTyEnNTbZVcfAJ03TJzgB5TUihLzCkFCgUkFhcr6dthmhAa4qZr
	AdMYoesbEgTXY2SABhLWMWbMWDCBuaBJtGLyPq4Gxl8CXYycHBICJhId5x4zQthiEhfurWfr
	YuTiEBKYziix5t0pVgjnN6PE2Tnz2ECq2ATUJL58OcwOYosIqEvcfXKMBaSIWeAYq0Tf5U1g
	o4QEqiUaNj4CKuLg4BRwlri+JwvEFBZIktiwvQqkgkVAVWL+hEnMIDavgK3Ehvlt7BC2oMSP
	yfdYQGxmAS2J9TuPM0HY8hKb17xlBhkjAbT20V9diAuMJHb1bGSGKBGR2PfiHeMERqFZSCbN
	QjJpFpJJs5C0LGBkWcUomlqQXFCclJ5rpFecmFtcmpeul5yfu4kRnLqeSe9gXNVgcYhRgINR
	iYf3xJp9wUKsiWXFlbmHGCU4mJVEeJ/U7w8W4k1JrKxKLcqPLyrNSS0+xGgK9OhEZinR5Hxg
	Ws0riTc0NjEzsjQyszAyMTdXEuc92GodKCSQnliSmp2aWpBaBNPHxMEp1cBo/pfRXjHm19cL
	QtvmiFxt+HX0xzHFKZP9duZzua6wD3NK3bVx+1WXw2qv1rE9vCPEwmT+noXhO7O5h+UdO4Uk
	r7DFi7o3nwqzrzfP8G6MYDPcHxP/+uRqxc/La7gYlsS+ufHJ6uFC3bJ5GaU7UzddPJuky5u1
	7qFOp433N8PXsRuSHfapPmhWYinOSDTUYi4qTgQAbZWYaHMDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, July 02, 2014 3:44 AM, Liviu Dudau wrote:
> 
> Several platforms use a rather generic version of parsing
> the device tree to find the host bridge ranges. Move the common code
> into the generic PCI code and use it to create a pci_host_bridge
> structure that can be used by arch code.
> 
> Based on early attempts by Andrew Murray to unify the code.
> Used powerpc and microblaze PCI code as starting point.
> 
> Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>
> Tested-by: Tanmay Inamdar <tinamdar@apm.com>
> ---
>  drivers/of/of_pci.c       | 135 ++++++++++++++++++++++++++++++++++++++++++++++
>  drivers/pci/host-bridge.c |  18 +++++++
>  include/linux/of_pci.h    |  10 ++++
>  include/linux/pci.h       |   8 +++
>  4 files changed, 171 insertions(+)
> 
> diff --git a/drivers/of/of_pci.c b/drivers/of/of_pci.c
> index 8481996..55d8320 100644
> --- a/drivers/of/of_pci.c
> +++ b/drivers/of/of_pci.c

[.....]

> +struct pci_host_bridge *
> +of_create_pci_host_bridge(struct device *parent, struct pci_ops *ops, void *host_data)
> +{
> +	int err, domain, busno;
> +	struct resource *bus_range;
> +	struct pci_bus *root_bus;
> +	struct pci_host_bridge *bridge;
> +	resource_size_t io_base;
> +	LIST_HEAD(res);
> +
> +	bus_range = kzalloc(sizeof(*bus_range), GFP_KERNEL);
> +	if (!bus_range)
> +		return ERR_PTR(-ENOMEM);
> +
> +	domain = of_alias_get_id(parent->of_node, "pci-domain");
> +	if (domain == -ENODEV)
> +		domain = atomic_inc_return(&domain_nr);
> +
> +	err = of_pci_parse_bus_range(parent->of_node, bus_range);
> +	if (err) {
> +		dev_info(parent, "No bus range for %s, using default [0-255]\n",
> +			parent->of_node->full_name);
> +		bus_range->start = 0;
> +		bus_range->end = 255;
> +		bus_range->flags = IORESOURCE_BUS;
> +	}
> +	busno = bus_range->start;
> +	pci_add_resource(&res, bus_range);
> +
> +	/* now parse the rest of host bridge bus ranges */
> +	err = pci_host_bridge_of_get_ranges(parent->of_node, &res, &io_base);
> +	if (err)
> +		goto err_create;
> +
> +	/* then create the root bus */
> +	root_bus = pci_create_root_bus_in_domain(parent, domain, busno,
> +						ops, host_data, &res);
> +	if (IS_ERR(root_bus)) {
> +		err = PTR_ERR(root_bus);
> +		goto err_create;
> +	}
> +
> +	bridge = to_pci_host_bridge(root_bus->bridge);
> +	bridge->io_base = io_base;

Hi Liviu Dudau,

Would you fix the following warning?

drivers/of/of_pci.c: In function 'of_create_pci_host_bridge'
drivers/of/of_pci.c:218:18: warning: 'of_base' may be used uninitialized in this function [-Wmaybe-uninitialized]
  bridge->io_base = io_base;

Best regards,
Jingoo Han

[.....]

