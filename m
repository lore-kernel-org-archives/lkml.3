Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757502Ab3BFR0a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 12:26:30 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:50870 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751044Ab3BFR0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 12:26:25 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: devicetree-discuss@lists.ozlabs.org,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        Greg KH <gregkh@linuxfoundation.org>,
        Russell King <linux@arm.linux.org.uk>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Bjorn Helgaas <bhelgaas@google.com>, linux-tegra@vger.kernel.org,
        Andrew Murray <andrew.murray@arm.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 06/14] ARM: pci: Keep pci_common_init() around after init
Date: Thu, 07 Feb 2013 02:20:05 +0100
Message-ID: <2957343.pp7RNnqk54@wuerfel>
User-Agent: KMail/4.10 rc3 (Linux/3.8.0-3-generic; KDE/4.9.98; x86_64; ; )
In-Reply-To: <CACRpkdYGgdMTi0ZeMeCk5UmrndD451Pyz8L_XE=y9SPXfGGdew@mail.gmail.com>
References: <1357764194-12677-1-git-send-email-thierry.reding@avionic-design.de> <9348609.HjKCmL9u9S@wuerfel> <CACRpkdYGgdMTi0ZeMeCk5UmrndD451Pyz8L_XE=y9SPXfGGdew@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:LeZv00x+gNpXYmFZxcBgWgSRgyPkWwJ2IUYqMAUODa3
 JcDJ407Mi3pPxzsOmBeAWKWmkSk0YdQ0DKlCUEK/cqLaZfP+i0
 XNaHOw8qh20SJpfndwnLcD5JBhMYhg7AP37CiRwkaeyoLaHX13
 NowQO48k84SUZrKvMkdhGCgzE2I5fBjVH5NuWQ+zx/SWNhO1Mw
 /SMsgAJviarh7YU9R6bcds60at4N0ZkimJ4RFNTG21TCQr6tsS
 Gg6y9UephK9AivM+FB3RoeAnRIUS7nAmZ4P8sgFyeBpTe7Yrer
 rZzgFscv5wGUMPQoQyB1Db/r9JhZcnaUToE8YILQzAqmDXNWcH
 ibD1/sr2nN2bH5KaTVg4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 06 February 2013 18:07:53 Linus Walleij wrote:
> However it leaves the question of how much __init, __initdata
> and __initconst we have littering around. Oh, well, we'll see
> I guess.

Actually, kbuild is pretty good at warning around the
bugs there.

	Arnd
