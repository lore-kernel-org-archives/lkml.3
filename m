Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755420AbaLHNAR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 08:00:17 -0500
Received: from mail-qc0-f171.google.com ([209.85.216.171]:35037 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753231AbaLHNAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 08:00:15 -0500
Date: Mon, 8 Dec 2014 13:00:09 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Olof Johansson <olof@lixom.net>,
        Matthias Klein <matthias.klein@linux.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        linux-kernel@vger.kernel.org, linux-next@vger.kernel.org
Subject: Re: linux-next: manual merge of the bcm2835 tree with the arm-soc
 tree
Message-ID: <20141208130009.GL3951@x1>
References: <20141208120619.68287b54@canb.auug.org.au>
 <2406890.FlzRjyvuXd@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2406890.FlzRjyvuXd@wuerfel>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 08 Dec 2014, Arnd Bergmann wrote:

> On Monday 08 December 2014 12:06:19 Stephen Rothwell wrote:
> > Hi Stephen,
> > 
> > Today's linux-next merge of the bcm2835 tree got a conflict in
> > arch/arm/boot/dts/Makefile between commit 302a5ef29d49 ("ARM: BCM5301X:
> > Add DT for Netgear R6300 V2") from the arm-soc tree and commit
> > 6298ed17a404 ("ARM: bcm2835: Add device tree for Raspberry Pi model
> > B+") from the bcm2835 tree.
> > 
> > I fixed it up (the bcm2835 tree patch is also in the arm-soc tree as
> > commit ba2a1d6959ac ("ARM: bcm2835: Add device tree for Raspberry Pi
> > model B+"), so I just used the arm-soc version) and can carry the fix
> > as necessary (no action is required).
> 
> Thanks a lot for the notification!
> 
> Lee, do you know what is going on? Did you accidentally rebase a commit
> that you already sent for inclusion in arm-soc?

Nope.  The branch hasn't changed at all.

OOI why would a re-base affect anything?  I sent you it in patch form.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
