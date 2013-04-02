Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758344Ab3DBBGC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 21:06:02 -0400
Received: from mx3-phx2.redhat.com ([209.132.183.24]:36646 "EHLO
	mx3-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756559Ab3DBBF7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 21:05:59 -0400
Date: Mon, 1 Apr 2013 21:05:51 -0400 (EDT)
From: Josh Boyer <jwboyer@redhat.com>
Reply-To: Josh Boyer <jwboyer@redhat.com>
To: Kees Cook <keescook@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Eric Paris <eparis@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Christian Kujau <lists@nerdbynature.de>,
        "# 3.4.x" <stable@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Message-ID: <1256775981.281402.1364864751771.JavaMail.root@redhat.com>
In-Reply-To: <CAGXu5jL=Lg6OeWyhKBWHowwMeOpFipMOXmBosYHY53MfVMo8fA@mail.gmail.com>
References: <20130222181856.GA2419@hansolo.jdub.homelinux.org> <CAGXu5j+ntBM5ZwO9Xqa3sWaEW3nSpR8wsL7poTJ6wZOp5x0Lhw@mail.gmail.com> <1361998001.2110.22.camel@localhost> <20130227221954.GJ2071@hansolo.jdub.homelinux.org> <CAGXu5j+aADfSpBcz9=LVtREQQiW4d3Jd8t7nQKbih7oUhvQghg@mail.gmail.com> <20130322145448.f44f9d10a36620c1c11535b7@linux-foundation.org> <20130322221444.GJ15821@hansolo.jdub.homelinux.org> <CAGXu5jL=Lg6OeWyhKBWHowwMeOpFipMOXmBosYHY53MfVMo8fA@mail.gmail.com>
Subject: Re: [PATCH] kmsg: Honor dmesg_restrict sysctl on /dev/kmsg
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.5.82.12]
X-Mailer: Zimbra 8.0.3_GA_5664 (ZimbraWebClient - FF19 (Linux)/8.0.3_GA_5664)
Thread-Topic: kmsg: Honor dmesg_restrict sysctl on /dev/kmsg
Thread-Index: iNb9h0/VZTb4bmZU6Qi68I0YV53sNw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message -----
> From: "Kees Cook" <keescook@chromium.org>
> To: "Josh Boyer" <jwboyer@redhat.com>
> Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Eric Paris" <eparis@redhat.com>, "Linus Torvalds"
> <torvalds@linux-foundation.org>, "Christian Kujau" <lists@nerdbynature.de>, "# 3.4.x" <stable@vger.kernel.org>,
> "LKML" <linux-kernel@vger.kernel.org>
> Sent: Monday, April 1, 2013 7:51:57 PM
> Subject: Re: [PATCH] kmsg: Honor dmesg_restrict sysctl on /dev/kmsg
> 
> On Fri, Mar 22, 2013 at 3:14 PM, Josh Boyer <jwboyer@redhat.com> wrote:
> > On Fri, Mar 22, 2013 at 02:54:48PM -0700, Andrew Morton wrote:
> >>
> >> poke.  Nothing got applied.  I'll drop
> >> kmsg-honor-dmesg_restrict-sysctl-on-dev-kmsg.patch, see if that has any
> >> effect ;)
> >
> > Oh dear.
> >
> > Eric, were you going to cleanup your suggestion and send it out?
> 
> Ping? What state is this in?

If Eric doesn't send a patch tomorrow, I will.  Fedora is carrying my
original patch, but I'd rather get this fixed everywhere.

josh
