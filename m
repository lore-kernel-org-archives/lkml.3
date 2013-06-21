Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423189Ab3FUFax (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 01:30:53 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:18123 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754159Ab3FUFau convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 01:30:50 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 20 Jun 2013 22:30:25 -0700
From: Jay Agarwal <jagarwal@nvidia.com>
To: "'Stephen Warren'" <swarren@wwwdotorg.org>
CC: "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "thierry.reding@avionic-design.de" <thierry.reding@avionic-design.de>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        Laxman Dewangan <ldewangan@nvidia.com>,
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
Date: Fri, 21 Jun 2013 11:00:20 +0530
Subject: RE: [PATCH V1] ARM: dts: tegra: Modify pcie memory space size
Thread-Topic: [PATCH V1] ARM: dts: tegra: Modify pcie memory space size
Thread-Index: Ac5t0rMsO0OQGf37SN+CxIu+wgXr/AAbXJEw
Message-ID: <C79B248886DD134989C8FF6B096A91AB91CF1615EC@BGMAIL01.nvidia.com>
References: <1371712491-31070-1-git-send-email-jagarwal@nvidia.com>
 <51C32CC7.5010109@wwwdotorg.org>
In-Reply-To: <51C32CC7.5010109@wwwdotorg.org>
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

> On 06/20/2013 01:14 AM, Jay Agarwal wrote:
> > - decrease non-prefetch memory size to 128 MB
> > - increase prefetch memory size to 384 MB
> > - above change is done because most pcie devices
> >   prefetch memory size requirement is quite higher
> >   compared to non-prefetch memory space.
> 
> It's possible this change won't be suitable for all applications. People may
> simply need to adjust their DT based on what they want to connect.
> Still, this patch probably biases things in the correct way for now.
> Longer term, we might want to investigate dynamically sizing the windows
> in order to support arbitrary attached devices, in much the same way as the
> Marvell code does/will in order to conserve physical/bus address space for
> their multiple controllers.
> 
> However, this change allows me to correctly enumerate a particular GPU I
> have plugged into my Harmony board, and assign all the BARs, so:
> 
> Tested-by: Stephen Warren <swarren@nvidia.com>
> 
Thierry,
Could you please integrate this change also to your branch if review is done. Please let me know once it is done.
