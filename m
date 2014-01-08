Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756765AbaAHSun (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 13:50:43 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:36251 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751008AbaAHSuk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 13:50:40 -0500
Message-ID: <52CD9DFB.9010007@wwwdotorg.org>
Date: Wed, 08 Jan 2014 11:50:35 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>
CC: Peter De Schrijver <pdeschrijver@nvidia.com>,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, devicetree@vger.kernel.org
Subject: Re: [PATCH v2 3/6] ARM: tegra: Add efuse bindings
References: <1387891931-9854-1-git-send-email-pdeschrijver@nvidia.com> <1387891931-9854-4-git-send-email-pdeschrijver@nvidia.com> <52CB14D3.2060904@wwwdotorg.org> <20140108133951.GD1592@ulmo.nvidia.com>
In-Reply-To: <20140108133951.GD1592@ulmo.nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/08/2014 06:39 AM, Thierry Reding wrote:
> On Mon, Jan 06, 2014 at 01:40:51PM -0700, Stephen Warren wrote:
>> On 12/24/2013 06:32 AM, Peter De Schrijver wrote:
> [...]
>>> diff --git a/arch/arm/boot/dts/tegra20.dtsi b/arch/arm/boot/dts/tegra20.dtsi
>>
>>> +	efuse@7000F800 {
>>
>> "fuse" might be a better node name; "efuse" is presumably the name of
>> the instance, not the type of object.
> 
> There's another occurrence I noticed recently where we haven't followed
> that rule. The PMIC node on Venice2 for instance is called as3722.
> Perhaps that should also be renamed.

Yes, we should fix that. Care to send a patch?

