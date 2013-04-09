Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936406Ab3DIPqO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 11:46:14 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:38917 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932898Ab3DIPqK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 11:46:10 -0400
Message-ID: <516437BC.8060707@wwwdotorg.org>
Date: Tue, 09 Apr 2013 09:46:04 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Jay Agarwal <jagarwal@nvidia.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "thierry.reding@avionic-design.de" <thierry.reding@avionic-design.de>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "olof@lixom.net" <olof@lixom.net>, Hiroshi Doyu <hdoyu@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        "mturquette@linaro.org" <mturquette@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Juha Tukkinen <jtukkinen@nvidia.com>,
        Krishna Thota <kthota@nvidia.com>
Subject: Re: [PATCH 2/3] ARM: dts: tegra: Correct PCIe entry
References: <1365435688-4179-1-git-send-email-jagarwal@nvidia.com> <1365435688-4179-2-git-send-email-jagarwal@nvidia.com> <51630BF4.6000605@wwwdotorg.org> <20130409083050.GQ3572@tbergstrom-lnx.Nvidia.com>
In-Reply-To: <20130409083050.GQ3572@tbergstrom-lnx.Nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/09/2013 02:30 AM, Peter De Schrijver wrote:
> On Mon, Apr 08, 2013 at 08:27:00PM +0200, Stephen Warren wrote:
>> On 04/08/2013 09:41 AM, Jay Agarwal wrote:
>>> Signed-off-by: Jay Agarwal <jagarwal@nvidia.com>
>>
>> Your s-o-b line should be below the patch description, not above it.
>> Please see Documentation/SubmittingPatches.
>>
>> I also don't see a --- line between the patch description and diffstat.
>> How are you generating these patch emails? Please see our internal wiki,
>> or other git documentation.
>>
>>> diff --git a/arch/arm/boot/dts/tegra30.dtsi b/arch/arm/boot/dts/tegra30.dtsi
>>
>>> -		clock-names = "pex", "afi", "pcie_xclk", "pll_e", "cml";
>>> +		clock-names = "pex", "afi", "pcie_xclk", "pll_e", "cml0";
>>
>> Can you please explain more about this change?
>>
>> I see the Tegra clock driver provides both a "cml0" and a "cml1" clock.
>> Are both of those used for PCIe?
>>
> 
> cml0 is used for pcie and cml1 is used for sata.

OK, so the PCIe drivers' clock-names property may as well contain just
cml then. Same for SATA. The clock name at the provider isn't relevant.
