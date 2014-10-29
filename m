Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755695AbaJ2ICH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 04:02:07 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:53072 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755306AbaJ2ICD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 04:02:03 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Axel Lin <axel.lin@ingics.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        arm@kernel.org
Subject: Re: [PATCH] soc: versatile: Add terminating entry for realview_soc_of_match
Date: Wed, 29 Oct 2014 09:01:59 +0100
Message-ID: <2097592.uX1sdbECvl@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAFRkauAP9+6VM40O-WLMKY5X5WrpyrCqBhjwVbWGSV2B_+DPXg@mail.gmail.com>
References: <1413733260.6272.1.camel@phoenix> <2588271.FpfytU43Wu@wuerfel> <CAFRkauAP9+6VM40O-WLMKY5X5WrpyrCqBhjwVbWGSV2B_+DPXg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:p3dgC+/Av20YZGvUTISi8zz8lOuYLbciRo1tBErAaQT
 nozZrvykU2WMmEcPDZ0pxeEBRx3aXEZ2DcCLA3vacVSjDkyTzA
 8bceb3uvY6/AQYIOCzUYUjAMB6pMOMqzhLDih1u7GsMkh8zX8z
 GGVaYEF7CaXusZ7h1rtvF3uMnVx5qGY/ngcE+UAdpwxZWJi2Lo
 SJ0k4nRfcK6bBCcIFJDZD/1uVrAtA5Wmqi9U0Ka+okfbF6zxhS
 ducUQmGIkXPhj8zuwj1FBl9CapwblUuD84kYFlyMIkTqZsJLK/
 oomB4QUVFo5S/hCg0TF/h1TPdpdI9PkE/5rS87FjmFHuDqMIkO
 rpEmD2ceOWahgo9gVowI=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 29 October 2014 08:48:11 Axel Lin wrote:
> >>
> >> Arnd are you merging this directly into ARM SoC?
> >>
> >
> > Applied to the fixes branch.
> Thanks.
> >
> > Please remember to add arm@kernel.org when you want us to pick up the
> > patches.
> scripts/get_maintainer.pl does not suggest arm@kernel.org for this patch.
> 
> $ scripts/get_maintainer.pl
> 0001-soc-versatile-Add-terminating-entry-for-realview_soc.patch
> Linus Walleij <linus.walleij@linaro.org>
> (commit_signer:1/1=100%,authored:1/1=100%,added_lines:144/144=100%)
> Arnd Bergmann <arnd@arndb.de> (commit_signer:1/1=100%)
> linux-kernel@vger.kernel.org (open list)
> 
> Maybe it needs update the maintainer entry?

We generally don't want developers other than subarch maintainers to
send us stuff directly and we certainly don't want to be Cc'd on
(literally, if you count every version in review) thousands of patches
per kernel release.

My comment was directed at Linus, who has sent us the updates for
vexpress recently and who was (rightfully) asking for the patch to
be picked up.

	Arnd
