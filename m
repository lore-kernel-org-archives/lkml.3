Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754620Ab3FKKl2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 06:41:28 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:2124 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754568Ab3FKKl0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 06:41:26 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 11 Jun 2013 03:40:59 -0700
From: Jay Agarwal <jagarwal@nvidia.com>
To: "'Thierry Reding'" <thierry.reding@gmail.com>
CC: Stephen Warren <swarren@wwwdotorg.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
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
Date: Tue, 11 Jun 2013 16:10:43 +0530
Subject: RE: [PATCH V3 2/4] ARM: tegra: pcie: Add tegra3 support
Thread-Topic: [PATCH V3 2/4] ARM: tegra: pcie: Add tegra3 support
Thread-Index: Ac5mjL53g9Ui0MOBQVGHGwSqPjuxWAAAE55Q
Message-ID: <C79B248886DD134989C8FF6B096A91AB91B616BEF3@BGMAIL01.nvidia.com>
References: <1370372252-4332-1-git-send-email-jagarwal@nvidia.com>
 <1370372252-4332-2-git-send-email-jagarwal@nvidia.com>
 <51AE3D3B.6080102@wwwdotorg.org> <20130610195028.GB25859@mithrandir>
 <C79B248886DD134989C8FF6B096A91AB91B616BEED@BGMAIL01.nvidia.com>
 <20130611101610.GB932@manwe>
In-Reply-To: <20130611101610.GB932@manwe>
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

> > I have mentioned it in description as -> "Corrected logic in read/write
> config space to display right device number on bus 0"
> >
> > > Device 0:00.0 is usually the root complex, and device 0:01.0, 0:02.0
> > > etc are the root ports. The change proposed above makes 0:00.0 the
> > > first root port, therefore breaking what systems usually expect.
> > >
> > I was seeing root port 2 in cardhu being enumerated as pci_bus 0000:03,
> which I thought should be pci_bus 0000:02, so made this change.
> 
> Yes, that's done on purpose to mirror what a typical PCI tree looks like, as I
> already explained. So unless this fixes a real bug I'll just drop it while
> applying.

Please apply V4 patch instead which does not contain this change along with taking care of other review comments.
