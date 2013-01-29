Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753515Ab3A2UvF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 15:51:05 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:52077 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753187Ab3A2Uu7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 15:50:59 -0500
Date: Wed, 30 Jan 2013 07:50:57 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Cc: Arnd Bergmann <arnd@arndb.de>, James Hogan <james.hogan@imgtec.com>,
        <linux-kernel@vger.kernel.org>, <linux-arch@vger.kernel.org>
Subject: Re: [PATCH v3 00/44] Meta Linux Kernel Port
Message-Id: <20130130075057.3f03382b0c6e230850f60514@canb.auug.org.au>
In-Reply-To: <20130130074452.f67abeeaae3a00d046f5699f@canb.auug.org.au>
References: <1357831872-29451-1-git-send-email-james.hogan@imgtec.com>
	<5102BB38.3050207@imgtec.com>
	<201301260025.10020.arnd@arndb.de>
	<51062460.9060902@synopsys.com>
	<20130130074452.f67abeeaae3a00d046f5699f@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__30_Jan_2013_07_50_57_+1100_M9BJU2M6YabP_EhX"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__30_Jan_2013_07_50_57_+1100_M9BJU2M6YabP_EhX
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Vineet,

On Wed, 30 Jan 2013 07:44:52 +1100 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> On Mon, 28 Jan 2013 12:40:24 +0530 Vineet Gupta <Vineet.Gupta1@synopsys.c=
om> wrote:
> >
> > Stephen, can you please add the following branch (rebased off 3.8-rc5) =
to linux-next
> >=20
> > git://github.com/foss-for-synopsys-dwc-arc-processors/linux.git  arc-ne=
xt
>=20
> Added from today (though there may not be a linux-next release today).
>=20
> > While the first pull request can go directly from github, I presume the=
 logistics
> > for setting up accounts on kernel.org will only kick start after the fi=
rst batch
> > of code has been accepted. I can't seem to find any discussions on list=
s to that
> > effect.
>=20
> Linus prefers to not pull from github, but will if you ask him to pull a
> tag signed with a verifiable gpg key.  This is not a requirement if your
> tree is on kernel.org (though you still need a verifiable gpg key to get
> a kernel.org account).

I forgot the legal boilerplate:

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

--Signature=_Wed__30_Jan_2013_07_50_57_+1100_M9BJU2M6YabP_EhX
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRCDYxAAoJEECxmPOUX5FEoHsP/j8ke4kBYdt9zRFY0D/KGdmT
MqAC/bz+NXEDEmXjFj+YxpxvnHyHLTh96KeInwoeCZknTZ51cYHmW0aDejPF69gA
ZhyntmYOjJyoo7WJB127fuNPOa8B/R4dqPlnGa9enRMjgoFfdf57pu3zkFgV+9Fa
G3Pw8WLa0XcixeHiyL5CpTvWiTSf7/DzXw7EjNOmjy5nLMcuPTOipS6LrOoSl4J6
NvyLyayx/GuAiJRYWcz3dVA/db5JKfyaz8wnj2D+J0LBQ2+oRHIdKqEUHzHB6t1F
cC0PpyNinhWM3Yv1Wc4V7IOgpLc6918XfKDMlBk7dgdvy/mxcyrkqA3kx8AQNcf/
joVo9LvpQEgZ2BuoF5LGTlBB3J4wu4zLmD7SOXSYLFOgG8HTfgTWeKOcsxli65pu
lvbZoyZjghOhIZBUt5SEO8RZ+ncaCm4azrMCKUKNX4tJCRIi7x/ld1d5cia1xf8m
VHCDdM8vsYsl/dZB2RV4/RyQ3zeXjGtWt2SZ+vpMAcOCygC7RD7A8N7ukowqlud8
1wf1kmzutu6kdaBvzjILhoEj85pkG3xfz14MbNDEJLOvVEI/2VCKIVpO8l2HT1Yg
vLcoGH8zdJ6Q4uzL7qAQhjhkOg1RtcUWZvyA7YX8bDtHFIjrp4TeinGmL9zR/aee
+eXJg8RFdE0ADaaIth/7
=cSh+
-----END PGP SIGNATURE-----

--Signature=_Wed__30_Jan_2013_07_50_57_+1100_M9BJU2M6YabP_EhX--
