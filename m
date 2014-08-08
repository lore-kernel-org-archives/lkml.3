Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756811AbaHHNnm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 09:43:42 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:54694 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752839AbaHHNnl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 09:43:41 -0400
Date: Fri, 8 Aug 2014 15:43:36 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] driver core: Add missing parameter description to
 kerneldoc
Message-ID: <20140808134334.GA29840@ulmo.nvidia.com>
References: <1407490591-15754-1-git-send-email-thierry.reding@gmail.com>
 <20140808134147.GC4427@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GvXjxJ+pjyke8COw"
Content-Disposition: inline
In-Reply-To: <20140808134147.GC4427@kroah.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--GvXjxJ+pjyke8COw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 08, 2014 at 06:41:47AM -0700, Greg Kroah-Hartman wrote:
> On Fri, Aug 08, 2014 at 11:36:31AM +0200, Thierry Reding wrote:
> > From: Thierry Reding <treding@nvidia.com>
> >=20
> > The deferred_probe_work_func() takes a single parameter but the
> > kerneldoc doesn't describe it.
> >=20
> > Signed-off-by: Thierry Reding <treding@nvidia.com>
> > ---
> > Note that since the function is locally scoped there isn't all that much
> > point in having a kerneldoc comment for it, but since it's already there
> > might as well make it correct.
>=20
> How about just removing the kerneldoc format so this isn't an issue?

I can do that.

Thierry

--GvXjxJ+pjyke8COw
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT5NQGAAoJEN0jrNd/PrOhoQcP/3mh/woGcycC7TPiiH2Frrox
l7F0GqTgemWWA3VZw6sT7GIoS2Q/3WccGkRHcoZeRt51dXHwDLCaFzFQUE/R30ij
CoR9ogsr5lfDPB9ATxSt8f0z0so0eKpdHqi2+ElY4N+bho8pKRTKEELyO18O6YBp
nrK6+14p4GaEMap28jEMpk+KPaarP6ogyokkbIHPcawNs6cqcM7hjd8lKrh5QJuu
dW1JNJEKQPEpSXD90kQdwVOiBT1phPt9T+WCcm6KLcKPsBk9xNeH7c+j4K8jPOUq
iHvca9D1haHk5H+eY8mDG4F+Z1t2BDh1STlIF3j/NW7AJcxroJrMQdsn4RKgeSfO
4J0jlzjK8cS1kP3Fn8zKesHk4hf/3UJHn9Jwjic5G4dGC7YGyKQqQ8o3JF5Kl3P6
zHaxZ/SUk84A+Bw9aV8eEQ/CiKD+Dw0Jd3KqMCe5CJVx2/85abhTpKzG+2IsdnYk
lujFA7gADE4Hjs3RAi9OzIMSlxsq/Nj3x8TL13BXNsfiZ80sfedhBzcgibku+a4D
Fq8OokqRihTOiOgGoM9gXTCU4easAxxmr8KTpX18931P4aefqxLjJmTeS/wJnLDg
iZf2rypJCUsCd06xfAEYT3nI+M36LJCg0V4E5npaEWNU6PEcyXtesTgu8SPm3Io7
JyW7LCZXgOezz8pbeVRF
=nARP
-----END PGP SIGNATURE-----

--GvXjxJ+pjyke8COw--
