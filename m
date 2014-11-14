Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161662AbaKNRgW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 12:36:22 -0500
Received: from mail-pd0-f181.google.com ([209.85.192.181]:46357 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161175AbaKNRgU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 12:36:20 -0500
From: Kevin Hilman <khilman@kernel.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Linux PM list <linux-pm@vger.kernel.org>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] PM / domains: Kconfig: always enable PM_RUNTIME when genpd enabled
References: <1415917702-6742-1-git-send-email-khilman@kernel.org>
	<1415917702-6742-2-git-send-email-khilman@kernel.org>
	<CAMuHMdXB-7vBqGZ_iMaZdDWDnnzpHZa4ECkDnojbDw=ds5eTWg@mail.gmail.com>
Date: Fri, 14 Nov 2014 09:36:17 -0800
In-Reply-To: <CAMuHMdXB-7vBqGZ_iMaZdDWDnnzpHZa4ECkDnojbDw=ds5eTWg@mail.gmail.com>
	(Geert Uytterhoeven's message of "Fri, 14 Nov 2014 08:29:06 +0100")
Message-ID: <7ha93t8z1q.fsf@deeprootsystems.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Geert Uytterhoeven <geert@linux-m68k.org> writes:

> Hi Kevin,
>
> On Thu, Nov 13, 2014 at 11:28 PM, Kevin Hilman <khilman@kernel.org> wrote:
>> It makes little sense to use generic power domains without runtime PM.
>
> Does it?
> It still powers down the PM domains on system suspend (at least on my
> boards ;-)

Sure, but your devices are also using runtime PM, so I'm not sure how
does that change my statement above?

>> Also, since the complexities of handling the !PM_RUNTIME case are
>> causing more trouble and confusion than they're worth, let's simplify
>> the world by making genpd always enable runtime PM.
>
> What do other people think?

Yes, I'm curious also.  This patch was supposed to be marked RFC.

Kevin
