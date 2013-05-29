Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935116Ab3E2Hbj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 03:31:39 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:41706 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935085Ab3E2Hbi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 03:31:38 -0400
Date: Wed, 29 May 2013 17:31:24 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Sergey Gerasimov <Sergey.Gerasimov@astrosoft-development.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Kumar Gala <galak@kernel.crashing.org>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] Add a new platform tree for ib8315.
Message-Id: <20130529173124.cf024a80cfcc67c07d428830@canb.auug.org.au>
In-Reply-To: <1369657581-19869-1-git-send-email-Sergey.Gerasimov@astrosoft-development.com>
References: <1369657581-19869-1-git-send-email-Sergey.Gerasimov@astrosoft-development.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.18; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__29_May_2013_17_31_24_+1000_+/feZyxH.ssLQ.Fs"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__29_May_2013_17_31_24_+1000_+/feZyxH.ssLQ.Fs
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Sergey,

On Mon, 27 May 2013 14:26:21 +0200 Sergey Gerasimov <Sergey.Gerasimov@astro=
soft-development.com> wrote:
>
>  arch/powerpc/configs/83xx/ib8315_defconfig | 2152 ++++++++++++++++++++++=
++++++

Please submit the result of "make savedefconfig" instead of this as it
will be much smaller.

Thanks.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__29_May_2013_17_31_24_+1000_+/feZyxH.ssLQ.Fs
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJRpa7QAAoJEECxmPOUX5FEjEYP/3yWukCbM906k1Xq3vGuBkjR
BYSTtORlX75RhdygPNdXaFR61IDgev5bw7CBCmxD7NDPLlwsNA3HAteTjlygt8xV
Q40tOVmQ9uboOC3GBA7IYxe5ELWh6hRMclffV0LxpWCr3hmO0uJyknS4tJJnp1u/
YBX89lLMOXGt4IKSVtz0+tIyjwgCQlF5E9jnupu7I6BRxQkUWU4xoGhY8m+jkfKg
drMZJQ/5k+PAHRR7gOBQNTApspFhCiVuDddsusvDVVXAf3sNigOOiFdNOg2uwAav
gTNwQXO2MgcEshiDb/BEp3FBEZDJQ8eIg0/dsVKWjgFmGCxQla4sT8nefheII29K
7N13VFab4brivhppRRRUHSQ3ZSOmgB+sXaw3WDgeaDDeGNVXz3/2rmB8KpHCG56P
e00gelIpvrheCVdZxcdziY1goZILm8l5f1naH6r0NY19dnIEB1SwBY+cwBvFB0/W
6B2bXbYTpDBD6vRfLi3NXCxCofP7lAEO1RfLEo6lp8JrjFPsA7NwpKOQR0QsKMRV
Bk5sXIMuCj5sAN48R/ZL2wIPmzwCbBhOlpQsWd9cNN96MNBentHKYhq/VndAuebF
YLc2wZMsJc6CkpH69k/qub0cf1eRIQ1Wl3lspt8Az21J+cKl6sWomlSc/y5XYlJp
LNnZboOrDm5K3FD+130l
=KyaI
-----END PGP SIGNATURE-----

--Signature=_Wed__29_May_2013_17_31_24_+1000_+/feZyxH.ssLQ.Fs--
