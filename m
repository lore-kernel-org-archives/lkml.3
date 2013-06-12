Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754352Ab3FLHMK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 03:12:10 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:8544 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851Ab3FLHMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 03:12:08 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 12 Jun 2013 00:10:38 -0700
From: Jay Agarwal <jagarwal@nvidia.com>
To: "'Mike Turquette'" <mturquette@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>
CC: "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "thierry.reding@avionic-design.de" <thierry.reding@avionic-design.de>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        "olof@lixom.net" <olof@lixom.net>, Hiroshi Doyu <hdoyu@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Juha Tukkinen <jtukkinen@nvidia.com>,
        Krishna Thota <kthota@nvidia.com>
Date: Wed, 12 Jun 2013 12:41:38 +0530
Subject: RE: [PATCH V3 1/4] ARM: tegra30: clocks: Fix pciex clock
 registration
Thread-Topic: [PATCH V3 1/4] ARM: tegra30: clocks: Fix pciex clock
 registration
Thread-Index: Ac5m8W7GOn49UgbQSwS/7FiOgcgujAASojaQ
Message-ID: <C79B248886DD134989C8FF6B096A91AB91CF1615C6@BGMAIL01.nvidia.com>
References: <1370372252-4332-1-git-send-email-jagarwal@nvidia.com>
 <51AE3B18.9010604@wwwdotorg.org> <20130611221709.8816.15602@quantum>
In-Reply-To: <20130611221709.8816.15602@quantum>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r5C7CDGr018655

> Quoting Stephen Warren (2013-06-04 12:08:08)
> > On 06/04/2013 12:57 PM, Jay Agarwal wrote:
> > > Registering pciex as peripheral clock instead of fixed clock as
> > > tegra_perih_reset_assert(deassert) api of this clock api gives
> > > warning and ultimately does not succeed to assert(deassert).
> > >
> > > Signed-off-by: Jay Agarwal <jagarwal@nvidia.com>
> > > ---
> > > Patch is based on remotes/gitorious_thierryreding_linux/tegra/next and
> should be applied on top of this.
> >
> > For this change, Mike may as well apply it directly to the clock tree.
> > Thierry can then pick it up when he rebases his tegra/next tree.
> >
> > That said, I don't think you should need any of the
> > TEGRA_CLK_DUPLICATE() entries; the PCIe driver should get its clocks
> > from device tree now, and hence the driver name in the clock
> > registration shouldn't be necessary. All of these
> > TEGRA_CLK_DUPLICATE() entries should be removed en mass sometime
> soon
> > with luck. So, can you simply leave the two TEGRA_CLK_DUPLICATE()
> > entries untouched, rather than changing them?
> 
> Ping on this patch.  I can take it through my tree, but is there going to be
> rework based on Stephen's comments?

Hi Mike,
I have uploaded next version V4 of this patch after taking care of this comment.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
