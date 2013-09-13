Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755380Ab3IMKFZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 06:05:25 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:51835 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754693Ab3IMKFY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 06:05:24 -0400
Date: Fri, 13 Sep 2013 11:04:53 +0100
From: Will Deacon <will.deacon@arm.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Andrew Pinski <pinskia@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Pinski <apinski@cavium.com>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 5/5] ARM64: Add support for ILP32 ABI.
Message-ID: <20130913100453.GB21859@mudshark.cambridge.arm.com>
References: <1378762380-13152-1-git-send-email-apinski@cavium.com>
 <1378762380-13152-5-git-send-email-apinski@cavium.com>
 <20130911143102.GA8825@darko.cambridge.arm.com>
 <CA+=Sn1nd3Ym8so_=SP4NC1fjKWn4dNPYvz4OZMo0tLZptF8KVw@mail.gmail.com>
 <20130913094712.GA21859@mudshark.cambridge.arm.com>
 <20130913095739.GB10385@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130913095739.GB10385@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 13, 2013 at 10:57:40AM +0100, Catalin Marinas wrote:
> On Fri, Sep 13, 2013 at 10:47:12AM +0100, Will Deacon wrote:
> > On Fri, Sep 13, 2013 at 07:18:48AM +0100, Andrew Pinski wrote:
> > > On Wed, Sep 11, 2013 at 7:32 AM, Catalin Marinas
> > > <catalin.marinas@arm.com> wrote:
> > > > On Mon, Sep 09, 2013 at 10:32:59PM +0100, Andrew Pinski wrote:
> > > >> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> > > >> index cc64df5..7fdc994 100644
> > > >> --- a/arch/arm64/Kconfig
> > > >> +++ b/arch/arm64/Kconfig
> > > >> @@ -248,7 +248,7 @@ source "fs/Kconfig.binfmt"
> > > >>
> > > >>  config COMPAT
> > > >>         def_bool y
> > > >> -       depends on ARM64_AARCH32
> > > >> +       depends on ARM64_AARCH32 || ARM64_ILP32
> > > >>         select COMPAT_BINFMT_ELF
> > > >>
> > > >>  config ARM64_AARCH32
> > 
> > (nitpick) We used to have an option like this, called
> > CONFIG_AARCH32_EMULATION, which I think is clearer than CONFIG_ARM64_AARCH32.
> 
> I think avoiding "EMULATION" is better, we don't actually emulate the
> instruction set ;).

Bah, you suggest something better then!

Will
