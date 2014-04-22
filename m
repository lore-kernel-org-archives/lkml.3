Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752933AbaDVBhl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 21:37:41 -0400
Received: from [101.0.96.218] ([101.0.96.218]:36245 "EHLO pide.tip.net.au"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751167AbaDVBhi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 21:37:38 -0400
Date: Tue, 22 Apr 2014 11:37:11 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: Al Viro <viro@ZenIV.linux.org.uk>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>
Subject: Re: linux-next: manual merge of the userns tree with Linus' tree
Message-Id: <20140422113711.a5fdc95aa6fe6b309d2d38e1@canb.auug.org.au>
In-Reply-To: <874n1s73bu.fsf@x220.int.ebiederm.org>
References: <20140417150657.6d67e750081860b30f99715c@canb.auug.org.au>
	<20140417052500.GZ18016@ZenIV.linux.org.uk>
	<874n1s73bu.fsf@x220.int.ebiederm.org>
X-Mailer: Sylpheed 3.4.1 (GTK+ 2.24.23; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__22_Apr_2014_11_37_11_+1000_cBBu9Y5g0/_rIlFS"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__22_Apr_2014_11_37_11_+1000_cBBu9Y5g0/_rIlFS
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, 17 Apr 2014 01:44:21 -0700 ebiederm@xmission.com (Eric W. Biederman=
) wrote:
>
> Al Viro <viro@ZenIV.linux.org.uk> writes:
>=20
> > On Thu, Apr 17, 2014 at 03:06:57PM +1000, Stephen Rothwell wrote:
> >> Hi Eric,
> >>=20
> >> Today's linux-next merge of the userns tree got a conflict in
> >> fs/namespace.c between various commits from Linus' tree and various
> >> commits from the userns tree.
> >>=20
> >> I fixed it up (hopefully - see below) and can carry the fix as necessa=
ry
> >> (no action is required).
> >
> > Various commits include this:
> > commit 38129a13e6e71f666e0468e99fdd932a687b4d7e
> > Author: Al Viro <viro@zeniv.linux.org.uk>
> > Date:   Thu Mar 20 21:10:51 2014 -0400
> >
> >     switch mnt_hash to hlist
> >
> > present in v3.14...  It's been there since before the merge window.
>=20
> And the code that is in conflict is even older. =20
>=20
> I just figured out of an abundance of caution I would make certain the
> code was out there for automatic and semi-automatic things to pound on
> before I resent my pull request to Linus, now that I have fixed the
> stack overflow issue you were complaining about.
>=20
> I suspect something about fixing mntput caused Stephen to loose his
> trivial resolution for this trivial conflict.

That would be the three extra commits you added that touched that file -
it throws "git rerere" off and I didn't recognise the source of the
problem.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__22_Apr_2014_11_37_11_+1000_cBBu9Y5g0/_rIlFS
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTVcfMAAoJEMDTa8Ir7ZwVnZQQAJF3cK0HMec0nvqyQpqyNkmx
VXUAR/g6xI+MSFaL0QkCcy8DVyAmN9xDp5KC4icU6c5yNz0Feu8UrGKfgi3vE1fj
b2akFvIdTiA8nv3BywRESEdRzHlmyEgb9oGbJbgBpSANri7u9mnDwOlDgT4prt29
OKmRdKWLSzvBq07h2oNl6vulp0WQ0Dico4usjagb+pF/7fqwFDYq/2mclm7OOQ6z
yjZnUQKZ7Xt30DG9Ed+32COP7O5P8NGNb+k7zog+SH2XqF5viqmefGmmFnLL9dMw
uaqSzySv0QUJTu0l6GL4+w/BxlnCa15VRQqwFKKiTOMnPx8Y4exTplNRJ0EGNI6Q
8w+dN9WWLuxmHekXwc259fVY+hPxEl8l+UfbBDrf8l+PIjOHJvJXqPSE3EtHgEt5
YCulRilQC1DnqfomoMyFHhrh5q9F2nOcTGuhVoSHd9bYAu/tGuhU7BIvb91DkZWQ
1CP12Lc4ApNwuTBjCGteehvtuqORopxybZyvu/ijY86CZmt0pt8fdRCJ8/XsoSwL
OFNOEUmOsebigBxhe5dNAsEQR9Z3hTVl6cdC2vcQ56Ok62WKFC+7fqQQ6J8k0JrE
R0PKssyrys85diUtQLe1ZGSm1/fSK6oit7lHtVkIRqXHExkrzP+9miNyjM2i4gCu
Dd5F5z1JfDghMlrO+PC4
=zvQZ
-----END PGP SIGNATURE-----

--Signature=_Tue__22_Apr_2014_11_37_11_+1000_cBBu9Y5g0/_rIlFS--
