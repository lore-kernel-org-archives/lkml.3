Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758076Ab3FEW4p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 18:56:45 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:59490 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757638Ab3FEW4n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 18:56:43 -0400
MIME-Version: 1.0
In-Reply-To: <3619282.JgdgeGHudI@flatron>
References: <CAPweEDx3mAy40BZrzrKPRbvg7vKMj7KevDQ3m_v4p6Yo50eSGg@mail.gmail.com>
	<CAKON4OyyRF4Z46RyJFDWUwo4L52Z8bgSH0CzDr2gDerw4iDwcw@mail.gmail.com>
	<3619282.JgdgeGHudI@flatron>
Date: Wed, 5 Jun 2013 23:56:43 +0100
X-Google-Sender-Auth: YG38DYAWMoJYI7A8-hdi4FoZCQI
Message-ID: <CAPweEDwyX4=Sme9kyDU64k9h3SPUHuErD8gEqfdYLGwBOocZDQ@mail.gmail.com>
Subject: Re: getting allwinner SoC support upstream (was Re: Uploading linux (3.9.4-1))
From: Luke Kenneth Casson Leighton <lkcl@lkcl.net>
To: Tomasz Figa <tomasz.figa@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org,
        "jonsmirl@gmail.com" <jonsmirl@gmail.com>,
        devicetree-discuss <devicetree-discuss@ozlabs.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        debian-arm@lists.debian.org,
        Linux on small ARM machines 
	<arm-netbook@lists.phcomp.co.uk>,
        debian-kernel@lists.debian.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[removing debian-release again - at their request]

On Wed, Jun 5, 2013 at 11:11 PM, Tomasz Figa <tomasz.figa@gmail.com> wrote:

> Allwinner has just reinvented a wheel, without even considering the fact
> that it has been already invented.

apologies, tomasz, but i believe i covered this issue in, again, my
reply to russell, in which i point out that the both the context as
well as the scope of the problem being solved is entirely different
from that which the linux kernel developers find themselves in.  also,
we note from what russell said, was that device tree wasn't ready for
commercial deployment; allwinner's developers don't speak english, and
additionally a fabless semiconductor company need to maintain absolute
commercial secrecy at the all-critical time when they're doing
FPGA-based testing of their netlists (yes, really: running linux on a
huge $250k's worth of FPGAs) and haven't yet put the design into
actual silicon.

so there's a lot of factors which i believe the linux kernel
developers are not aware of, and haven't taken into account, and to
place blame onto the SoC vendors for not working with *you* when *you*
haven't made an effort to understand their situation is, i feel, not
really helping anyone.  not that i'm one to talk about understanding
people, but hey... :)

l.
