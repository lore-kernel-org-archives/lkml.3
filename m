Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932237AbaFBUoc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 16:44:32 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:50101 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752641AbaFBUoa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 16:44:30 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Kumar Gala <galak@codeaurora.org>
Cc: Grant Likely <grant.likely@linaro.org>, Liviu Dudau <Liviu.Dudau@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Rob Herring <robherring2@gmail.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Kishon Vijay Abraham I <kishon@ti.com>
Subject: Re: [PATCH 1/2] pci: Add IORESOURCE_BIT entry for PCIe ECAM resources.
Date: Mon, 02 Jun 2014 22:44:19 +0200
Message-ID: <5976198.MmsV3dNjlq@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <95C66A63-9671-4AD5-9804-6647A305DB99@codeaurora.org>
References: <20140530233034.GH1677@bart.dudau.co.uk> <4495090.ktpdXEyibD@wuerfel> <95C66A63-9671-4AD5-9804-6647A305DB99@codeaurora.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:w8v4E/yxQTdAhYdwJ6Npnz9QomRs4MIq7gjmGzy4jOR
 WGExJvjyhBKNEaWYB1sCLlbg25PHbC3CNcgrWfdh92RbFSbv6L
 GZByDhznIY5Zf20SNxLEdcEXg2uAM0WWBJCH5GIVFopNXIzIft
 NnaaHxKzWbej19JeZOYLpSbCtpQiVeVimQAqqLIlRdz9yZuGJO
 98B9Ga6pmLTYJgrCLfn2Y8wTvxGArC+qLFMucUdCq69oWlPkd6
 U40qrAddQBFiE20IUg7T9ejAadewE7PypUSaHjMUuOOsMqpFM9
 FakGUl52zfCFTj8IuGn+ugYb7qSYnCF9wYuegaPYeXAAMs+q6T
 jMSX1lK4gf+JdmyhXNuQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 02 June 2014 15:43:02 Kumar Gala wrote:
> Its imx6 and exynos, havent looked to see if dw-pcie is handling
> the parsing or not for them.

Ok, so they are both dw-pcie variants.

	Arnd 

