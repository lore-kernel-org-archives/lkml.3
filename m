Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755624AbaGVMSS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 08:18:18 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:59367 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755237AbaGVMSQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 08:18:16 -0400
Message-ID: <53CE5663.3020100@ti.com>
Date: Tue, 22 Jul 2014 17:47:39 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-pci@vger.kernel.org>, <jg1.han@samsung.com>,
        <bhelgaas@google.com>, <mohit.kumar@st.com>,
        <linux-kernel@vger.kernel.org>
CC: <grant.likely@linaro.org>
Subject: Re: [PATCH v3 0/4] dra7: Add PCIe support
References: <1405587643-13808-1-git-send-email-kishon@ti.com>
In-Reply-To: <1405587643-13808-1-git-send-email-kishon@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bjorn,

On Thursday 17 July 2014 02:30 PM, Kishon Vijay Abraham I wrote:
> Changes from v2:
> * Added myself as MAINTAINER of pcie dra7xx driver
> 
> Changes from v1:
> * fixed dw_pcie_prog_viewport_io_outbound() to use untranslated address
> * split dra7xx patch into driver part and documentation part
> 
> [1] is split into separate series in order for individual subsystem
> Maintainers to pick up the patches. This series handles the PCIe
> support for DRA7.
> 
> Rebased to pci -next.
> 
> [1] -> https://lkml.org/lkml/2014/5/29/258

I tried to get Acks for the DT documentation from DT maintainers but couldn't.
I'd assume they would have reverted if they had any concerns. Moreover the dt
documentation for DRA7xx is just an extension of the dt documentation for
designware. And since Pratyush, Jingoo, Mohit seems to be okay with this patch
series, can we get this series merged?

Cheers
Kishon
