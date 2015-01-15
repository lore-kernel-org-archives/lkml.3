Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752301AbbAOB3j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 20:29:39 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:36235 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751385AbbAOB3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 20:29:37 -0500
Date: Wed, 14 Jan 2015 17:29:49 -0800
From: Olof Johansson <olof@lixom.net>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        "arm@kernel.org" <arm@kernel.org>, Bryan Wu <cooloney@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arm: mach-versatile: core: Remove unused function
Message-ID: <20150115012949.GF32756@quad.lixom.net>
References: <1420303959-12898-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
 <CACRpkdan1BZQnYgTdF9ctbLOPNoDwDX3Epy8Xfttd2v4-G-4Lw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdan1BZQnYgTdF9ctbLOPNoDwDX3Epy8Xfttd2v4-G-4Lw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14, 2015 at 12:53:07PM +0100, Linus Walleij wrote:
> On Sat, Jan 3, 2015 at 5:52 PM, Rickard Strandqvist
> <rickard_strandqvist@spectrumdigital.se> wrote:
> 
> > Remove the function versatile_leds_event() that is not used anywhere.
> >
> > This was partially found by using a static code analysis program called cppcheck.
> >
> > Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> 
> Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
> 
> That's right, the code was made redundant in
> commit e031cd513ec2ff661465dc1198220075719e72d1
> "ARM: mach-realview and mach-versatile: retire custom LED code"
> 
> ARM SoC folks: I suggest you apply this patch directly to your cleanup
> branch.

Thanks, applied with a minor tweak to the patch subject.


-Olof
