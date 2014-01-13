Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752177AbaAMSdP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 13:33:15 -0500
Received: from void.printf.net ([89.145.121.20]:55201 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751623AbaAMSdN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 13:33:13 -0500
From: Chris Ball <chris@printf.net>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Johannes Berg <johannes@sipsolutions.net>,
        Rhyland Klein <rklein@nvidia.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Alexandre Courbot <acourbot@nvidia.com>, Rob Landley <rob@landley.net>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        "linux-gpio\@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 2/4] mmc: sdhci-acpi: convert to use GPIO descriptor API
References: <1389177657-29266-1-git-send-email-mika.westerberg@linux.intel.com>
	<1389177657-29266-3-git-send-email-mika.westerberg@linux.intel.com>
	<CACRpkdYhynQ4ooHcZyc-nrgVK9gbvtsYR6ZVv1u0sfBVEaK93A@mail.gmail.com>
Date: Mon, 13 Jan 2014 18:32:56 +0000
In-Reply-To: <CACRpkdYhynQ4ooHcZyc-nrgVK9gbvtsYR6ZVv1u0sfBVEaK93A@mail.gmail.com>
	(Linus Walleij's message of "Wed, 8 Jan 2014 12:54:13 +0100")
Message-ID: <86ppnvbulj.fsf@void.printf.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Wed, Jan 08 2014, Linus Walleij wrote:
> On Wed, Jan 8, 2014 at 11:40 AM, Mika Westerberg
> <mika.westerberg@linux.intel.com> wrote:
>
>> The new descriptor based GPIO interface is now the recommended and safer
>> way of using GPIOs from device drivers. Convert the ACPI SDHCI driver to
>> use that interface.
>>
>> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
>> Acked-by: Adrian Hunter <adrian.hunter@intel.com>
>> Acked-by: Alexandre Courbot <acourbot@nvidia.com>
>
> I've tentatively applied this to the GPIO tree now, as it was acked by
> Adrian who is a long time MMC subsystem contributor and we need
> it to proceed with the rest of the refactorings.
>
> Chris, beat me up if you're unhappy with this.
>
> (If it explodes in linux-next I'll just back it all out.)

That's fine.  Feel free to add:

Acked-by: Chris Ball <chris@printf.net>

Thanks,

- Chris.
-- 
Chris Ball   <chris@printf.net>   <http://printf.net/>
