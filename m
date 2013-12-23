Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758284Ab3LWX3E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 18:29:04 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:37051 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752817Ab3LWX3B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 18:29:01 -0500
Message-ID: <52B8C70D.3040103@ti.com>
Date: Mon, 23 Dec 2013 17:28:13 -0600
From: "Anna, Suman" <s-anna@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: <florian.vaussard@epfl.ch>, Joerg Roedel <joro@8bytes.org>,
        Tony Lindgren <tony@atomide.com>,
        =?ISO-8859-1?Q?Beno=EEt_Cousson?= <bcousson@baylibre.com>
CC: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Grant Likely <grant.likely@linaro.org>,
        Hiroshi Doyu <hdoyu@nvidia.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 6/7] ARM: OMAP2+: Remove legacy data from hwmod for omap3
 isp iommu
References: <1387284818-28739-1-git-send-email-florian.vaussard@epfl.ch> <1387284818-28739-7-git-send-email-florian.vaussard@epfl.ch> <52B88A49.9020402@ti.com> <52B8ACED.1030209@epfl.ch>
In-Reply-To: <52B8ACED.1030209@epfl.ch>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Florian,

 >>
>> On 12/17/2013 06:53 AM, Florian Vaussard wrote:
>>> The data are now passed using the devicetree.
>>
>> Patch is good by itself. A similar change is needed for the IVA
>> MMU as well.
>>
>
> As I understood, the IVA MMU is still not integrated into the iommu
> core, as its implementation lives under staging/tidspbridge/. But
> correct me if I am wrong.
>

Yes, that is correct. That shouldn't stop us though from adding the IVA 
MMU node to the DT file and the associated cleanup. To begin with, we 
can have the DT node added with status=disabled.

regards
Suman

