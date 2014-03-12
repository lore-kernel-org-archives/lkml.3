Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756735AbaCLIbt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 04:31:49 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:34967 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756336AbaCLIba (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 04:31:30 -0400
X-AuditID: cbfee68f-b7f156d00000276c-fd-53201b5e0990
From: Jingoo Han <jg1.han@samsung.com>
To: "'Tanmay Inamdar'" <tinamdar@apm.com>
Cc: "'Bjorn Helgaas'" <bhelgaas@google.com>, "'Arnd Bergmann'" <arnd@arndb.de>,
        "'Jason Gunthorpe'" <jgunthorpe@obsidianresearch.com>,
        "'Grant Likely'" <grant.likely@linaro.org>,
        "'Rob Herring'" <robh+dt@kernel.org>,
        "'Catalin Marinas'" <catalin.marinas@arm.com>,
        "'Rob Landley'" <rob@landley.net>,
        "'Liviu Dudau'" <liviu.dudau@arm.com>, linux-pci@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        patches@apm.com, jcm@redhat.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <1394085963-27553-1-git-send-email-tinamdar@apm.com>
 <1394085963-27553-3-git-send-email-tinamdar@apm.com>
In-reply-to: <1394085963-27553-3-git-send-email-tinamdar@apm.com>
Subject: Re: [PATCH v4 2/4] arm64: dts: APM X-Gene PCIe device tree nodes
Date: Wed, 12 Mar 2014 17:31:25 +0900
Message-id: <000001cf3dcd$751a4680$5f4ed380$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac85ApUGQrzfeo+rRVSeh9WRlRyACgEyVqew
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPKsWRmVeSWpSXmKPExsVy+t8zY904aYVgg/19YhZ/Jx1jt1jSlGHx
	flkPo8X8I+dYLQ782cFoMWntcmaLywsvsVp8v2FqsenxNVaLhW1LWCwu75rDZnF23nE2iwNL
	21ksms98Y7NY93I6i0Xr3iPsFs8/fWJxEPT4uP4To8eaeWsYPX7/msTosWBTqcemVZ1sHq9W
	z2T1uHNtD5vH5iX1Ht939DJ6vN93lc2jb8sqRo/Pm+QCeKK4bFJSczLLUov07RK4MvbM381U
	cIu3YsWBV+wNjH1cXYycHBICJhKT7q9nhrDFJC7cW8/WxcjFISSwjFFi759PzDBFp1/fZASx
	hQSmM0qcX8oDYf9mlFjWbgBiswmoSXz5cpi9i5GDQ0RAXWL3FBmQMLPAShaJu6f1IcrLJRb2
	bGcDKeEUcJTYtSgTJCws4CmxfOUKdhCbRUBVom3xDLCtvAK2En1dT9ghbEGJH5PvsUCM1JJY
	v/M4E4QtL7F5zVtmkJESQFsf/dUFCYsIGEksPvSIGaJERGLfi3eMIF9JCDzgkNi47CoLxC4B
	iW+TD7FA9MpKbDoA9aykxMEVN1gmMErMQrJ5FpLNs5BsnoVkxQJGllWMoqkFyQXFSelFxnrF
	ibnFpXnpesn5uZsYIYmlfwfj3QPWhxiTgdZPZJYSTc4HJqa8knhDYzMjC1MTU2Mjc0sz0oSV
	xHnvP0wKEhJITyxJzU5NLUgtii8qzUktPsTIxMEp1cDo+XlpYO2WT2qtJ4pmHiytZxGxPi8y
	xzj2rNDHf4Wd7xj2rzZNf9Au2bjx6uwTBg0cCe6HVwh+ubXkwfOIqdN89i1gzHp4JF5WKLKG
	37omm+nflGStBY8ktj3nec268r7JeZuMRPMUtXOWrnMXRH375cIhyrrwG+8e48V9K86Y2WTZ
	HXr7ROCjEktxRqKhFnNRcSIAfnyDbUIDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphk+LIzCtJLcpLzFFi42I5/e+xoG6ctEKwwdqn/BZ/Jx1jt1jSlGHx
	flkPo8X8I+dYLQ782cFoMWntcmaLywsvsVp8v2FqsenxNVaLhW1LWCwu75rDZnF23nE2iwNL
	21ksms98Y7NY93I6i0Xr3iPsFs8/fWJxEPT4uP4To8eaeWsYPX7/msTosWBTqcemVZ1sHq9W
	z2T1uHNtD5vH5iX1Ht939DJ6vN93lc2jb8sqRo/Pm+QCeKIaGG0yUhNTUosUUvOS81My89Jt
	lbyD453jTc0MDHUNLS3MlRTyEnNTbZVcfAJ03TJzgB5TUihLzCkFCgUkFhcr6dthmhAa4qZr
	AdMYoesbEgTXY2SABhLWMWbsmb+bqeAWb8WKA6/YGxj7uLoYOTkkBEwkTr++yQhhi0lcuLee
	DcQWEpjOKHF+KQ+E/ZtRYlm7AYjNJqAm8eXLYfYuRg4OEQF1id1TZEDCzAIrWSTuntaHKC+X
	WNiznQ2khFPAUWLXokyQsLCAp8TylSvYQWwWAVWJtsUzmEFsXgFbib6uJ+wQtqDEj8n3WCBG
	akms33mcCcKWl9i85i0zyEgJoK2P/uqChEUEjCQWH3rEDFEiIrHvxTvGCYxCs5BMmoVk0iwk
	k2YhaVnAyLKKUTS1ILmgOCk910ivODG3uDQvXS85P3cTIzhtPZPewbiqweIQowAHoxIP70JN
	+WAh1sSy4srcQ4wSHMxKIrxCIgrBQrwpiZVVqUX58UWlOanFhxiTgR6dyCwlmpwPTKl5JfGG
	xiZmRpZGZhZGJubmpAkrifMebLUOFBJITyxJzU5NLUgtgtnCxMEp1cDIJKcX1Hx8z7PAkGVn
	5lonzDjedEvl5/GFV7zmLG/9m/4jRiXbe0XY+XjRVYdWZp/eXFS7/c/ELV3zqyJrwtlqDoXF
	vTrhyH0hKSUo2LzBYdFMw+R5ETxLA2/GlMy8d+PWxNVB5XETchOlU1W5rwZ431BU2XKKM+ep
	0B/uc6Lr/sUx9LSfXv5UiaU4I9FQi7moOBEA9T0bkJ8DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, March 06, 2014 3:06 PM, Tanmay Inamdar wrote:
> 
> This patch adds the device tree nodes for APM X-Gene PCIe controller and
> PCIe clock interface. Since X-Gene SOC supports maximum 5 ports, 5 dts
> nodes are added.
> 
> Signed-off-by: Tanmay Inamdar <tinamdar@apm.com>
> ---
>  arch/arm64/boot/dts/apm-mustang.dts |    8 ++
>  arch/arm64/boot/dts/apm-storm.dtsi  |  155 +++++++++++++++++++++++++++++++++++
>  2 files changed, 163 insertions(+)

[.....]

> --- a/arch/arm64/boot/dts/apm-storm.dtsi
> +++ b/arch/arm64/boot/dts/apm-storm.dtsi

[.....]

> +
> +		pcie0: pcie@1f2b0000 {
> +			status = "disabled";
> +			device_type = "pci";
> +			compatible = "apm,xgene-storm-pcie", "apm,xgene-pcie";
> +			#interrupt-cells = <1>;
> +			#size-cells = <2>;
> +			#address-cells = <3>;
> +			reg = < 0x00 0x1f2b0000 0x0 0x00010000   /* Controller registers */
> +				0xe0 0xd0000000 0x0 0x00200000>; /* PCI config space */
> +			reg-names = "csr", "cfg";
> +			ranges = <0x01000000 0x00 0x00000000 0xe0 0x00000000 0x00 0x00010000   /* io */
> +				  0x02000000 0x00 0x10000000 0xe0 0x10000000 0x00 0x80000000>; /* mem */
                                                                          ^^^

I have a question about the fourth number '0xe0' of 'ranges' property.
Would you let me know what the '0xe0' means?

Best regards,
Jingoo Han

> +			dma-ranges = <0x42000000 0x40 0x00000000 0x40 0x00000000 0x40 0x00000000>;
> +			interrupt-map-mask = <0x0 0x0 0x0 0x7>;
> +			interrupt-map = <0x0 0x0 0x0 0x1 &gic 0x0 0xc2 0x1
> +					 0x0 0x0 0x0 0x2 &gic 0x0 0xc3 0x1
> +					 0x0 0x0 0x0 0x3 &gic 0x0 0xc4 0x1
> +					 0x0 0x0 0x0 0x4 &gic 0x0 0xc5 0x1>;
> +			clocks = <&pcie0clk 0>;
> +		};

