Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752084AbaEWAUz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 20:20:55 -0400
Received: from ozlabs.org ([103.22.144.67]:40222 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751310AbaEWAUy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 20:20:54 -0400
Date: Fri, 23 May 2014 10:20:47 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Cody P Schafer <cody@linux.vnet.ibm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Michael Ellerman <mpe@ellerman.id.au>, peterz@infradead.org,
        linux-kernel@vger.kernel.org, michael@ellerman.id.au, mingo@redhat.com,
        paulus@samba.org, imunsie@au1.ibm.com, acme@ghostprotocols.net,
        scottwood@freescale.com, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH v2] powerpc/perf/hv-24x7: use kmem_cache instead of
 aligned stack allocations
Message-ID: <20140523102047.5d0a14a1@canb.auug.org.au>
In-Reply-To: <537E8E1F.9020303@linux.vnet.ibm.com>
References: <537E78AD.1040409@linux.vnet.ibm.com>
	<1400798673-27522-1-git-send-email-cody@linux.vnet.ibm.com>
	<20140523094929.15f4613c@canb.auug.org.au>
	<537E8E1F.9020303@linux.vnet.ibm.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/7lk7t3eNv3Dn+vbTnG_PRf="; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/7lk7t3eNv3Dn+vbTnG_PRf=
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Cody,

On Thu, 22 May 2014 16:54:07 -0700 Cody P Schafer <cody@linux.vnet.ibm.com>=
 wrote:
>
> I've got a slight preference toward keeping it as is, which lets all of=20
> the non-error path code stay outside of if/else blocks (and the error=20
> handling is kept ever so slightly more consistent).

No problem.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/7lk7t3eNv3Dn+vbTnG_PRf=
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTfpRjAAoJEMDTa8Ir7ZwVz+AP/0TqYIgIjw/zvJ/mGM6Xvn6f
HlKSD6kOkyF37jTvve/rAM2C1Is8CG1O4gXoFYSBbaXncU4uHI8Xd9ZCciPxcEIm
nlqcWKw1sIqGPpn4yHXc9y2YjnThlvsV8sEZ+KaNsLN5ORxa3zKIEmXq01O4++04
iBuRaRirpc56asXHu75R3Lm9z9EICjKh0tGm3zSCLktRiOJfffQRYBD/o4l252M/
yCuTqqg4wyv3f/QWu3mCt64/YAdZZtX3WCByX2CQZr0PT6gUXcBtSpi/nyZ95jvv
cuM9H8b5hvFYZQQWYSZJHQ3SJdS5cIGkNbU0xhtM2qQcx+DmqRlLryRY8I2lehZ1
TjqcfTxpXyYmf4vKqFE2A1NWz8JopyUd9f9F5x6al03PlyTmtBQJ+23qlM5M8U5D
00PNRkhjAIKqyTmmt/lS4QBUVm8pG2vFiy95KreTiPOOBsB7VJktPNSpaLjNphuD
EdHggtfRUT/C2yJ9FCl7jMy0nTV33G9mHn9r4/L2PSTl13lN7Ovr46uNRz36Se9s
a+FrjKg6wm/SMU/5qjFEvZhd3t9jYieDzTPGqoETgsQlVDyhGsyqiTXgDri0Ndpf
1MVj7mDuoKQnFQsxTUGono4tS9bv5ItnJ+lCV8dZzz7aUasuEj9xwnYVdIYg84dB
EkGnst1dKvP10jHLEvsk
=7txK
-----END PGP SIGNATURE-----

--Sig_/7lk7t3eNv3Dn+vbTnG_PRf=--
