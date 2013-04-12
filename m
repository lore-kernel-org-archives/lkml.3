Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754728Ab3DLRGT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 13:06:19 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:16774 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183Ab3DLRGR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 13:06:17 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 12 Apr 2013 10:04:47 -0700
From: Jay Agarwal <jagarwal@nvidia.com>
To: "'Stephen Warren'" <swarren@wwwdotorg.org>
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
Date: Fri, 12 Apr 2013 22:36:12 +0530
Subject: RE: [PATCH 1/3] ARM: tegra: pcie: Add tegra3 support
Thread-Topic: [PATCH 1/3] ARM: tegra: pcie: Add tegra3 support
Thread-Index: Ac43n3LT50gqXMHXSfS49lWSw/L88gAAGveQ
Message-ID: <C79B248886DD134989C8FF6B096A91AB91B36FB302@BGMAIL01.nvidia.com>
References: <1365435688-4179-1-git-send-email-jagarwal@nvidia.com>
 <51630ABB.1020200@wwwdotorg.org>
 <C79B248886DD134989C8FF6B096A91AB91B36FB300@BGMAIL01.nvidia.com>
 <51683E00.4020506@wwwdotorg.org>
In-Reply-To: <51683E00.4020506@wwwdotorg.org>
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

> On 04/12/2013 10:43 AM, Jay Agarwal wrote:
> >> On 04/08/2013 09:41 AM, Jay Agarwal wrote:
> >>> Signed-off-by: Jay Agarwal <jagarwal@nvidia.com>
> >>>
> >>> - Enable pcie root port 2 for cardhu
> >>> - Make private data structure for each SOC
> >>> - Add required tegra3 clocks and regulators
> >>> - Add tegra3 specific code in enable controller
> >>> - Modify clock tree to get clocks based on device
> >>> - Based on git://gitorious.org/thierryreding/linux.git
> >>
> >> A couple more points on this patch:
> >>
> >> * You didn't mention that this series is based on Thierry's
> >> work-in-progress tree, and not something immediately destined for
> >> upstream. As such, only Thierry is expected to actually apply any of these
> patches.
> >>
> > [>] Stephen, I have mentioned it in comment description as Based on
> git://gitorious.org/thierryreding/linux.git, is this not enough?
> 
> Well, first off, there are many branches there, and secondly the branch that
> a series is based on doesn't necessarily imply much about what you expect
> people to do with it.
> 
I am not clear, What should I mention then?

