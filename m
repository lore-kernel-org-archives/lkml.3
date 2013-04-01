Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758963Ab3DAXwA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 19:52:00 -0400
Received: from mail-ob0-f176.google.com ([209.85.214.176]:47112 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758203Ab3DAXv6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 19:51:58 -0400
MIME-Version: 1.0
In-Reply-To: <20130322221444.GJ15821@hansolo.jdub.homelinux.org>
References: <20130222181856.GA2419@hansolo.jdub.homelinux.org>
	<20130227175427.GQ26411@outflux.net>
	<20130227180145.GH2071@hansolo.jdub.homelinux.org>
	<CAGXu5j+ntBM5ZwO9Xqa3sWaEW3nSpR8wsL7poTJ6wZOp5x0Lhw@mail.gmail.com>
	<1361998001.2110.22.camel@localhost>
	<20130227221954.GJ2071@hansolo.jdub.homelinux.org>
	<CAGXu5j+aADfSpBcz9=LVtREQQiW4d3Jd8t7nQKbih7oUhvQghg@mail.gmail.com>
	<20130322145448.f44f9d10a36620c1c11535b7@linux-foundation.org>
	<20130322221444.GJ15821@hansolo.jdub.homelinux.org>
Date: Mon, 1 Apr 2013 16:51:57 -0700
X-Google-Sender-Auth: 7b0332c56uXoqbFXIVC36o7ekXI
Message-ID: <CAGXu5jL=Lg6OeWyhKBWHowwMeOpFipMOXmBosYHY53MfVMo8fA@mail.gmail.com>
Subject: Re: [PATCH] kmsg: Honor dmesg_restrict sysctl on /dev/kmsg
From: Kees Cook <keescook@chromium.org>
To: Josh Boyer <jwboyer@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Eric Paris <eparis@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Christian Kujau <lists@nerdbynature.de>,
        "# 3.4.x" <stable@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 22, 2013 at 3:14 PM, Josh Boyer <jwboyer@redhat.com> wrote:
> On Fri, Mar 22, 2013 at 02:54:48PM -0700, Andrew Morton wrote:
>>
>> poke.  Nothing got applied.  I'll drop
>> kmsg-honor-dmesg_restrict-sysctl-on-dev-kmsg.patch, see if that has any
>> effect ;)
>
> Oh dear.
>
> Eric, were you going to cleanup your suggestion and send it out?

Ping? What state is this in?

-Kees

--
Kees Cook
Chrome OS Security
