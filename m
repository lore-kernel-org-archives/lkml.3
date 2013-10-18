Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755081Ab3JRBao (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 21:30:44 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:58640 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754496Ab3JRBal (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 21:30:41 -0400
Message-ID: <1382059831.2794.18.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 3.8.y.z extended stable ] Linux 3.8.13.11 stable review
From: Ben Hutchings <ben@decadent.org.uk>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Kamal Mostafa <kamal@canonical.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        kernel-team@lists.ubuntu.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Date: Fri, 18 Oct 2013 02:30:31 +0100
In-Reply-To: <CAErSpo5+xbgTfBrQdP36PRfOFpQcdeSgOEBFFDCfZoqoAsch5g@mail.gmail.com>
References: <1381419752-29733-1-git-send-email-kamal@canonical.com>
	 <CAErSpo5+xbgTfBrQdP36PRfOFpQcdeSgOEBFFDCfZoqoAsch5g@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-ygFl47AUzDrW4ZcJ/aRK"
X-Mailer: Evolution 3.8.5-2 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-ygFl47AUzDrW4ZcJ/aRK
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2013-10-10 at 11:37 -0600, Bjorn Helgaas wrote:
> On Thu, Oct 10, 2013 at 9:40 AM, Kamal Mostafa <kamal@canonical.com> wrot=
e:
> > This is the start of the review cycle for the Linux 3.8.13.11 stable ke=
rnel.
>=20
> Would anybody be interested in adding some sort of "stable" tag to the
> subject lines of stable backport patches, e.g.,  instead of:
>=20
>   [PATCH 001/104] htb: fix sign extension bug
>=20
> something like:
>=20
>   [STABLE 3.8.13.11 001/104] htb: fix sign extension bug
>=20
> I don't mind having the stable patches on LKML, but it would be nice
> if it were easier to distinguish stable backports from new patches.  I
> know the patches are nicely threaded behind this message, but some
> readers don't really pay attention to that.

I agree that some distinction is needed, but I'm not convinced about
that precise format.  I don't think it's worth including version
components after the stable base version e.g. 3.2.  And I think that
including the version is a big enough clue that this is for a stable
branch and not mainline.

So I've changed my review script to put a subject prefix of 'PATCH 3.2'
before the patch number (and similarly in the cover letter).  But if
there's consensus that a more explicit tag is wanted then I'll follow
that.

Ben.

--=20
Ben Hutchings
Horngren's Observation:
                   Among economists, the real world is often a special case=
.

--=-ygFl47AUzDrW4ZcJ/aRK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIVAwUAUmCPN+e/yOyVhhEJAQry/w//WpRCUFuAIlxSNPxqlg+O7kAqG0dNz+DP
fP6rjEgvnDplTyWwQvGsASUKIARZrjGbTfK5kTRd+UyrT+WhGPWwoPOwxucpwGgD
ieU2dT4hsTcbJdC7HMBP9fKPtw94oqjTKByuLQkgXh+r7rtJCqWxVNtJJIjUcLWZ
IxxquQpFABOjs2+NqgsU2iUMC8UidDul3n46K3QAlgr7O1J7JOsqDmM7JR/1ur2n
37m3KCWXJYtvWjzeHf4i4fq7YAvskwTZuh9JRenSDekOTTyJQK6SQI4eG4V+vYhV
gB8iRclfIWxjuU4FF7n5CLk+lCcXSXVGN45kMWdPkvjJxcAtilzYYkBQ0fPndRB9
jTWN23t/Heo7smbVHso93epv6s+yY3YC+7q01e7oIdAPO27nkBxQpNx4GNk/0/hv
VWrloIAP1AtV19/rVpwqpw8Iu/mw4gbRXYq2fFfMC8Pw0YQOB5EjAf6MRc89G/+Q
q2C78jcqAyyYUduAfrNh6Iaz9cICqlflinMDe8fZJb5oe0PNO93fTg1IfHkHgSKQ
gFjsrhph3l2YYf56BO6DWbsmnByvN4YqdtrCdt2SyBquWoufyL+eewDr/gbbp9Dt
7TzPcV8xSKFye47ktHzfWUHFrQ4EzqrzCHGpfPDB+tOjWGuyJR6vByPh5xoTz5ut
9owo4VZ7/Qw=
=EVZb
-----END PGP SIGNATURE-----

--=-ygFl47AUzDrW4ZcJ/aRK--
