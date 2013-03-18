Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753795Ab3CRPuT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 11:50:19 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:58000 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752567Ab3CRPuR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 11:50:17 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Stephen Warren <swarren@wwwdotorg.org>
Subject: Re: linux-next: manual merge of the tegra tree with the arm-soc tree
Date: Mon, 18 Mar 2013 15:49:56 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-8-generic; KDE/4.3.2; x86_64; ; )
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Olof Johansson <olof@lixom.net>,
        Stephen Warren <swarren@nvidia.com>, Colin Cross <ccross@android.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        linux-kernel@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        linux-next@vger.kernel.org, linux-arm-kernel@lists.infradead.org
References: <20130318153140.100bdf364d5614ce31f12eae@canb.auug.org.au> <51473179.2030306@wwwdotorg.org>
In-Reply-To: <51473179.2030306@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201303181549.57080.arnd@arndb.de>
X-Provags-ID: V02:K0:a6yo83yd4G7oFmKxB6T7SWjG0dIbRrYEcN5mKuHJpQ0
 Hy4BQOS91bucaWG/Fteb39sRPALont7nkpF42BXUevQWMNcx17
 DyY/kldEnhl3F+XY6XbagJlJ003gOA95mcpLF055g+gbbwwPOG
 SISWI2o/eBDdZ8lchhpda3vhqgy0sz8mu2ViIB1MJ/YAcIYxKl
 RydRLWdb39+/CxkD7n6RZAWIEaNLx/V2otxi95TSj2HNOmk/is
 xJlQerJCgGcJYpkSLPIM26rZzT+flhgawMdG8/imQ2V4cH/K8V
 p6538NVn1tIyfQerAkZmFXcQRQzDkkMbZA6xsKiNy6utFuJHbC
 R+0kgsKrBuJDlmjyFU44=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 18 March 2013, Stephen Warren wrote:
> On 03/17/2013 10:31 PM, Stephen Rothwell wrote:
> > Hi all,
> > 
> > Today's linux-next merge of the tegra tree got a conflict in 
> > drivers/clocksource/tegra20_timer.c between commit 1d16cfb3aeba 
> > ("clocksource: tegra20: use the device_node pointer passed to
> > init") from the arm-soc tree and commit 6f88fb8af6c6 ("clocksource:
> > tegra: move to of_clk_get") from the tegra tree.
> > 
> > I fixed it up (see below) and can carry the fix as necessary (no
> > action is required).
> 
> Thanks. This resolution looks fine.
> 
> Arnd/Olof, do you want me to rebase the Tegra branch onto some arm-soc
> branch to resolve this conflict, or are you happy to simply resolve it
> as below when pulling the Tegra branches into arm-soc for 3.10?

No need to rebase. We can resolve this by merging the clksrc/cleanup
into your branch when we pull it, or you can merge it yourself.

	Arnd
