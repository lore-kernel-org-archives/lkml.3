Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759768Ab3D2V3V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 17:29:21 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:53443 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757790Ab3D2V3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 17:29:20 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PATCH] char/misc patches for 3.10-rc1
Date: Mon, 29 Apr 2013 23:29:14 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-18-generic; KDE/4.3.2; x86_64; ; )
Cc: David Brown <davidb@codeaurora.org>, Greg KH <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nicolas Pitre <nico@fluxnic.net>, Richard Kuo <rkuo@codeaurora.org>,
        linux-hexagon@vger.kernel.org
References: <20130429162115.GA6893@kroah.com> <8yafvy92gfs.fsf@huya.qualcomm.com> <CA+55aFxaMP+=uMLLvnLHz_E0GStrDf_zO3XhVCDGHbk=tV6CqA@mail.gmail.com>
In-Reply-To: <CA+55aFxaMP+=uMLLvnLHz_E0GStrDf_zO3XhVCDGHbk=tV6CqA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201304292329.14295.arnd@arndb.de>
X-Provags-ID: V02:K0:XueOMN+27NFuvgQzwfL4Un66CHNIDBkGx/hQG0FadWx
 zXuKgbZ1iJ1B1F8d0rDMXewMiQ9suxxlrmm2CrwMt+2NVFw6PK
 oZcdRL4KMAxY9QWwcEdqu4ZP6tRa3EQsZOgSx7QTdp5zmvfKUL
 U+TCdBVGZ9bVs6HT/jMeskz6H0k0IJGiLLGpjaEPkXkPsfyMTg
 D8+YdpKSnCMlwcMNewQs9dZCiB6/e3ogTA7PuzgQjKSiuxxopm
 22KnzP/fCiHstdopZQJZ3wgtscXiByCUBTAPhyOLM3tc/fRqcN
 5b7TINlk4m9ZGzcgO3Mze7QID/5H/ndNlviSFgYLD5k+tahWxZ
 +B2h0tA9FdExSKlBUBME=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 29 April 2013, Linus Torvalds wrote:
> Or maybe "drivers/platform/something-or-other" if there are possible
> other things that get shared together with this thing? I don't care
> that deeply, as long as it's just off in a little corner of the
> universe, rather than smack-dab in the middle.

I usually try to prevent ARM platform specific code to go into
drivers/platform, because of fear that this might become the place
that people use to sneak in code we would not allow them to add
to arch/arm/ for one reason or another. Based on David's explanation,
I think drivers/mfd makes the most sense. I'll follow up with a patch.

	Arnd
