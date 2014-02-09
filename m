Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752090AbaBITp7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 14:45:59 -0500
Received: from filtteri6.pp.htv.fi ([213.243.153.189]:57387 "EHLO
	filtteri6.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751646AbaBITp6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 14:45:58 -0500
Date: Sun, 9 Feb 2014 21:45:01 +0200
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: Jonas Gorski <jogo@openwrt.org>
Cc: Paul Bolle <pebolle@tiscali.nl>, Ralf Baechle <ralf@linux-mips.org>,
        MIPS Mailing List <linux-mips@linux-mips.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] MIPS: Replace CONFIG_MIPS64 and CONFIG_MIPS32_R2
Message-ID: <20140209194501.GD573@drone.musicnaut.iki.fi>
References: <1391952745.25424.6.camel@x220>
 <CAOiHx=mi3sW7C0ZGwAhobRryikMs=Hj0UL19ENuUMECqk0EW5g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOiHx=mi3sW7C0ZGwAhobRryikMs=Hj0UL19ENuUMECqk0EW5g@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, Feb 09, 2014 at 05:26:59PM +0100, Jonas Gorski wrote:
> On Sun, Feb 9, 2014 at 2:32 PM, Paul Bolle <pebolle@tiscali.nl> wrote:
> > Commit 597ce1723e0f ("MIPS: Support for 64-bit FP with O32 binaries")
> > introduced references to two undefined Kconfig macros. CONFIG_MIPS32_R2
> > should clearly be replaced with CONFIG_CPU_MIPS32_R2. And CONFIG_MIPS64
> > should apparently be replaced with CONFIG_64BIT.
> 
> While I agree about the CONFIG_MIPS64 => CONFIG_64BIT replacement, I
> wonder if CONFIG_MIPS32_R2 shouldn't rather be CONFIG_CPU_MIPSR2
> (maybe even the existing CONFIG_CPU_MIPS32_R2 are wrong here).

FYI, the 64BIT part is already fixed by
<http://patchwork.linux-mips.org/patch/6506/>. I guess these two changes
could be separate patches.

A.
