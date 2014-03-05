Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756462AbaCEBUf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 20:20:35 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:36793 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753625AbaCEBUc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 20:20:32 -0500
X-AuditID: cbfee68e-b7f566d000002344-83-53167bddb4b6
From: Jingoo Han <jg1.han@samsung.com>
To: "'Liviu Dudau'" <Liviu.Dudau@arm.com>
Cc: "'linux-pci'" <linux-pci@vger.kernel.org>,
        "'Bjorn Helgaas'" <bhelgaas@google.com>,
        "'Catalin Marinas'" <Catalin.Marinas@arm.com>,
        "'Will Deacon'" <Will.Deacon@arm.com>,
        "'linaro-kernel'" <linaro-kernel@lists.linaro.org>,
        "'Benjamin Herrenschmidt'" <benh@kernel.crashing.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>, devicetree@vger.kernel.org,
        "'LAKML'" <linux-arm-kernel@lists.infradead.org>,
        "'Tanmay Inamdar'" <tinamdar@apm.com>,
        "'Arnd Bergmann'" <arnd@arndb.de>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <1393948204-11555-1-git-send-email-Liviu.Dudau@arm.com>
 <1393948204-11555-8-git-send-email-Liviu.Dudau@arm.com>
In-reply-to: <1393948204-11555-8-git-send-email-Liviu.Dudau@arm.com>
Subject: Re: [PATCH v5 7/7] pci: Add support for creating a generic host_bridge
 from device tree
