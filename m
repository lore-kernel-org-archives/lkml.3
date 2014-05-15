Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754374AbaEOTuU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 15:50:20 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41220 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370AbaEOTuR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 15:50:17 -0400
Date: Thu, 15 May 2014 19:50:11 +0000
From: Serge Hallyn <serge.hallyn@ubuntu.com>
To: Richard Weinberger <richard.weinberger@gmail.com>
Cc: LXC development mailing-list 
	<lxc-devel@lists.linuxcontainers.org>,
        "Michael H. Warfield" <mhw@wittsend.com>, Jens Axboe <axboe@kernel.dk>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Arnd Bergmann <arnd@arndb.de>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [lxc-devel] [RFC PATCH 00/11] Add support for devtmpfs in user
 namespaces
Message-ID: <20140515195010.GA22317@ubuntumail>
References: <1400103299-144589-1-git-send-email-seth.forshee@canonical.com>
 <20140515013245.GA1764@kroah.com>
 <1400120251.7699.11.camel@canyon.ip6.wittsend.com>
 <20140515031527.GA146352@ubuntu-hedt>
 <20140515040032.GA6702@kroah.com>
 <1400161337.7699.33.camel@canyon.ip6.wittsend.com>
 <20140515140856.GA17453@kroah.com>
 <CAFLxGvwfbVdLUq0NrSrQNYH+bTzYLuCE2moooHH319qRfDkS6Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFLxGvwfbVdLUq0NrSrQNYH+bTzYLuCE2moooHH319qRfDkS6Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Richard Weinberger (richard.weinberger@gmail.com):
> On Thu, May 15, 2014 at 4:08 PM, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> > Then don't use a container to build such a thing, or fix the build
> > scripts to not do that :)
> 
> I second this.
> To me it looks like some folks try to (ab)use Linux containers
> for purposes where KVM would much better fit in.
> Please don't put more complexity into containers. They are already
> horrible complex
> and error prone.

I, naturally, disagree :)  The only use case which is inherently not
valid for containers is running a kernel.  Practically speaking there
are other things which likely will never be possible, but if someone
offers a way to do something in containers, "you can't do that in
containers" is not an apropos response.

"That abstraction is wrong" is certainly valid, as when vpids were
originally proposed and rejected, resulting in the development of
pid namespaces.  "We have to work out (x) first" can be valid (and
I can think of examples here), assuming it's not just trying to hide
behind a catch-22/chicken-egg problem.

Finally, saying "containers are complex and error prone" is conflating
several large suites of userspace code and many kernel features which
support them.  Being more precise would, if the argument is valid,
lend it a lot more weight.
