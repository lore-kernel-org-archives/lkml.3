Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751000AbaLOMHL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 07:07:11 -0500
Received: from mail-vc0-f177.google.com ([209.85.220.177]:34954 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750704AbaLOMHI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 07:07:08 -0500
MIME-Version: 1.0
In-Reply-To: <CAFrnU37L6WNsw6PmWiY6Ezic8U9EKOu+rYTvSFiBeKYjHkTZhg@mail.gmail.com>
References: <547ccf74.a5198c0a.25de.26d9@mx.google.com>
	<CA+55aFx0K=T8yvfRCYeaJG_5YO+Qm8EEQfA9Xp59xedbzj=f2A@mail.gmail.com>
	<20141201230339.GA20487@ret.masoncoding.com>
	<1417529606.3924.26.camel@maggy.simpson.net>
	<CA+55aFw8smHBw9HiCiYL_ohkULLeunWo6qfayM19zhF1hKAxXg@mail.gmail.com>
	<1417540493.21136.3@mail.thefacebook.com>
	<20141203184111.GA32005@redhat.com>
	<CA+55aFzLprvtdLGDXgRr=k3QqO824uQSzbxT-b4vu_4pryMtSA@mail.gmail.com>
	<20141205171501.GA1320@redhat.com>
	<CA+55aFxVeti8pU=Y_w54oGb8syGduOySAp-ag+KsCom-c12e-Q@mail.gmail.com>
	<20141205184808.GA2753@redhat.com>
	<20141206043719.66a1aec6@as>
	<CAFrnU35+_kPvOcBv0OWPzJF=X1SGP32gYogw2ZrH54z1Cu6bDg@mail.gmail.com>
	<CA+55aFz+WH+792=Rhec=X3t8h8jDqFrt-PSNLti6UsQPfMm6PA@mail.gmail.com>
	<CAFrnU37L6WNsw6PmWiY6Ezic8U9EKOu+rYTvSFiBeKYjHkTZhg@mail.gmail.com>
Date: Mon, 15 Dec 2014 13:07:06 +0100
Message-ID: <CAFrnU359E4+eiJzmHBtQ8RaWjGOPdpHHG+ckWU7HERzcLNAtHw@mail.gmail.com>
Subject: Re: frequent lockups in 3.18rc4
From: Martin van Es <mrvanes@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 12, 2014 at 1:58 PM, Martin van Es <mrvanes@gmail.com> wrote:
> On Sat, Dec 6, 2014 at 9:09 PM, Linus Torvalds
> I will give 3.18 a try on production J1900. Knowing I can go back to
> safety in 3.16.7 won't hurt too much of my reputation I hope.

3.18 froze twice (just to be sure) as well. Will commence the slow and
painful bisect between 3.16.7 and 3.17rc1 after I've established that
the latter freezes reliably.
I assume my problems are not linked to the RCU problems described in
this thread since I have no logging in kernel and different symptoms?
Should I start a new thread, or maybe better file a bug and report
progress on the bisect there? I won't be too noisy on the list with my
findings untill I'm done though.

Best regards,
Martin
--
If 'but' was any useful, it would be a logic operator