Date: Wed, 05 Mar 2014 10:20:28 +0900
Message-id: <001f01cf3811$18463ed0$48d2bc70$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac83whTZl7lEQGipQqi5XfkvXVc3nwATmJyw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprEKsWRmVeSWpSXmKPExsVy+t8zQ9271WLBBseXGVj8nXSM3eJDUyuz
	xZKmDIv3y3oYLeYfOcdqcXnhJVaL94eeMVtsenwNyN01h83i7LzjbBYHlrazWDz/9InF4uXH
	EywOvB4f139i9Fgzbw2jx+9fkxg9Fmwq9eh508LqsXlJvcftf4+ZPfq2rGL0+LxJLoAzissm
	JTUnsyy1SN8ugSvjeccc9oKdvBUdJz4xNzB+4epi5OSQEDCRmPRlGTOELSZx4d56ti5GLg4h
	gWWMEndvnGWBKbo+/w8jRGI6o8T/uc9YIZzfjBIvpk9lAqliE1CT+PLlMDuILSKgLnH3yTEW
	kCJmgV/MEh0Ht4AVCQnUSpxo2sEGYnMKuEjsWz0dzBYWSJKY/e4S2B0sAqoST05PBbN5BWwl
	uhYtY4ewBSV+TL4HdhKzgJbE+p3HmSBseYnNa94C1XMAnaou8eivLsQNRhIPJ/1lhygRkdj3
	4h3YBxICWzgkls5bygaxS0Di2+RDLBC9shKbDkCDQlLi4IobLBMYJWYh2TwLyeZZSDbPQrJi
	ASPLKkbR1ILkguKk9CIjveLE3OLSvHS95PzcTYyQ9NC3g/HmAetDjMlA6ycyS4km5wPTS15J
	vKGxmZGFqYmpsZG5pRlpwkrivIseJgUJCaQnlqRmp6YWpBbFF5XmpBYfYmTi4JRqYPR5+ta2
	pMXa42CKVsuquvxtS0pecUX9sHWNuDPh4OSc8PU3Uxn2/5hlLnI70rZqu8qanV2hh9h/lITf
	2/AiVPf7Ddb85+Lfpy6Qf8ZzmuXYv88+6twF9844TigN9ZBf/kT5WZRMhQjDQvHahaetelwW
	TmOcX8jjcmXh5WOck/x2CMzQfSe4XFmJpTgj0VCLuag4EQBgYgS+JQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrPKsWRmVeSWpSXmKPExsVy+t9jQd271WLBBhP7tS3+TjrGbvGhqZXZ
	YklThsX7ZT2MFvOPnGO1uLzwEqvF+0PPmC02Pb4G5O6aw2Zxdt5xNosDS9tZLJ5/+sRi8fLj
	CRYHXo+P6z8xeqyZt4bR4/evSYweCzaVevS8aWH12Lyk3uP2v8fMHn1bVjF6fN4kF8AZ1cBo
	k5GamJJapJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQN0tpJCWWJO
	KVAoILG4WEnfDtOE0BA3XQuYxghd35AguB4jAzSQsI4x43nHHPaCnbwVHSc+MTcwfuHqYuTk
	kBAwkbg+/w8jhC0mceHeerYuRi4OIYHpjBL/5z5jhXB+M0q8mD6VCaSKTUBN4suXw+wgtoiA
	usTdJ8dYQIqYBX4xS3Qc3AJWJCRQK3GiaQcbiM0p4CKxb/V0MFtYIEli9rtLzCA2i4CqxJPT
	U8FsXgFbia5Fy9ghbEGJH5PvsYDYzAJaEut3HmeCsOUlNq95C1TPAXSqusSjv7oQNxhJPJz0
	lx2iRERi34t3jBMYhWYhmTQLyaRZSCbNQtKygJFlFaNoakFyQXFSeq6RXnFibnFpXrpecn7u
	JkZw8nkmvYNxVYPFIUYBDkYlHt4XHGLBQqyJZcWVuYcYJTiYlUR4Y7SBQrwpiZVVqUX58UWl
	OanFhxiTgR6dyCwlmpwPTIx5JfGGxiZmRpZGZhZGJubmpAkrifMebLUOFBJITyxJzU5NLUgt
	gtnCxMEp1cCoPG/WIUXRKOvFr6bt+VajcmR/uuyf5zEZr/w7Ft3NEJyd2G5QxiTDM1lguc7B
	ePudeyQWa+1antYWt+ilvmvJiaJFpc0cFzUVjnp5bZSOsFsvyMit9fR91/Llysq6BaK7rl25
	u+z1v2cCLJ+e+fkx7EkI587/tHdXdlua2goRXjtR9uxckXIlluKMREMt5qLiRAA2oIUpggMA	AA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, March 05, 2014 12:50 AM, Liviu Dudau wrote:
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
> 
> diff --git a/drivers/pci/host-bridge.c b/drivers/pci/host-bridge.c
> index 8708b652..800678a 100644
> --- a/drivers/pci/host-bridge.c
> +++ b/drivers/pci/host-bridge.c

[.....]

> +		res = kzalloc(sizeof(struct resource), GFP_KERNEL);

It makes build error with exynos_defconfig. (ARM32)
Thus, 'slab.h' is necessary in order to fix the build error.

./drivers/pci/host-bridge.c
@@ -8,6 +8,7 @@
 #include <linux/module.h>
 #include <linux/of_address.h>
 #include <linux/of_pci.h>
+#include <linux/slab.h>

 #include "pci.h"


> +		if (!res) {
> +			err = -ENOMEM;
> +			goto bridge_ranges_nomem;
> +		}
> +
> +		of_pci_range_to_resource(&range, dev, res);
> +
> +		if (resource_type(res) == IORESOURCE_IO)
> +			*io_base = range.cpu_addr;
> +
> +		pci_add_resource_offset(resources, res,
> +				res->start - range.pci_addr);
> +	}
> +
> +	/* Apply architecture specific fixups for the ranges */
> +	pcibios_fixup_bridge_ranges(resources);

It also makes compile problem with exynos_defconfig as below:

drivers/built-in.o: In function `pci_host_bridge_of_get_ranges':
drivers/pci/host-bridge.c:157: undefined reference to `pcibios_fixup_bridge_ranges'

Best regards,
Jingoo Han

