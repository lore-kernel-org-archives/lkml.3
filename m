Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933652AbaH0MxL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 08:53:11 -0400
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:36391 "EHLO
	mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933391AbaH0MxJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 08:53:09 -0400
Message-ID: <53FDD4A4.5020603@st.com>
Date: Wed, 27 Aug 2014 14:52:52 +0200
From: Giuseppe CAVALLARO <peppe.cavallaro@st.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Kweh Hock Leong <hock.leong.kweh@intel.com>,
        "David S. Miller" <davem@davemloft.net>
Cc: <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Rayagond K <rayagond@vayavyalabs.com>
Subject: Re: [PATCH 0/4] net: stmmac: Enable Intel Quark SoC X1000 Ethernet
 support
References: <cover.1409123378.git.hock.leong.kweh@intel.com>
In-Reply-To: <cover.1409123378.git.hock.leong.kweh@intel.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.52.138.46]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.27,0.0.0000
 definitions=2014-08-27_05:2014-08-27,2014-08-27,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/27/2014 12:32 PM, Kweh Hock Leong wrote:
> From: "Kweh, Hock Leong" <hock.leong.kweh@intel.com>
>
> Hi,
>
> Intel Quark X1000 SoC has 2 Ethernet controllers integrated on chip and they are
> PCI devices. We adopted the stmmac_pci driver and added on code to support Intel
> Quark SoC X1000 by creating the patchset below. The patchset has been built and
> tested on Galileo board and found to be working as expected.
>
> We believe that the changes are transparent to other non Intel Quark platform.
> Please help to review the code change and feedback if there is any concern.

hello and thx for these patches that at first glance look ok to me.
Just some minor remark, in the stmmac I try to align the function 
parameters with the open parenthesis (devm_kzalloc in your case in not 
aligned).
Added on copy also Rayagond he tested PCI. I cannot do any test because 
I have no PCI cards.

peppe

>
> Thank you very much.
>
> Kweh, Hock Leong (4):
>    net: stmmac: enhance to support multiple device instances
>    net: stmmac: better code manageability with platform data struct
>    net: stmmac: add support for Intel Quark X1000
>    net: stmmac: add MSI support for Intel Quark X1000
>
>   drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c |  195 +++++++++++++++++++---
>   1 file changed, 172 insertions(+), 23 deletions(-)
>

