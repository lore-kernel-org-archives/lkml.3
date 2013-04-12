Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755118Ab3DLQri (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 12:47:38 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:16142 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752632Ab3DLQrg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 12:47:36 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 12 Apr 2013 09:46:02 -0700
From: Jay Agarwal <jagarwal@nvidia.com>
To: "'Stephen Warren'" <swarren@wwwdotorg.org>
CC: "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "thierry.reding@avionic-design.de" <thierry.reding@avionic-design.de>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "olof@lixom.net" <olof@lixom.net>, Hiroshi Doyu <hdoyu@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        "mturquette@linaro.org" <mturquette@linaro.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Juha Tukkinen <jtukkinen@nvidia.com>,
        Krishna Thota <kthota@nvidia.com>
Date: Fri, 12 Apr 2013 22:13:35 +0530
Subject: RE: [PATCH 1/3] ARM: tegra: pcie: Add tegra3 support
Thread-Topic: [PATCH 1/3] ARM: tegra: pcie: Add tegra3 support
Thread-Index: Ac40hvEU5DVkjio7S8+fC8gyqpaOZgDFX/mQ
Message-ID: <C79B248886DD134989C8FF6B096A91AB91B36FB300@BGMAIL01.nvidia.com>
References: <1365435688-4179-1-git-send-email-jagarwal@nvidia.com>
 <51630ABB.1020200@wwwdotorg.org>
In-Reply-To: <51630ABB.1020200@wwwdotorg.org>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On 04/08/2013 09:41 AM, Jay Agarwal wrote:
> > Signed-off-by: Jay Agarwal <jagarwal@nvidia.com>
> >
> > - Enable pcie root port 2 for cardhu
> > - Make private data structure for each SOC
> > - Add required tegra3 clocks and regulators
> > - Add tegra3 specific code in enable controller
> > - Modify clock tree to get clocks based on device
> > - Based on git://gitorious.org/thierryreding/linux.git
> 	
> A couple more points on this patch:
> 
> * You didn't mention that this series is based on Thierry's work-in-progress
> tree, and not something immediately destined for upstream. As such, only
> Thierry is expected to actually apply any of these patches.
> 
[>] Stephen, I have mentioned it in comment description as Based on git://gitorious.org/thierryreding/linux.git, is this not enough?

> * Your changes to the Tegra PCIe driver require that device tree include
> extra clocks and regulators. You need to update
> Documentation/devicetree/bindings/pci/nvidia,tegra20-pcie.txt to describe
> these new requirements.
[>] Should I create tegra30-pcie.txt? or made changes in tegra20-pcie.txt itself?
