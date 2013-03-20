Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754733Ab3CTXrz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 19:47:55 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:41181 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751054Ab3CTXry (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 19:47:54 -0400
Date: Thu, 21 Mar 2013 10:47:47 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Alexandre Courbot <gnurou@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: New tree for linux-next
Message-Id: <20130321104747.b34175b397b5b16d61040fae@canb.auug.org.au>
In-Reply-To: <CAAVeFuLjqFoOyqoWWT9fKjs6AB5DU9nT5p+nJ5uhaaUeh4_MXg@mail.gmail.com>
References: <CAAVeFuLjqFoOyqoWWT9fKjs6AB5DU9nT5p+nJ5uhaaUeh4_MXg@mail.gmail.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__21_Mar_2013_10_47_47_+1100_SQoxbRztmAJuaD2g"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__21_Mar_2013_10_47_47_+1100_SQoxbRztmAJuaD2g
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Alexandre,

On Wed, 20 Mar 2013 23:02:14 +0900 Alexandre Courbot <gnurou@gmail.com> wro=
te:
>
> I am currently trying to get rid of the GENERIC_GPIO config option in
> order to center GPIO support around gpiolib. The patch series has been
> rather welcome and I collected a few acks, but since the change is
> rather intrusive and affects a lot of of architectures, it has been
> suggested that I submit it as a separate branch on linux-next to see
> how it (mis)behaves (full discussion is visible at
> https://lkml.org/lkml/2013/3/13/74 ).

OK, that seems sensible.

> So I have set up a branch on github on
> git://github.com/Gnurou/linux.git , for_next branch. Could you include
> it in linux-next to see if people start complaining about broken
> builds? I also actually have a couple questions about the submission
> process:

Added from today.  I have called it gen-gpio and you are the only listed
contact (in case I have problems with it).

> - My branch is based on the latest stable, similarly to what I have
> seen elsewhere. One of the patches triggers a merge conflict on
> today's linux-next due to a whitespace change. Is there something I
> can do to fix this?

Do not worry about merge conflicts, that is my and Linus' job.

> - By the meantime, another person has submited a new patch that
> re-uses the option I am trying to remove. Is there a way for me to
> base on given next release to fix this as well? Or should I contact
> that person to ask him not to use this option anymore?

The latter.  Also if you could supply me (and them) with any hints on how
to cope with the merge problem, that would help.

One point:  if this branch is meant to be merged by others, it *must not*
be rebased or rewritten, it can only be appended to.

Thanks for adding your subsystem tree as a participant of linux-next.  As
you may know, this is not a judgment of your code.  The purpose of
linux-next is for integration testing and to lower the impact of
conflicts between subsystems in the next merge window.=20

You will need to ensure that the patches/commits in your tree/series have
been:
     * submitted under GPL v2 (or later) and include the Contributor's
	Signed-off-by,
     * posted to the relevant mailing list,
     * reviewed by you (or another maintainer of your subsystem tree),
     * successfully unit tested, and=20
     * destined for the current or next Linux merge window.

Basically, this should be just what you would send to Linus (or ask him
to fetch).  It is allowed to be rebased if you deem it necessary.

--=20
Cheers,
Stephen Rothwell=20
sfr@canb.auug.org.au

Legal Stuff:
By participating in linux-next, your subsystem tree contributions are
public and will be included in the linux-next trees.  You may be sent
e-mail messages indicating errors or other issues when the
patches/commits from your subsystem tree are merged and tested in
linux-next.  These messages may also be cross-posted to the linux-next
mailing list, the linux-kernel mailing list, etc.  The linux-next tree
project and IBM (my employer) make no warranties regarding the linux-next
project, the testing procedures, the results, the e-mails, etc.  If you
don't agree to these ground rules, let me know and I'll remove your tree
from participation in linux-next.

--Signature=_Thu__21_Mar_2013_10_47_47_+1100_SQoxbRztmAJuaD2g
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRSkqjAAoJEECxmPOUX5FEbs8P/1wdmi5Dw0qYiAWdwTjsFSr1
HSM8LxtmjkYRtmtWFzFa7MgMNbV05QNe7TBZzhid/F+Ya8SHnz/Sex1ooXfJ0m18
UyRjlnGYlQH6Rd7xD5M7HIWqFqN/ccv/yDTQ9Dy948TOuS8StzxeKvJ0fRebbd6O
0EWiM1BBoi4FDD7SKcpL+OG00X8S0YTPO+iaDhP3wn9z5c5nGmiWywgACBFoJJP+
UNmaSdZFEhuZbvX9qQPJ6pX+OnVG7lbubd4uX318lkmW0Phmfhm+R61zr0MRtsCK
NcCSzVWtM/DNgfHzu1W7B8d2PFFz7mdYWld5WobdHLGRLtXOgvM3g7VkmPlVJ2fL
61wIniw1+C6O3qk0nFBYvYo4m7iGqgcVXr9T4jscktJgdx0GTNPqwCRPdbTLkbdD
x3czn30Ty4e7uwYJNf9Fd783vpZtAaYHVgGeneNtfVgljuyZg0Pd7AZwKdM1xCEC
eIsnvXWdjziAQYsXhJ3CLG6uMqeWot+16je6LNdaIxp3ZzrXmUZXk0bvUvKXmST8
Z+TukK/8MTnmnMha8CdduSSx80PtuuL+RA3HTFKJ8+QzPrSMRAFefkocYBi8A6No
cBB4vwrAXsQDU8wT0nsH028RBNUnxh+2ZLattuYXgNTHLVGmdOwtsWV+iSXG94g7
u8Jnj6ji78gqaxA46Zby
=SSyf
-----END PGP SIGNATURE-----

--Signature=_Thu__21_Mar_2013_10_47_47_+1100_SQoxbRztmAJuaD2g--
