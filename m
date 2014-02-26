Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752728AbaBZWWK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 17:22:10 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:43340 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751219AbaBZWWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 17:22:08 -0500
Date: Wed, 26 Feb 2014 22:21:51 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Kees Cook <keescook@chromium.org>
Cc: Matthew Garrett <matthew.garrett@nebula.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>, "H. Peter Anvin" <hpa@zytor.com>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        James Morris <jmorris@namei.org>,
        linux-security-module <linux-security-module@vger.kernel.org>
Subject: Re: Trusted kernel patchset for Secure Boot lockdown
Message-ID: <20140226222151.78854cd8@alan.etchedpixels.co.uk>
In-Reply-To: <CAGXu5j+b49grru-=DTRC0wx5LTOHN_jKL0Q++uW0Mzy+BxDf4w@mail.gmail.com>
References: <1393445473-15068-1-git-send-email-matthew.garrett@nebula.com>
	<CAGXu5j+b49grru-=DTRC0wx5LTOHN_jKL0Q++uW0Mzy+BxDf4w@mail.gmail.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > kernel was trusted - untrusted userspace could have set it on an untrusted
> > kernel, but by the same metric an untrusted kernel could just set it itself.
> >
> > If people object to this name then I swear to god that I will open a poll
> > on Phoronix to decide the next attempt and you will like that even less.

Go on open the poll -  I dare you. But don't be shocked if it ends up
being called "Eric" or "Icanhazsigs" 8)

> For the Chrome OS use-case, it might be better described as "untrusted
> userspace", but that seems unfriendly. :) The "trusted kernel" name
> seems fine to me.

Trusted is rather misleading. It's not trusted, it's *measured*.

It's the same bits you had when you made it, and when you booted it
before. Whether you trust them is a different and quite unrelated
question. You may have reasons to do either.

Alan
