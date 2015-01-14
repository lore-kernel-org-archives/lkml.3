Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752034AbbANLxJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 06:53:09 -0500
Received: from mail-ig0-f171.google.com ([209.85.213.171]:63726 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751706AbbANLxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 06:53:08 -0500
MIME-Version: 1.0
In-Reply-To: <1420303959-12898-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
References: <1420303959-12898-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Date: Wed, 14 Jan 2015 12:53:07 +0100
Message-ID: <CACRpkdan1BZQnYgTdF9ctbLOPNoDwDX3Epy8Xfttd2v4-G-4Lw@mail.gmail.com>
Subject: Re: [PATCH] arm: mach-versatile: core: Remove unused function
From: Linus Walleij <linus.walleij@linaro.org>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        "arm@kernel.org" <arm@kernel.org>, Bryan Wu <cooloney@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 3, 2015 at 5:52 PM, Rickard Strandqvist
<rickard_strandqvist@spectrumdigital.se> wrote:

> Remove the function versatile_leds_event() that is not used anywhere.
>
> This was partially found by using a static code analysis program called cppcheck.
>
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

That's right, the code was made redundant in
commit e031cd513ec2ff661465dc1198220075719e72d1
"ARM: mach-realview and mach-versatile: retire custom LED code"

ARM SoC folks: I suggest you apply this patch directly to your cleanup
branch.

Yours,
Linus Walleij
