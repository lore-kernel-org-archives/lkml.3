Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751149Ab3FJEYZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 00:24:25 -0400
Received: from mail-vb0-f50.google.com ([209.85.212.50]:57792 "EHLO
	mail-vb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750812Ab3FJEYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 00:24:24 -0400
MIME-Version: 1.0
In-Reply-To: <51B553FE.6010201@ozlabs.org>
References: <1370764616.14883.28.camel@pasglop>
	<CA+55aFz_E+x=Mr9Z6_09wzh1mXFr3a2VigPX77LzrsyLUFeb+Q@mail.gmail.com>
	<CA+55aFxAC4EksZcz7SaZNjF9mfKkwLjWp2rEKxMZT8m-7uBeNQ@mail.gmail.com>
	<51B53DAB.10501@ozlabs.org>
	<CA+55aFzHT3NWrF6gq+BaLcZmEtrFwkiXv0_qZ0jGjxTO6-8iPQ@mail.gmail.com>
	<51B553FE.6010201@ozlabs.org>
Date: Sun, 9 Jun 2013 21:24:23 -0700
X-Google-Sender-Auth: OAx25giO_l6RcKMPAsvDeiRuJ18
Message-ID: <CA+55aFwWdYVnOPWN04x+WUkis3pTOk97gpWpM2y9hRvSiGh1Hg@mail.gmail.com>
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

On Sun, Jun 9, 2013 at 9:20 PM, Jeremy Kerr <jk@ozlabs.org> wrote:
>
> So, we now use the original date header (if present) in the mbox views:
>
> $ wget -qO - http://patchwork.ozlabs.org/patch/249598/mbox/ | grep ^Date
> Date: Fri, 7 Jun 2013 15:42:54 +1000
>
> ... for all your data-mining needs.

Goodie, and I see that it even works with old patches. Thanks.

               Linus
