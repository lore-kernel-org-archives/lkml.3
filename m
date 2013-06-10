Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751985Ab3FJDgT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jun 2013 23:36:19 -0400
Received: from mail-ve0-f174.google.com ([209.85.128.174]:60767 "EHLO
	mail-ve0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751459Ab3FJDgS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jun 2013 23:36:18 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFxJxY3J2X7DsEY4nz050PmNFgsZRewQEPoVWc1gzdiLGw@mail.gmail.com>
References: <1370764616.14883.28.camel@pasglop>
	<CA+55aFz_E+x=Mr9Z6_09wzh1mXFr3a2VigPX77LzrsyLUFeb+Q@mail.gmail.com>
	<CA+55aFxAC4EksZcz7SaZNjF9mfKkwLjWp2rEKxMZT8m-7uBeNQ@mail.gmail.com>
	<51B53DAB.10501@ozlabs.org>
	<CA+55aFzHT3NWrF6gq+BaLcZmEtrFwkiXv0_qZ0jGjxTO6-8iPQ@mail.gmail.com>
	<CA+55aFxJxY3J2X7DsEY4nz050PmNFgsZRewQEPoVWc1gzdiLGw@mail.gmail.com>
Date: Sun, 9 Jun 2013 20:36:17 -0700
X-Google-Sender-Auth: 6zmGGI_HsFrgnXzTYbU41pnsgxs
Message-ID: <CA+55aFx684C7k8=2Fk53AOvfSkfUb_6DncCnOM8zU=jdhOQMuA@mail.gmail.com>
Subject: Re: [git pull] Please pull powerpc.git merge branch
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jeremy Kerr <jk@ozlabs.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Patchwork ML <patchwork@lists.ozlabs.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 9, 2013 at 8:20 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> .. the rationale for this is that the work pattern of people is
> actually interesting information. You can do things like this:
>
>     git log --pretty=%aD --author=Torvalds

Final side note: for me, and other git users that apply other peoples
patches, it's probably better to use

   git log --pretty=%cD --committer=Torvalds

instead.

Interestingly, that shows a different pattern than my "authorship"
statistics, which are mainly pull requests. It turns out I commit
patches much more in the afternoon. The reason is probably simple: in
the mornings, I have pull requests waiting from overnight, so a fair
number of pull requests where I am author at 9-11. But my biggest
source of patches tends to be Andrew Morton, who sends the patches in
the afternoon, so suddenly the commit counts skew towards being
between 3pm-8pm when you take all my commits into accoint.

Doing

    git log --since=6.months --pretty=%aD --grep=Signed.*Andrew.Morton

backs that up: most of the commits that have sign-offs by Andrew are
sent in the afternoon.

I just find details like that really interesting, where you can
actually mine for the workpatterns of people.

                   Linus
