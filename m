Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751489AbaLOIfO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 03:35:14 -0500
Received: from mail-la0-f44.google.com ([209.85.215.44]:56773 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750865AbaLOIfL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 03:35:11 -0500
MIME-Version: 1.0
In-Reply-To: <7ha92sk533.fsf@deeprootsystems.com>
References: <1418286387-9663-1-git-send-email-tfiga@chromium.org>
	<7h8uiemce7.fsf@deeprootsystems.com>
	<CAPDyKFo6zH4__Odm+RiJCbvXquAQqaLyCAiXrSN6s3KfQhok=A@mail.gmail.com>
	<1576771.dIVCOxU0se@vostro.rjw.lan>
	<CAAFQd5B28WiWUqmbmROJUa3H25R=Y774NuemTZDvkoa=CvZUsw@mail.gmail.com>
	<7ha92sk533.fsf@deeprootsystems.com>
Date: Mon, 15 Dec 2014 09:35:09 +0100
X-Google-Sender-Auth: Eh3HN3_v5fCyUZ3Uj0B-qoEXyJM
Message-ID: <CAMuHMdVpCgK-hNqZ=JWjFGS53g+ZUQ5t=uBxtN1qGXJhoRg8BQ@mail.gmail.com>
Subject: Re: [RFC PATCH 2/2] iommu: rockchip: Handle system-wide and runtime PM
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Kevin Hilman <khilman@kernel.org>
Cc: Tomasz Figa <tfiga@chromium.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        iommu@lists.linux-foundation.org, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>, Heiko Stuebner <heiko@sntech.de>,
        Joerg Roedel <joro@8bytes.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 12, 2014 at 9:04 PM, Kevin Hilman <khilman@kernel.org> wrote:
> An even more exciting problem exists when a CPU is in the same domain as
> other peripherals, those peripherals are all idle and the power domain
> is gated. :)

We do have pm_genpd_attach_cpuidle() and pm_genpd_name_attach_cpuidle()?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
