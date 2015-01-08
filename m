Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932229AbbAHK61 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 05:58:27 -0500
Received: from mail-qg0-f46.google.com ([209.85.192.46]:62277 "EHLO
	mail-qg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754251AbbAHK6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 05:58:25 -0500
Date: Thu, 8 Jan 2015 11:58:19 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Dmitry Osipenko <digetx@gmail.com>
Cc: Paul Walmsley <paul@pwsan.com>, linux-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
        Kumar Gala <galak@codeaurora.org>,
        Paul Walmsley <pwalmsley@nvidia.com>,
        Thierry Reding <treding@nvidia.com>, Allen Martin <amartin@nvidia.com>,
        Stephen Warren <swarren@nvidia.com>,
        Alexandre Courbot <gnurou@gmail.com>
Subject: Re: [PATCH] soc: tegra: pmc: restrict compilation of suspend-related
 support to ARM
Message-ID: <20150108105818.GJ1987@ulmo.nvidia.com>
References: <alpine.DEB.2.02.1412092224050.31750@utopia.booyaka.com>
 <20150107143354.GD1621@ulmo>
 <54AD4FB7.20600@gmail.com>
 <20150108084929.GA1987@ulmo.nvidia.com>
 <54AE5117.5020905@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cDtQGJ/EJIRf/Cpq"
Content-Disposition: inline
In-Reply-To: <54AE5117.5020905@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--cDtQGJ/EJIRf/Cpq
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 08, 2015 at 12:42:47PM +0300, Dmitry Osipenko wrote:
> 08.01.2015 11:49, Thierry Reding =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
> > I don't like changing this back to syscore_ops since it makes things
> > less easier to follow. I also don't think that using PMC_SCRATCH41 for
> > two different purposes is a good thing. There are a couple of
> > suggestions in my reply to your original patch. Could you investigate
> > whether any of those can be used to fix this instead?
> >=20
> > Thierry
> >=20
>=20
> I haven't received your reply. Double checked gmail inbox and mailing lis=
ts -
> nothing. It may just not propagated yet if you sent it today, otherwise c=
an you
> please re-send it?

For some reason it hadn't gone out. Should be now, though.

Thierry

--cDtQGJ/EJIRf/Cpq
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUrmLKAAoJEN0jrNd/PrOhEF0QAKZL9VnhGGzkZckDNq79lE0X
vyWDrdH2FuJ6SEhMFHkNGthGkIjTgTpS8SskRHlobvbhCpw+0p5OBYtp5z44lEx0
wizJyUBvpFQjnMLaUu8hdmUVr7BWiM2L0bGCe0mvjOgejWw6nK8sj7ZSnk469My3
N/CaPLOD3FvMMETSPlcw6s5qPnJvMXYS8hLzslzdRKEMlA8vk/8bA10KJmoHJgGu
bV0LMDMbc+HVeyEfzE5WWBnZj41aksOArDtu6VX+GkT8UUbWSOewM0ewnBfXoFg7
R2jjKVoECgL8txfrlonOo/bey/bTzfv2kZtox+kNKvTi8AuI9vglaL8FXoWT6bpx
IKJlXHZoeYFgaS8lYsEtuOPsi7wJHTOVwAPPT/EyzVqxVxJ/fqfnFDe//RexKovN
yXxaVu+WbTEWZZ0fSfdN+1KonnHc1XX37xCYEQisX5dgddz9ki9hDmaxAD+gPfFv
pT82ZabPLNXCP7juwAN18dFsgx2yUOm6KClxMAK6WDQfV+kOMKDPOScxUSdgHblS
CaSv2s5+V8uJ5A5zO1kbL2vPRnhDAPiYw56+vH8kn16YrcMzcNM+a3ZE1g6hEcmE
H6sfoXdASTNid8+OeB8LWLp6e4RjpXRxFjEd/KUr3MZEXm0Y+Z5ZGaFtRACb8lxx
Ej5RWFnWbChmpD+htSb1
=6piv
-----END PGP SIGNATURE-----

--cDtQGJ/EJIRf/Cpq--
