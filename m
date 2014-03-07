Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752049AbaCGCva (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 21:51:30 -0500
Received: from mail-oa0-f52.google.com ([209.85.219.52]:44940 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136AbaCGCv1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 21:51:27 -0500
MIME-Version: 1.0
In-Reply-To: <530CD45A.8050803@wwwdotorg.org>
References: <1392900697-27577-1-git-send-email-heikki.krogerus@linux.intel.com>
	<1392900697-27577-3-git-send-email-heikki.krogerus@linux.intel.com>
	<53062F97.3050407@wwwdotorg.org>
	<CAGb2v66-tDZhrm9dnXe+PdQTaLZbw20sw3uYzLor2eXpVWmPMA@mail.gmail.com>
	<5306E599.7020605@wwwdotorg.org>
	<CACRpkdZBvKU31EDX=6=wVLXaQDAqD6VHtaE_mGnFLr1UYQAH9g@mail.gmail.com>
	<530CD45A.8050803@wwwdotorg.org>
Date: Fri, 7 Mar 2014 10:51:27 +0800
Message-ID: <CACRpkdZo1UHyCHe20LqRefCvS9BOT-2XeQXiZzLDQzUz4=Yc-w@mail.gmail.com>
Subject: Re: [PATCH 2/4] net: rfkill: gpio: remove gpio names
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Alexandre Courbot <gnurou@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Rhyland Klein <rklein@nvidia.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Mark Gross <mark.gross@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 26, 2014 at 1:35 AM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 02/25/2014 02:13 AM, Linus Walleij wrote:

>> So it is basically there to satisfy the habit in some device
>> tree bindings to name gpio arrays instead of just passing gpios = <...>;
>> (The latter should be encouraged going forward.)
>
> Do you really want to switch from named GPIO lookups to index-based GPIO
> lookups?

I don't know what I want. I only know that ACPI and DT people
are starting to step on each others feet.

> Index-based lookups make it much harder to extend the DT
> binding in a backwards-compatible fashion, especially in the face of
> optional GPIOs (of which all of CD, WP, power are).

You're probably right. At the same time it makes the world complex
for the ambition to use the same interface for DT and ACPI alike.

Yours,
Linus Walleij
