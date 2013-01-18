Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754909Ab3ARRv0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 12:51:26 -0500
Received: from mail-lb0-f170.google.com ([209.85.217.170]:36519 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751912Ab3ARRvY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 12:51:24 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFx5ZyFtd59ygn6ja5X-3ZyRvhfJLqtNKyF_mH3+-kSjKg@mail.gmail.com>
References: <CA+55aFx5ZyFtd59ygn6ja5X-3ZyRvhfJLqtNKyF_mH3+-kSjKg@mail.gmail.com>
Date: Fri, 18 Jan 2013 10:51:22 -0700
Message-ID: <CAKocOOPr4wddCmDEWKmsKsKeTc3m779opuN_qRb4yiL63KVZ8A@mail.gmail.com>
Subject: Re: Linux 3.8-rc4
From: Shuah Khan <shuahkhan@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 17, 2013 at 8:51 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> Hey, it's been another week already! In fact, it took me so much by
> surprise that it's been an extra day. The whole "release in the middle
> of the week" thing feels odd to me.
>
> [ That actually got me to wonder what the most common day was, and
> statistically I definitely do most releases on Sunday. The "git tip of
> the week" looks like this:
>
>     git log --no-walk --pretty="%ad" $(git tag -l)
>
>   which can then be piped into
>
>     cut -d' ' -f1 | sort | uniq -c | sort -n
>
>   to see the full git tagging statistics ]
>
> Anyway, with that digression, I can happily report that -rc4 is
> smaller than -rc3 despite the extra day, although not by much. There's
> not really a whole lot that stands out: apart from one new wireless
> driver (the Atheros Wilocity driver) and some OMAP drm changes, the
> diffstat looks pretty flat and spread out. Which just means lots of
> small changes all over.
>
> The ShortLog is appended, but it's basically 85% drivers, with over
> half the patch being to the aforementioned new wireless one and the
> OMAP drm changes. There's some other stuff there too, but it's largely
> in the noise - small ARM and s390 updates (and a smattering of SuperH
> and x86), a few tiny filesystem fixes, things like that.
>
> Go forth and test. My gut feel is that things really are calming down.
> And I'd hate to be proven wrong.
>
>             Linus
>

reboot/shutdown hang in 3.8-rc3 due to
71e3d1578c954cf29f1f4db1c8930d3574025eb0 went away in this rc. But I
am still seeing

[   22.890240] DMAR:[fault reason 06] PTE Read access is not set
[   22.890268] dmar: DRHD: handling fault status reg 3
[   22.890272] dmar: DMAR:[DMA Read] Request device [01:00.0] fault
addr 80004000

on ATI radeon VGA. Running bisect and will update.

-- Shuah
