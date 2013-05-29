Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967021Ab3E2Ux4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 16:53:56 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50317 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966896Ab3E2Uxs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 16:53:48 -0400
Date: Wed, 29 May 2013 13:53:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Arnd Bergmann'" <arnd@arndb.de>,
        "'Florian Tobias Schandinat'" <FlorianSchandinat@gmx.de>,
        "'Olof Johansson'" <olof@lixom.net>,
        "'Jean-Christophe PLAGNIOL-VILLARD'" <plagnioj@jcrosoft.com>,
        linux-fbdev@vger.kernel.org,
        "'Linus Torvalds'" <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        "'Tomi Valkeinen'" <tomi.valkeinen@ti.com>
Subject: Re: [RFC] Add co-maintainer for fbdev
Message-Id: <20130529135346.43ebe4c4565d90cec195e38e@linux-foundation.org>
In-Reply-To: <002301ce5c0c$5552b650$fff822f0$@samsung.com>
References: <20130524153835.GF15839@game.jcrosoft.org>
	<201305242056.42482.arnd@arndb.de>
	<51A29DB9.7030505@gmx.de>
	<201305282319.30311.arnd@arndb.de>
	<002301ce5c0c$5552b650$fff822f0$@samsung.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 May 2013 10:32:08 +0900 Jingoo Han <jg1.han@samsung.com> wrote:

> On Wednesday, May 29, 2013 6:20 AM, Arnd Bergmann wrote:
> > On Monday 27 May 2013, Florian Tobias Schandinat wrote:
> > > >> On Fri, May 24, 2013 at 8:38 AM, Jean-Christophe PLAGNIOL-VILLARD
> > > >> <plagnioj@jcrosoft.com> wrote:
> > > >>> Hi Florian,
> > > >>>
> > > >>>         As you seems very busy I'd like to propose the help you to handle the
> > > >>>         fbdev subsystem to easier the rich of the fbdev patch to Linus
> > > >>>
> > > >>>         As I'm working on fbdev on at91 and others and already Co-Maintain the
> > > >>>         at91 mach on ARM
> > > >>>
> > > >>>         And if you are not willing to continue I could take over
> > >
> > > Yeah, it would be great if you could help, at the moment I get barely
> > > any sleep, let alone that I could keep up with the majority of mail I
> > > get. I'll let you decide whether you want to be sole maintainer or not.
> > 
> > For any bigger subsystems, it's good practice to have two maintainers,
> > even if one of them does all the work. I think it makes sense to have
> > Jean-Christophe as the primary maintainer and owner of the git tree,
> > but it may also be good to have you or Tomi listed as a second maintainer
> > for times when Jean-Christophe isn't available.
> 
> Hi Arnd,
> 
> I agree with Arnd's opinion.
> It looks good to have Florian or Tomi listed as a second maintainer.

Someone send a patch!
