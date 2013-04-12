Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754577Ab3DLRB6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 13:01:58 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:35180 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183Ab3DLRB4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 13:01:56 -0400
Message-ID: <51683E00.4020506@wwwdotorg.org>
Date: Fri, 12 Apr 2013 11:01:52 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Jay Agarwal <jagarwal@nvidia.com>
CC: Prashant Gaikwad <pgaikwad@nvidia.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        Krishna Thota <kthota@nvidia.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        "thierry.reding@avionic-design.de" <thierry.reding@avionic-design.de>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "olof@lixom.net" <olof@lixom.net>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "mturquette@linaro.org" <mturquette@linaro.org>,
        Juha Tukkinen <jtukkinen@nvidia.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Hiroshi Doyu <hdoyu@nvidia.com>
Subject: Re: [PATCH 1/3] ARM: tegra: pcie: Add tegra3 support
References: <1365435688-4179-1-git-send-email-jagarwal@nvidia.com> <51630ABB.1020200@wwwdotorg.org> <C79B248886DD134989C8FF6B096A91AB91B36FB300@BGMAIL01.nvidia.com>
In-Reply-To: <C79B248886DD134989C8FF6B096A91AB91B36FB300@BGMAIL01.nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/12/2013 10:43 AM, Jay Agarwal wrote:
>> On 04/08/2013 09:41 AM, Jay Agarwal wrote:
>>> Signed-off-by: Jay Agarwal <jagarwal@nvidia.com>
>>>
>>> - Enable pcie root port 2 for cardhu
>>> - Make private data structure for each SOC
>>> - Add required tegra3 clocks and regulators
>>> - Add tegra3 specific code in enable controller
>>> - Modify clock tree to get clocks based on device
>>> - Based on git://gitorious.org/thierryreding/linux.git
>> 	
>> A couple more points on this patch:
>>
>> * You didn't mention that this series is based on Thierry's work-in-progress
>> tree, and not something immediately destined for upstream. As such, only
>> Thierry is expected to actually apply any of these patches.
>>
> [>] Stephen, I have mentioned it in comment description as Based on git://gitorious.org/thierryreding/linux.git, is this not enough?

Well, first off, there are many branches there, and secondly the branch
that a series is based on doesn't necessarily imply much about what you
expect people to do with it.

> 
>> * Your changes to the Tegra PCIe driver require that device tree include
>> extra clocks and regulators. You need to update
>> Documentation/devicetree/bindings/pci/nvidia,tegra20-pcie.txt to describe
>> these new requirements.
>
> [>] Should I create tegra30-pcie.txt? or made changes in tegra20-pcie.txt itself?

(What is "[>]"?)

It'd probably be simplest to edit tegra20-pcie.txt, and just mention the
extra requirements for Tegra30.
