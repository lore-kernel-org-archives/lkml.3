Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753604Ab3I0TTp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 15:19:45 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:65287 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752266Ab3I0TTm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 15:19:42 -0400
MIME-Version: 1.0
In-Reply-To: <CAErSpo5tN==4nSv2u3SUBe_L4VsWn4P7TN+LtrC172Qj1vhtog@mail.gmail.com>
References: <CAErSpo7UX6dt0CPZp3kEQrXXbMeArpu1iFfp=-FX46LVgq0iMw@mail.gmail.com>
	<20130926150228.GL11119@titan.lakedaemon.net>
	<CAErSpo5tN==4nSv2u3SUBe_L4VsWn4P7TN+LtrC172Qj1vhtog@mail.gmail.com>
Date: Fri, 27 Sep 2013 14:19:40 -0500
Message-ID: <CAHrpEqSCmA2moTJvTv-o9pHMtk1_tTzjLPHZYRZwkKwYuin2YQ@mail.gmail.com>
Subject: Re: PCI host merge strategy and maintainers
From: Frank Li <lznuaa@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Jason Cooper <jason@lakedaemon.net>, Shawn Guo <shawn.guo@linaro.org>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Jingoo Han <jg1.han@samsung.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Kevin Hilman <khilman@linaro.org>, Stephen Warren <swarren@nvidia.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> OK, I'll assume Jason will take care of pci-mvebu.c, and I will merge
> changes to everything else via the PCI tree.  I will still wait for
> acks from the following before merging things:
>
>   designware: Jingoo Han <jg1.han@samsung.com>
>   exynos: Jingoo Han <jg1.han@samsung.com>
>   imx6: Shawn Guo <shawn.guo@linaro.org>

Shawn already acked and send out v7 version.

best regards
Frank Li

>   tegra: Thierry Reding <thierry.reding@gmail.com>
>
> Bjorn
