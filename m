Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751246Ab3EMEQk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 00:16:40 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:39580 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750721Ab3EMEQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 00:16:38 -0400
Date: Mon, 13 May 2013 14:16:29 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Eric Paris <eparis@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus <torvalds@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jeff Layton <jlayton@redhat.com>,
        Kees Cook <keescook@chromium.org>, Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: linux-next: manual merge of the akpm tree with Linus' tree
Message-Id: <20130513141629.70e8d36cf81873a8fd56af59@canb.auug.org.au>
In-Reply-To: <1368411070.929.19.camel@localhost>
References: <20130513120728.f3f469e5d71b39ec78800175@canb.auug.org.au>
	<1368411070.929.19.camel@localhost>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.17; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__13_May_2013_14_16_29_+1000_ZZxhVhZfXkJlIp=2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__13_May_2013_14_16_29_+1000_ZZxhVhZfXkJlIp=2
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Eric,

On Sun, 12 May 2013 22:11:10 -0400 Eric Paris <eparis@redhat.com> wrote:
>
> I thought I sent you a note asking for audit to get pulled into -next
> quite a while back.  I'll resend...

You sent an email on Jan 4:

> I know that Al hates audit so I created a new audit tree and decided to
> start trying to allow him to avoid the problem whenever possible.  So
> unless Al objects to me going around him except when I touch the VFS can
> you pull my new tree?
>
> git://git.infradead.org/users/eparis/audit.git

To which I replied:

> I really don't like getting new tree requests just as Linus is about to
> open the merge window.  Al says he will look at this stuff and put it
> into his audit tree
> (git://git.kernel.org/pub/scm/linux/kernel/git/viro/audit-current.git#for=
-next)
> by tomorrow, so I will wait for that.
>
> If you and Al come to some other arrangement, let me know.

I guess it fell through the cracks ...

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__13_May_2013_14_16_29_+1000_ZZxhVhZfXkJlIp=2
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRkGkdAAoJEECxmPOUX5FEweMQAJRMXQObk9HwNS9qd2MU6ENf
D+eC6qF6vNcXqminox5DOeOKiy74LqH7diZjYkI+1S13QB1ctzdaDObu6isapt/D
ZOPakWJls5EMgq3Etitq9QYqPD/8q91AIYU5WQJS8lYmbs+YPsRGlCFW+SUmzm1y
bW0yActMXEQudc4Krw9laR9+e3SErWZ2HeuZvDMuaMrThQ0+ALVH2sID3+nPpUMS
fxYDYp+y4k6zylMAJTwXDOX41yqRG7i8ooYcQ3CEju1rxUljdtvSRe8qzWD4y14P
ofLkxkRPZiOZ3sBbveem9yo2hyjvr3n5NLCYrGeAdJyCbNeNjNw3yAkUx4p3KvcS
kkDcdu68QqqtekPvgwt4wqOawL0zknKnXJSJ9T+rdiolJs5ujvKlr39mHfpWpoFJ
uX60msNT2MBDeUgwkzW9N+QUFRLnA8FltCYDHQ5mPdLQHqQR6g/Gs20/8aGR+tC/
Mwnf79tAsMBNar+g3kZp5f+27YgXD2hhXDnOQzT+kZf2ZS4BtJq4DXuhefoyG+le
25Rhsi44wVgu7YSPflcXt78OOkVYRMNMHESTnHEv8a4+5BWV8ZJEpUYVtbSgGAuk
QA586bHCm9gFFoKyWVTzV9DYzxVsqmdH3Gw7tc4cmA7DyzMKP82qvJcG05hyFXyd
lvWSOd1XFIhU/tLSofB8
=e10X
-----END PGP SIGNATURE-----

--Signature=_Mon__13_May_2013_14_16_29_+1000_ZZxhVhZfXkJlIp=2--
