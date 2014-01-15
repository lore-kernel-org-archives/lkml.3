Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752872AbaAOSiU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 13:38:20 -0500
Received: from smtp0.epfl.ch ([128.178.224.218]:59331 "EHLO smtp0.epfl.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752665AbaAOSiC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 13:38:02 -0500
Message-ID: <52D6C25D.8050005@epfl.ch>
Date: Wed, 15 Jan 2014 18:16:13 +0100
From: Florian Vaussard <florian.vaussard@epfl.ch>
Reply-To: florian.vaussard@epfl.ch
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Joerg Roedel <joro@8bytes.org>, Tony Lindgren <tony@atomide.com>,
        =?UTF-8?B?QmVub8OudCBDb3Vzc29u?= <bcousson@baylibre.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Grant Likely <grant.likely@linaro.org>,
        Hiroshi Doyu <hdoyu@nvidia.com>, iommu@lists.linux-foundation.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 3/7] iommu/omap: Convert to devicetree
References: <1387284818-28739-1-git-send-email-florian.vaussard@epfl.ch> <1387284818-28739-4-git-send-email-florian.vaussard@epfl.ch> <1764051.JiGg1d3s1L@avalon> <20140102010150.GA9933@earth.universe>
In-Reply-To: <20140102010150.GA9933@earth.universe>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On 01/02/2014 02:01 AM, Sebastian Reichel wrote:
> Hi,
> 
> On Thu, Jan 02, 2014 at 01:13:42AM +0100, Laurent Pinchart wrote:
>>> +		.of_match_table = omap_iommu_of_match,
>>
>> If CONFIG_OF isn't defined (pretty unlikely I agree, but a possibility you 
>> seem to be prepared for nonetheless given the above #if), this will fail to 
>> compile.
> 
> FYI: This is avoided in other drivers by using
> of_match_ptr(omap_iommu_of_match), which is replaced with NULL by
> the preprocessor if CONFIG_OF is not defined.
> 

Thank you for the hint.

Florian
