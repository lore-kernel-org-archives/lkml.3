Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752851AbaESSUt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 14:20:49 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:60803 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751072AbaESSUq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 14:20:46 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Joseph S. Myers" <joseph@codesourcery.com>
Cc: Chung-Lin Tang <cltang@codesourcery.com>,
        John Stultz <john.stultz@linaro.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Christoph Hellwig <hch@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ley Foon Tan <lftan@altera.com>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        LeyFoon Tan <lftan.linux@gmail.com>
Subject: Re: [PATCH 00/25] Change time_t and clock_t to 64 bit
Date: Mon, 19 May 2014 20:20:30 +0200
Message-ID: <9148888.HqBb0YIpx4@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <Pine.LNX.4.64.1405191806230.25418@digraph.polyomino.org.uk>
References: <1399971456-3941-1-git-send-email-lftan@altera.com> <5228220.XfC7baN05k@wuerfel> <Pine.LNX.4.64.1405191806230.25418@digraph.polyomino.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:+IlRRMJ38iXTE/RuNlwF43eqANpu/RtMgvTvynp1mZz
 BeuRld9SSbPIE60WRg07geCtVrNbD7RPbuHJgqRYCXJmsucaS0
 I2opDjguNYLqS9GEMs5v+vHfWRxfEhlzTrR2kj2th7ejVnKgfx
 Dobr7bcrxmjX1RdIQQCXV8+q9kP8bKvQi9IGLRSbrKg3X2dXvg
 /1JxaZsx2eZK/2qY8yh3j27hAZbO6NIX9khm3pljcYzTuHnRuU
 prcZt77sxlgV45d4wLuznbINFvoYXKbCDiIewiSqiz0vUOiv6C
 /us/Ql55f87SOjAhd1IzrL8QpMGwrxN3tl0yP4RG9gd2uHuJvy
 MS4HAuXWGshcnO2iAFc4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 19 May 2014 18:12:18 Joseph S. Myers wrote:
> On Mon, 19 May 2014, Arnd Bergmann wrote:
> 
> > A related question would be how you plan to support future CPU architectures
> > that never had the 32-bit time_t in the kernel ABI. Would you also want
> > to provide both 32 and 64 bit time_t to user space on those?
> 
> I'd expect those just to have 64-bit time_t in userspace (like x32) - 
> choosing a different type for time_t from the start is a lot simpler than 
> setting up a second set of interfaces with associated symbol versioning 
> for an existing architecture.  This whole discussion started with the 
> question of whether Nios II should be such an architecture....

Ok
 
> (Other variants may arise as well, e.g. architectures with existing kernel 
> support that only get glibc support later.)

Good point.

	Arnd
