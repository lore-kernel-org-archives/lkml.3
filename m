Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751482AbaACJd4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 04:33:56 -0500
Received: from mail-vc0-f177.google.com ([209.85.220.177]:58586 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125AbaACJdx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 04:33:53 -0500
MIME-Version: 1.0
In-Reply-To: <CAK5ve-KTQvJeLXmJt-NgPy6Ju+kBzWVoSQB7TKR9TW+mfD=bxg@mail.gmail.com>
References: <1388362275-1618-1-git-send-email-lgxue@hotmail.com>
	<20131230162158.7420e811@alan.etchedpixels.co.uk>
	<BLU172-W451DF59115DB2B0A7F694AACC90@phx.gbl>
	<20140101201053.12be7d27@alan.etchedpixels.co.uk>
	<alpine.DEB.2.02.1401011423180.27645@nftneq.ynat.uz>
	<20140101230135.48f6f781@alan.etchedpixels.co.uk>
	<alpine.DEB.2.02.1401011547340.27645@nftneq.ynat.uz>
	<CAK5ve-KTQvJeLXmJt-NgPy6Ju+kBzWVoSQB7TKR9TW+mfD=bxg@mail.gmail.com>
Date: Fri, 3 Jan 2014 10:33:51 +0100
Message-ID: <CAFLxGvwmS790goxNhO33p63MAic_bV8dpY+iMVFhuCUrxCWcbw@mail.gmail.com>
Subject: Re: [PATCH] Add LED pattern trigger
From: Richard Weinberger <richard.weinberger@gmail.com>
To: Bryan Wu <cooloney@gmail.com>
Cc: David Lang <david@lang.hm>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Joe Xue <lgxue@hotmail.com>, "rpurdie@rpsys.net" <rpurdie@rpsys.net>,
        "rob@landley.net" <rob@landley.net>,
        "milo.kim@ti.com" <milo.kim@ti.com>, "pavel@ucw.cz" <pavel@ucw.cz>,
        "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 3, 2014 at 1:14 AM, Bryan Wu <cooloney@gmail.com> wrote:
> IMHO, firstly we should take this trigger into kernel, most time it
> works as a module. But we need to define a good interface between
> kernel and user space.

Put it in first place into the kernel such that it becomes ABI and
nobody is allowed
to remove it later?

Better design a sane interface such that such complex LED operations
can be achieved
in userspace using an helper library.

-- 
Thanks,
//richard
