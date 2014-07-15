Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933068AbaGOU20 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 16:28:26 -0400
Received: from [95.130.255.143] ([95.130.255.143]:65277 "EHLO radon.swed.at"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757214AbaGOU2Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 16:28:25 -0400
Message-ID: <53C58EC6.8060508@nod.at>
Date: Tue, 15 Jul 2014 22:27:50 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: Ley Foon Tan <lftan@altera.com>, Linux-Arch <linux-arch@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        LeyFoon Tan <lftan.linux@gmail.com>, cltang@codesourcery.com
Subject: Re: [PATCH v2 00/29] nios2 Linux kernel port
References: <CAFLxGvw_fnG1KTVXrcZxHZzKPnG5DA117VmcZBvw3EYgXw-DVw@mail.gmail.com> <1405413956-2772-1-git-send-email-lftan@altera.com> <4213.1405430178@warthog.procyon.org.uk> <20544.1405434031@warthog.procyon.org.uk>
In-Reply-To: <20544.1405434031@warthog.procyon.org.uk>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 15.07.2014 16:20, schrieb David Howells:
> Richard Weinberger <richard.weinberger@gmail.com> wrote:
> 
>> Having it on https://www.kernel.org/pub/tools/crosstool/ would be also nice.
> 
> Does the Fedora cross-compiler suite fit with your set?  All the fedora
> cross-compilers are build from a single pair of SRPMS into a slew of binary
> RPMs and none of the resulting RPMs are relocatable (they all end up in /usr).

I'm not using Fedora.

> The easiest way to install them is:
> 
> 	yum install gcc-\*-linux-gnu
> 
> For reference, the current rawhide SRPMs can be found here:
> 
> 	https://dl.fedoraproject.org/pub/fedora/linux/development/rawhide/source/SRPMS/c/cross-binutils-2.24-4.fc21.src.rpm
> 	https://dl.fedoraproject.org/pub/fedora/linux/development/rawhide/source/SRPMS/c/cross-gcc-4.9.0-3.fc21.src.rpm
> 
> I haven't yet pushed the NIOS2 arch changes (I'm waiting on a fix to allow me
> to build libgcc for Cris).
> 
> I haven't applied any of your patches, though I do apply the same patches that
> are applied to the core Fedora binutils and gcc.  Note that this URL linked to
> on your page:
> 
> 	https://www.kernel.org/pub/tools/crosstool/patches/
> 
> does not seem to exist.
> 
> The compilers that I have managed to produce and install on my system are:
> 
> 	gcc-aarch64-linux-gnu
> 	gcc-alpha-linux-gnu
> 	gcc-arm-linux-gnu
> 	gcc-avr32-linux-gnu
> 	gcc-bfin-linux-gnu
> 	gcc-c6x-linux-gnu
> 	gcc-cris-linux-gnu
> 	gcc-frv-linux-gnu
> 	gcc-h8300-linux-gnu
> 	gcc-hppa-linux-gnu
> 	gcc-hppa64-linux-gnu
> 	gcc-ia64-linux-gnu
> 	gcc-m32r-linux-gnu
> 	gcc-m68k-linux-gnu
> 	gcc-microblaze-linux-gnu
> 	gcc-mips64-linux-gnu
> 	gcc-mn10300-linux-gnu
> 	gcc-nios2-linux-gnu
> 	gcc-powerpc64-linux-gnu
> 	gcc-ppc64-linux-gnu
> 	gcc-s390x-linux-gnu
> 	gcc-sh-linux-gnu
> 	gcc-sh64-linux-gnu
> 	gcc-sparc64-linux-gnu
> 	gcc-tile-linux-gnu
> 	gcc-x86_64-linux-gnu
> 	gcc-xtensa-linux-gnu
>


Nice collection. Let's see whether I can repack your RPMs for openSUSE.

Thanks,
//richard
