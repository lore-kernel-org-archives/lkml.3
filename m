Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751316Ab3FJEUS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 00:20:18 -0400
Received: from ozlabs.org ([203.10.76.45]:44234 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750769Ab3FJEUQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 00:20:16 -0400
Message-ID: <51B553FE.6010201@ozlabs.org>
Date: Mon, 10 Jun 2013 12:20:14 +0800
From: Jeremy Kerr <jk@ozlabs.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Patchwork ML <patchwork@lists.ozlabs.org>
Subject: Re: [git pull] Please pull powerpc.git merge branch
References: <1370764616.14883.28.camel@pasglop> <CA+55aFz_E+x=Mr9Z6_09wzh1mXFr3a2VigPX77LzrsyLUFeb+Q@mail.gmail.com> <CA+55aFxAC4EksZcz7SaZNjF9mfKkwLjWp2rEKxMZT8m-7uBeNQ@mail.gmail.com> <51B53DAB.10501@ozlabs.org> <CA+55aFzHT3NWrF6gq+BaLcZmEtrFwkiXv0_qZ0jGjxTO6-8iPQ@mail.gmail.com>
In-Reply-To: <CA+55aFzHT3NWrF6gq+BaLcZmEtrFwkiXv0_qZ0jGjxTO6-8iPQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

> No. The date from the email was
> 
>     Date: Fri, 7 Jun 2013 15:42:54 +1000
> 
> and we want *that* date.

Ah, gotchya.

So, we now use the original date header (if present) in the mbox views:

$ wget -qO - http://patchwork.ozlabs.org/patch/249598/mbox/ | grep ^Date
Date: Fri, 7 Jun 2013 15:42:54 +1000

... for all your data-mining needs.

Cheers,


Jeremy
