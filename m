Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752391AbaLFUlI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2014 15:41:08 -0500
Received: from mail-qa0-f49.google.com ([209.85.216.49]:40985 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751590AbaLFUlG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2014 15:41:06 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFz+WH+792=Rhec=X3t8h8jDqFrt-PSNLti6UsQPfMm6PA@mail.gmail.com>
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
Date: Sat, 6 Dec 2014 12:41:04 -0800
X-Google-Sender-Auth: s6TOIcfGSKiHc2DorDCPXUwToLA
Message-ID: <CA+55aFyH+Kh+oSuQkxzFu=r7jABqzZ1VZSY-mswCTK51-YibQA@mail.gmail.com>
Subject: Re: frequent lockups in 3.18rc4
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Martin van Es <mrvanes@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 6, 2014 at 12:09 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Sat, Dec 6, 2014 at 8:22 AM, Martin van Es <mrvanes@gmail.com> wrote:
>>
>> Hope this may help in finding the right direction for this bug?
>
> If you can reproduce it with your spare J1900 system and could perhaps
> bisect it there, that would be a huge help.

Side note: your load sounds superficially more like the one Dâniel
Fraga had, who saw lockups with 3.17 but 3.18-rc7 actually works for
him.

But if you're running 3.17.3, I think you should already have all the
relevant fixes throuigh the -stable tree.

                       Linus
