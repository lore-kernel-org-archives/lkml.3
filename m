Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751709AbaARWHQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jan 2014 17:07:16 -0500
Received: from mail-la0-f42.google.com ([209.85.215.42]:62783 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751436AbaARWHM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jan 2014 17:07:12 -0500
MIME-Version: 1.0
In-Reply-To: <1390079163.25980.2.camel@x41>
References: <1390078081-26030-1-git-send-email-gurligebis@gentoo.org>
	<1390079163.25980.2.camel@x41>
Date: Sat, 18 Jan 2014 23:07:10 +0100
X-Google-Sender-Auth: kdeM6VasdjQQzJTTgbtyUuQUfsw
Message-ID: <CACPM=kVdNm+ZiZsfr1PTVzOBJi+ybOQVs5X=BycEeZxJLVEq_g@mail.gmail.com>
Subject: Re: [PATCH] Adding hyperv.h to uapi headers
From: Bjarke Istrup Pedersen <gurligebis@gentoo.org>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014/1/18 Paul Bolle <pebolle@tiscali.nl>
>
> Bjarke Istrup Pedersen schreef op za 18-01-2014 om 20:48 [+0000]:
> > This patch adds the hyperv.h header to the uapi folder, and adds it to the Kbuild file.
> > Doing this enables compiling userspace Hyper-V tools using the installed headers.
> >
> > Signed-off-by: Bjarke Istrup Pedersen <gurligebis@gentoo.org>
> > ---
> >  include/uapi/linux/Kbuild   |    1 +
> >  include/uapi/linux/hyperv.h | 1469 +++++++++++++++++++++++++++++++++++++++++++
> >  2 files changed, 1470 insertions(+)
> >  create mode 100644 include/uapi/linux/hyperv.h
>
> Now we have two identical files: include/linux/hyperv.h and
> include/uapi/linux/hyperv.h. That seems sub-optimal at best.
>
(Resending, since gmail seems to default to html mails...)

I agree, but it fixes the problem.

I have been thinking about other solutions, but so far, I haven't been
able to find one that solves it, so the tools build. (An option might
be to strip it from the __KERNEL__ part, to make it smaller, but I
don't know what difference that would make :-)

/Bjarke
>
> Paul Bolle
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
