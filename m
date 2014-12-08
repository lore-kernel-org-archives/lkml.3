Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755338AbaLHLZo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 06:25:44 -0500
Received: from mout.kundenserver.de ([212.227.126.130]:51236 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755232AbaLHLZm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 06:25:42 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Olof Johansson <olof@lixom.net>,
        Matthias Klein <matthias.klein@linux.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>
Subject: Re: linux-next: manual merge of the bcm2835 tree with the arm-soc tree
Date: Mon, 08 Dec 2014 12:25:01 +0100
Message-ID: <2406890.FlzRjyvuXd@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20141208120619.68287b54@canb.auug.org.au>
References: <20141208120619.68287b54@canb.auug.org.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:QVh1FN9biVpmvXPUC0y2iSfslJOlIupPWacNwjUulT9+vi81Meb
 jah2ncMha52gfCEVxv/bZ2ciuj9zCGLNWDaxkig2TEzO96vbvmLDKJPpDDGnSUgjfh6Xb6M
 nGsuXpXWnEjxESPYszqNA6vxRk10NJ9HkoKIYiCHlQVAvZdxUfboxixScDicYizuC3v4GXq
 deCC/94mI+le18ZtAtvuw==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 08 December 2014 12:06:19 Stephen Rothwell wrote:
> Hi Stephen,
> 
> Today's linux-next merge of the bcm2835 tree got a conflict in
> arch/arm/boot/dts/Makefile between commit 302a5ef29d49 ("ARM: BCM5301X:
> Add DT for Netgear R6300 V2") from the arm-soc tree and commit
> 6298ed17a404 ("ARM: bcm2835: Add device tree for Raspberry Pi model
> B+") from the bcm2835 tree.
> 
> I fixed it up (the bcm2835 tree patch is also in the arm-soc tree as
> commit ba2a1d6959ac ("ARM: bcm2835: Add device tree for Raspberry Pi
> model B+"), so I just used the arm-soc version) and can carry the fix
> as necessary (no action is required).

Thanks a lot for the notification!

Lee, do you know what is going on? Did you accidentally rebase a commit
that you already sent for inclusion in arm-soc?

	Arnd
