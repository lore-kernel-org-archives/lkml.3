Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754667Ab3CKVmg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 17:42:36 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47147 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753313Ab3CKVmf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 17:42:35 -0400
Date: Mon, 11 Mar 2013 14:42:34 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kees Cook <keescook@chromium.org>
Cc: Greg KH <gregkh@linuxfoundation.org>, Ben Hutchings <ben@decadent.org.uk>,
        Luis Henriques <luis.henriques@canonical.com>,
        LKML <linux-kernel@vger.kernel.org>, Julien Tinnes <jln@google.com>,
        PaX Team <pageexec@freemail.hu>, Emese Revfy <re.emese@gmail.com>
Subject: Re: + signal-always-clear-sa_restorer-on-execve.patch added to -mm
 tree
Message-Id: <20130311144234.88e2f35792a5157f9fb45c64@linux-foundation.org>
In-Reply-To: <CAGXu5jLxwKUT6hYij-u1BP3kPqq-h3p-JKUaGK_J8WWhOvYVsQ@mail.gmail.com>
References: <20130311202255.942745A4121@corp2gmr1-2.hot.corp.google.com>
	<CAGXu5jLcP1-6NpoSqi1kS+ShKwpTUkpLv6BsW6w39cpt9vKSxA@mail.gmail.com>
	<20130311140130.7effd02d12236dff081646d5@linux-foundation.org>
	<CAGXu5jLJwzxRtoU8A_gVbsPLdU6fyXZyBsr0EPxC9ngEhmDC0w@mail.gmail.com>
	<20130311142218.272033794123531b119ca68e@linux-foundation.org>
	<CAGXu5jLxwKUT6hYij-u1BP3kPqq-h3p-JKUaGK_J8WWhOvYVsQ@mail.gmail.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Mar 2013 14:33:18 -0700 Kees Cook <keescook@chromium.org> wrote:

> > patch #1: use SA_RESTORER, cc stable (please promise me this will work OK)
> 
> I don't have the ability to build all the architectures, but it seems
> like the best flag based on code review.

SA_RESTORER looks OK back to 3.5 (at least).

> > patch #2: switch to __ARCH_HAS_SA_RESTORER, no cc stable
> >
> > I'm assuming this is all for 3.10, btw.  If you think it should be in
> > 3.9 then you need to write scarier changelogs.
> 
> Well, I'm not sure it needs to be scarier; it's a serious local ASLR
> info leak. I was hoping it could go into 3.9 since the expectation is
> for it to go to stable, so why not put it in 3.9 now?

OK.

> Do you want me to spin up the 2-patch solution or is it too much of a hack?

Is OK, I have it all lined up.
