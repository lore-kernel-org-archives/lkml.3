Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754552Ab3GJOCX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 10:02:23 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:42525 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754006Ab3GJOCV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 10:02:21 -0400
Message-ID: <51DD695C.6060209@ti.com>
Date: Wed, 10 Jul 2013 19:32:04 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Jingoo Han <jg1.han@samsung.com>
CC: "'Bjorn Helgaas'" <bhelgaas@google.com>, <linux-pci@vger.kernel.org>,
        <linux-samsung-soc@vger.kernel.org>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        Pratyush Anand <pratyush.anand@st.com>,
        Mohit KUMAR <Mohit.KUMAR@st.com>, "'Arnd Bergmann'" <arnd@arndb.de>,
        "'Sean Cross'" <xobs@kosagi.com>,
        "'SRIKANTH TUMKUR SHIVANAND'" <ts.srikanth@samsung.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] pci: exynos: split into two parts such as Synopsys part
 and Exynos part
References: <000201ce7959$bf0fb150$3d2f13f0$@samsung.com>
In-Reply-To: <000201ce7959$bf0fb150$3d2f13f0$@samsung.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Friday 05 July 2013 01:59 PM, Jingoo Han wrote:
> Exynos PCIe IP consists of Synopsys specific part and Exynos
> specific part. Only core block is a Synopsys designware part;
> other parts are Exynos specific.
> Also, the Synopsys designware part can be shared with other
> platforms; thus, it can be split two parts such as Synopsys
> designware part and Exynos specific part.

Thanks for doing that :-)

I'll be using the synopsys specific part as Jacinto6 also uses the same pcie
core. Once I start implementing, I'll have some queries and comments ;-)

Cheers
Kishon
