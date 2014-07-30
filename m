Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751513AbaG3UMh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 16:12:37 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:62466 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750923AbaG3UMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 16:12:35 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Thierry Reding <thierry.reding@gmail.com>
Subject: Re: [PATCH v4] devicetree: Add generic IOMMU device tree bindings
Date: Wed, 30 Jul 2014 22:11:14 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-35-generic; KDE/4.3.2; x86_64; ; )
Cc: Will Deacon <will.deacon@arm.com>, Joerg Roedel <joro@8bytes.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <Pawel.Moll@arm.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Cho KyongHo <pullip.cho@samsung.com>,
        Grant Grundler <grundler@chromium.org>,
        Dave P Martin <Dave.Martin@arm.com>,
        Marc Zyngier <Marc.Zyngier@arm.com>, Hiroshi Doyu <hdoyu@nvidia.com>,
        Olav Haugan <ohaugan@codeaurora.org>,
        Varun Sethi <varun.sethi@freescale.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        arm@kernel.org
References: <1404487757-18829-1-git-send-email-thierry.reding@gmail.com> <20140730110425.GI12239@arm.com> <20140730132348.GM29590@ulmo>
In-Reply-To: <20140730132348.GM29590@ulmo>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201407302211.14342.arnd@arndb.de>
X-Provags-ID: V02:K0:DROBSwwvT8Wn2S+jLF4CWSX3xHFuXZ4KhBh5x4bLMw5
 5gadqi4nsIL6iz7UY0dDSMutMNo1I3qe2rm/4QWWFvP3I+Pbm8
 DFWY4ZgIqgVDjv1lADnqUMlXQJ4jgxhC6WFaj/o5gyXobDpK5A
 fgHGDvpcArizi+jleuxYrtjSig+D5tC8a7yuYzaY8SeYZgNKvK
 YBGO1kpgak3FzkrpQSy4fFrOEFEGxuzM5rqCZgIxfrFNv/gRVL
 VSjHzJE18NQ3bBGGNS0GHOL6JQti+e3kU27dgNtZD67v/GE03l
 gakdGZ+b+ycgm2dO1Kvu8z2R6yuheZbO8100ZC3ThFMzW6CnAo
 yYukPJHjK8tmCEKWnzlr4ipA2lyTqmbGMEYwTkfec
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 30 July 2014, Thierry Reding wrote:
se?
> 
> I think there weren't any comments left for me to address and I've
> mostly been waiting for Joerg to pick it up.
> 
> Joerg, can you take this through the iommu tree for 3.17? Will acked
> this, but perhaps you were waiting for an ACK from the device tree
> bindings maintainers?
> 
> Will, perhaps you can get Pawel or Mark to look at this?
> 
> Arnd, I'm sure if we had your Acked-by that would go a long way too.


Sorry for missing this before my vacation.

Reviewed-by: Arnd Bergmann <arnd@arndb.de>

Olof, please merge it into arm-soc so we can finally build on top
of this!

	Arnd
