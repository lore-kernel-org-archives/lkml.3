Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758060Ab3LWVh1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 16:37:27 -0500
Received: from smtp0.epfl.ch ([128.178.224.218]:46091 "EHLO smtp0.epfl.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758009Ab3LWVhQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 16:37:16 -0500
Message-ID: <52B8A8F1.4040906@epfl.ch>
Date: Mon, 23 Dec 2013 22:19:45 +0100
From: Florian Vaussard <florian.vaussard@epfl.ch>
Reply-To: florian.vaussard@epfl.ch
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: "Anna, Suman" <s-anna@ti.com>, Joerg Roedel <joro@8bytes.org>,
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
Subject: Re: [PATCH 4/7] iommu/omap: Allow enable/disable even without pdata
References: <1387284818-28739-1-git-send-email-florian.vaussard@epfl.ch> <1387284818-28739-5-git-send-email-florian.vaussard@epfl.ch> <52B88990.5020807@ti.com>
In-Reply-To: <52B88990.5020807@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Suman,

On 12/23/2013 08:05 PM, Anna, Suman wrote:
> Hi Florian,
> 
> On 12/17/2013 06:53 AM, Florian Vaussard wrote:
>> When booting with a devietree, no platform data is provided. Do not
>> prematurely
>> exit iommu_enable() and iommu_disable() in such a case.
> 
> Platform data may still be needed if we were to go with the pdata quirks
> approach for handling resets. You may need to revise the patch
> description then, but the change itself may be ok if supporting only DT
> devices.
> 

Indeed, this should be mentioned in the commit message. I would go for
a pdata-quirk until we have a proper reset-controller.

Regards,

Florian
