Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933555AbaEFBNM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 21:13:12 -0400
Received: from mail-qa0-f52.google.com ([209.85.216.52]:58455 "EHLO
	mail-qa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933431AbaEFBNL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 21:13:11 -0400
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:157d:b905:44ab:3ee0:cb7a]
In-Reply-To: <20140506110758.9ddcae1a0fa3b9548e37bc58@canb.auug.org.au>
References: <20140506110758.9ddcae1a0fa3b9548e37bc58@canb.auug.org.au>
Date: Mon, 5 May 2014 18:13:10 -0700
Message-ID: <CAOesGMgLemvWtzN=eBwKerYxcVddx=Uc6O+5aLfL2Yg9GqPTBA@mail.gmail.com>
Subject: Re: linux-next: manual merge of the mvebu tree with the arm-soc tree
From: Olof Johansson <olof@lixom.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <robh@kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 5, 2014 at 6:07 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi all,
>
> Today's linux-next merge of the mvebu tree got a conflict in
> arch/arm/mach-mvebu/Kconfig between commit 55400f3a1f89 ("ARM: mvebu:
> clean-up unneeded kconfig selects") from the arm-soc tree and commit
> 8e6ac2033822 ("ARM: mvebu: enable the ARM SCU on Armada 375 and Armada
> 38x") from the mvebu tree.
>
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).

Thanks for the heads up. This will be resolved permanently once we
merge the mvebu contents into arm-soc (since that'll go on top of the
kconfig select cleanup).


-Olof
