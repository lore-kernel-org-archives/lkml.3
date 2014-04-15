Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752143AbaDOHyi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 03:54:38 -0400
Received: from moutng.kundenserver.de ([212.227.17.13]:49797 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998AbaDOHyd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 03:54:33 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Chanho Min <chanho.min@lge.com>, "'Will Deacon'" <will.deacon@arm.com>,
        "'Catalin Marinas'" <Catalin.Marinas@arm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arm64:kconfig: make default for CONFIG_COMPAT
Date: Tue, 15 Apr 2014 09:54:28 +0200
Message-ID: <4386453.rooF7jKWKy@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
References: <1397462883-12740-1-git-send-email-chanho.min@lge.com> <20140414164618.GC12916@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:h1l1SKNHstTCRgnEqxkebQJ/N/atCZuejxhuA6uMTuf
 DQqOBHLYhqThDZbivJgSUwRlz3PoyOM7AWOFRTzFAxccNPBe1H
 rvrRn8BubvQ0EGU7A6uq1R4KgFFZ/KzedsmJ/3OeE4uBYbSvC7
 apRw4TZEetVvqApaJi5vfbsWAYaxZXI+iN635vm0ke5GLNNOS/
 Ob8AqPnqfXso3Vxpb+Cx0MrlYmu1yqp2YeS2TTXLSCtm6GWH5u
 nIud1jZhvQisFpNvUDq+XrXaU4FZhvOuH/nG8i/JNU7VQlJxnY
 0DEQ8N6wCk7ADTrMw9IGbKov8W+ap6jYhv9pi4XmTL6yeL2Rx3
 /tKiNDzZDcq+VW8lJas4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 15 April 2014 09:07:00 Chanho Min wrote:
> > -----Original Message-----
> > From: Will Deacon [mailto:will.deacon@arm.com]
> > Sent: Tuesday, April 15, 2014 1:46 AM
> > To: Chanho Min
> > Cc: Catalin Marinas; linux-arm-kernel@lists.infradead.org; linux-kernel@vger.kernel.org
> > Subject: Re: [PATCH] arm64:kconfig: make default for CONFIG_COMPAT
> > 
> > On Mon, Apr 14, 2014 at 09:08:03AM +0100, Chanho Min wrote:
> > > 'make savedefconfig' doesn't generate defconfig properly due to
> > > missing COMPAT default. So Add default and set to yes.
> > 
> > I thought a missing `default' line in a Kconfig entry meant that the option
> > ended up defaulting to 'n'. What exactly is the problem you are seeing?
> 
> Correct minimal config is not generated without default line.
> If we want to set COMPAT to 'n', 'default n' should be added.

That would be pointless, because 'n' is already the default.
What do you want to achieve?

	Arnd
