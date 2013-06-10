Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751985Ab3FJCpE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jun 2013 22:45:04 -0400
Received: from ozlabs.org ([203.10.76.45]:35191 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751026Ab3FJCpD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jun 2013 22:45:03 -0400
Message-ID: <51B53DAB.10501@ozlabs.org>
Date: Mon, 10 Jun 2013 10:44:59 +0800
From: Jeremy Kerr <jk@ozlabs.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Patchwork ML <patchwork@lists.ozlabs.org>
Subject: Re: [git pull] Please pull powerpc.git merge branch
References: <1370764616.14883.28.camel@pasglop> <CA+55aFz_E+x=Mr9Z6_09wzh1mXFr3a2VigPX77LzrsyLUFeb+Q@mail.gmail.com> <CA+55aFxAC4EksZcz7SaZNjF9mfKkwLjWp2rEKxMZT8m-7uBeNQ@mail.gmail.com>
In-Reply-To: <CA+55aFxAC4EksZcz7SaZNjF9mfKkwLjWp2rEKxMZT8m-7uBeNQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

> Is Jeremy the patchwork maintainer?

Yep, that's me.

> and it turns out that apparently 'patchwork' is just making up random
> times, because when you download the email as an mbox, it will turn
> this into that corrupt and incorrect
> 
>     Date: Thu, 06 Jun 2013 19:42:54 -0000
> 
> thing which is apparently how you got the wrong timestamp to begin with.

We keep all patch dates in UTC, but were generating the Date header
incorrectly. Now fixed:

$ wget -qO - http://patchwork.ozlabs.org/patch/249598/mbox/ | grep ^Date
Date: Fri, 07 Jun 2013 05:42:54 -0000

Commit is at:

 http://git.ozlabs.org/?p=patchwork;a=commitdiff;h=e7353352

Cheers,


Jeremy
