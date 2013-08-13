Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758271Ab3HMTAc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 15:00:32 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:11929 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756967Ab3HMTAb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 15:00:31 -0400
X-IronPort-AV: E=Sophos;i="4.89,872,1367971200"; 
   d="asc'?scan'208";a="41831820"
Message-ID: <1376420427.19076.11.camel@Abyss>
Subject: Re: [Xen-devel] [PATCH v1][RFC] drivers/xen, balloon driver numa
 support in kernel
From: Dario Faggioli <dario.faggioli@citrix.com>
To: <konrad@darnok.org>
CC: David Vrabel <david.vrabel@citrix.com>,
        "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jan Beulich <JBeulich@suse.com>, Yechen Li <lccycc123@gmail.com>
Date: Tue, 13 Aug 2013 21:00:27 +0200
In-Reply-To: <CAPbh3ru-gq0oL-MFbXmWDWOLwXVqZSbKUSJbotBJVy7OLYgKbw@mail.gmail.com>
References: <1376316812-30346-1-git-send-email-lccycc123@gmail.com>
	 <1376339161.15390.281.camel@Solace> <520A2C52.3000804@citrix.com>
	 <CAPbh3ru-gq0oL-MFbXmWDWOLwXVqZSbKUSJbotBJVy7OLYgKbw@mail.gmail.com>
Organization: Citrix Ltd
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="=-mV1QggX6Q4MiLT3wGfIo"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-mV1QggX6Q4MiLT3wGfIo
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On mar, 2013-08-13 at 09:18 -0400, Konrad Rzeszutek Wilk wrote:
> On Tue, Aug 13, 2013 at 8:53 AM, David Vrabel <david.vrabel@citrix.com> w=
rote:
> > On 12/08/13 21:26, Dario Faggioli wrote:
> >>
> >> Mmm... Is that the case? I tried to apply it there and I have one fail=
ed
> >> hunk (#12). Anyway, could you please rebase it on the tip of some
> >> relevant git tree?
> >>
> >> Linus' tree would be fine, I guess:
> >>
> >> http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git
> >
> > This is the one I use for most of my development work.  I wouldn't use =
a
> > subsystem specific tree unless there were specific conflicts to resolve
> > before hand.
>=20
> Which we do:
>=20
> commit cd9151e26d31048b2b5e00fd02e110e07d2200c9
> Author: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> Date:   Sun Aug 4 15:39:40 2013 +0100
>     xen/balloon: set a mapping for ballooned out pages
>=20
Ok... So, working on Linus' tree on a daily basis, but at lease try to
rebase the changes on top of .../xen/tip.git sounds like a sane enough
workflow to me. :-)

Yechen, would you be fine with something like that?

How familiar are you with concepts like branches, merging and rebasing
in the context of git?

Allow me to give some (pseudo random) pointers:

http://git-scm.com/documentation
http://git-scm.com/book/en/Git-Branching-Basic-Branching-and-Merging
http://git-scm.com/book/en/Git-Branching-Rebasing
http://gitref.org/branching/
http://stackoverflow.com/questions/315911/git-for-beginners-the-definitive-=
practical-guide
http://sixrevisions.com/resources/git-tutorials-beginners/
http://www.sbf5.com/~cduan/technical/git/
  http://www.sbf5.com/~cduan/technical/git/git-2.shtml
  http://www.sbf5.com/~cduan/technical/git/git-3.shtml
  http://www.sbf5.com/~cduan/technical/git/git-5.shtml

Regards,
Dario

--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
-----------------------------------------------------------------
Dario Faggioli, Ph.D, http://about.me/dario.faggioli
Senior Software Engineer, Citrix Systems R&D Ltd., Cambridge (UK)


--=-mV1QggX6Q4MiLT3wGfIo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iEYEABECAAYFAlIKgksACgkQk4XaBE3IOsQ7cACgoX2UaoZlrms2HMAOvkWtEqdU
gRoAn06Oav3Gc1tDG5g0axUu8GXEEj9/
=SUFm
-----END PGP SIGNATURE-----

--=-mV1QggX6Q4MiLT3wGfIo--
