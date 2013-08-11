Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755200Ab3HKXxG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Aug 2013 19:53:06 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:51108 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755169Ab3HKXxB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Aug 2013 19:53:01 -0400
Message-ID: <1376265179.17400.40.camel@dabdike>
Subject: Re: Patch for lost wakeups
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Long Gao <gaolong@kylinos.com.cn>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 11 Aug 2013 16:52:59 -0700
In-Reply-To: <20130811173942.GA10964@redhat.com>
References: <tencent_26310211398C21034BD3B2F9@qq.com>
	 <CA+55aFwAnWZGkXbyLmL3RxQGW-dX_jjDBPfA5PjxeVWn==a6tA@mail.gmail.com>
	 <20130808191749.GA12062@redhat.com>
	 <CA+55aFw+vEp6+q+QUZm5rf+sKR9z76HWzEqWjoiLtataym5uwA@mail.gmail.com>
	 <20130809130457.GA27493@redhat.com>
	 <CA+55aFxh+4yK3AkPQWGq+hGhBgvDdWuPSfzko2aO76y7ej=Veg@mail.gmail.com>
	 <tencent_293B72F26D71A4191C7C999A@qq.com>
	 <20130811173942.GA10964@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.8.3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-08-11 at 19:39 +0200, Oleg Nesterov wrote:
> On 08/10, Long Gao wrote:
> >
> >   By the way, could you help me join the linux kernel mailling list?
> 
> Do you mean, you want to subscribe?
> 
> Well, from http://www.tux.org/lkml/#s3-1
> 
>         send the line "subscribe linux-kernel your_email@your_ISP"
>         in the body of the message to majordomo@vger.kernel.org
> 
> but since I was never subscribed I do not really know if this works ;)
> 
> > I have sent two letters to "Linux Kernel Mailing List"<linux-kernel@vger.kernel.org>,
> > but did not receive any confirmation letter, except for two letters containing
> > instructions, 3X!
> 
> If you simply want to send emails to this list, you do not need
> to subscribe. However, I do not see your email in
> 
>         http://marc.info/?t=137598606900001
> 
> Perhaps this list doesn't like chinese letters in subject/body?

No, we get patches with UTC-16 characters in them OK.  The usual reason
vger drops an email is if there's a text/html part.

The information about what vger drops is here:

http://vger.kernel.org/majordomo-info.html

James


