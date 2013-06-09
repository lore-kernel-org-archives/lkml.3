Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751515Ab3FIVdj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jun 2013 17:33:39 -0400
Received: from mail-vb0-f49.google.com ([209.85.212.49]:58133 "EHLO
	mail-vb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089Ab3FIVdi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jun 2013 17:33:38 -0400
MIME-Version: 1.0
In-Reply-To: <1370764616.14883.28.camel@pasglop>
References: <1370764616.14883.28.camel@pasglop>
Date: Sun, 9 Jun 2013 14:33:37 -0700
X-Google-Sender-Auth: Hjl1RFkVSEUg22_tYF77Xa61T44
Message-ID: <CA+55aFz_E+x=Mr9Z6_09wzh1mXFr3a2VigPX77LzrsyLUFeb+Q@mail.gmail.com>
Subject: Re: [git pull] Please pull powerpc.git merge branch
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 9, 2013 at 12:56 AM, Benjamin Herrenschmidt
<benh@kernel.crashing.org> wrote:
>
> Here are a few more powerpc changes for 3.10. I've merged your
> tree in at some point (which I generally avoid) in order to get
> the compat network fixes as soon as possible.
>
> Mostly regressions, and stuff I judged could/should still go in at
> this stage.

Not pulled, because your hamster smells of eldeberries.

This is not just bugfixes. In fact, as far as I can tell, this
*introduces* bugs, with that "get_user()" in the exception path that
can apparently happen with irqs disabled and will thus potentially
result in new warnings that just make things unreadable.

I'm f*cking tired of people having problems understanding "we're past
rc5". If it's not something you would call stable material, you
shouldn't send it to me.

              Linus
