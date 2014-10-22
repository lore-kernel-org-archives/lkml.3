Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754551AbaJVI35 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 04:29:57 -0400
Received: from mail-qc0-f169.google.com ([209.85.216.169]:40315 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754506AbaJVI3x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 04:29:53 -0400
MIME-Version: 1.0
In-Reply-To: <CAMuHMdXwp3oBMFRQQVK1XusytxB_sNxJtJzMhAwdXecGxRJ=Ug@mail.gmail.com>
References: <1413882808-4669-1-git-send-email-jinkun.hong@rock-chips.com>
	<1413882808-4669-2-git-send-email-jinkun.hong@rock-chips.com>
	<20141021195854.GE8609@dtor-ws>
	<544725C4.4040703@rock-chips.com>
	<CAPDyKFp+aNJd_FEY6=-ubK0zvVDWh+x5ZsVG+AVpuBzpSqynOQ@mail.gmail.com>
	<CAMuHMdXwp3oBMFRQQVK1XusytxB_sNxJtJzMhAwdXecGxRJ=Ug@mail.gmail.com>
Date: Wed, 22 Oct 2014 10:29:51 +0200
Message-ID: <CAPDyKFrfigDH143NnSCtfeNAuH+SK86Lm60Lo8kTT5Sp3cTksg@mail.gmail.com>
Subject: Re: [PATCH v5 1/3] power-domain: add power domain drivers for
 Rockchip platform
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Hong jinkun <jinkun.hong@rock-chips.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Doug Anderson <dianders@chromium.org>,
        Heiko Stuebner <heiko@sntech.de>, linux-rockchip@lists.infradead.org,
        Jack Dai <jack.dai@rock-chips.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22 October 2014 10:07, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> On Wed, Oct 22, 2014 at 9:58 AM, Ulf Hansson <ulf.hansson@linaro.org> wrote:
>> Now, I just realized that while Geert added attach|detach_dev()
>> callbacks for the generic PM domain, those are both "void" callbacks.
>> It means the deferred probe error handling is broken for these
>> callbacks. We should convert the attach_dev() callback into an int, I
>> will cook a patch immediately.
>
> That was changed in v3:
>   - Move calling of the callbacks to a point where dev->pm_domain is
>     valid, so the domain parameter is no longer needed,

That's good.

>   - Make callbacks return void.
>

But not this. :-) Sorry, for being too quick in reviewing that time.

Kind regards
Uffe
