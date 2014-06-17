Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933177AbaFQW6Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 18:58:24 -0400
Received: from ozlabs.org ([103.22.144.67]:46689 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932442AbaFQW6X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 18:58:23 -0400
Date: Wed, 18 Jun 2014 08:58:16 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tejun Heo <tj@kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: the cgroup tree has an unnecessary merge
Message-ID: <20140618085816.09a261f0@canb.auug.org.au>
In-Reply-To: <20140617225403.GB8838@mtj.dyndns.org>
References: <20140618084921.07c3b391@canb.auug.org.au>
	<20140617225159.GA8838@mtj.dyndns.org>
	<20140617225403.GB8838@mtj.dyndns.org>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.23; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/lZ_Pdy4Rg/w9r9zBKEeFj6w"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/lZ_Pdy4Rg/w9r9zBKEeFj6w
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Tejun,

On Tue, 17 Jun 2014 18:54:03 -0400 Tejun Heo <tj@kernel.org> wrote:
>
> Heh, the mistake was in cgroup/for-3.16-fixes.  I branched it off the
> wrong base.  Thanks for noticing it early.  Fixed now.

Thanks.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/lZ_Pdy4Rg/w9r9zBKEeFj6w
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJToMgNAAoJEMDTa8Ir7ZwVIJYP/jijdwSYxuCZGTxE/Ri7/vhM
wWBjykqYtbs4lmu9WOKKdI6/L1dxuLTH133RGmBQmmpbhA9Vu+Vc4XphYDvijuxT
ip/h9ekRocMR1H1o68qiVfEPFfPYNEgYfxUp3jJg2bkgZSo7K6xYkyA0ocxixmx1
MQbbphBWqmEt+cyqK5P9PqVTRFEy9QOKgJx5IxNqAeJim1TItCr1vqYHFx0Gh5EY
wSf3Dhb7HqjFy7MhTBWqWAMJwrM4Ki3Ln8p1ykJCQfsOIaV36q1XN0VWD018mtxB
8nJ3OEfbe9bvkiRbHSNyaNojAQbcJKGCQ2uOiJOGDCiFuog4wgeLYhZLn8sUjpWD
ip4tze1J9kiVPfP/MGLzyFHjMdNeHmsHyojMpB7GPvSsN9uFXA32PhRW7L8dfeil
qmLgLkR5cMomA+9DF+HwbVuA5iIHZVp4G8tfxKGy+6Hx7J52MO6o/CTsG3dDFyLM
p9dqklREZMuHr9tVsvfKPRq6jMNH9S5AVrcXByGWPFyY+41LFORco2u8tgtz6jUi
YxlET/m1QXHMokOOAIYAT+B3ihZ46KvE6dSc/8HCKp6sNUcjS56a+Os0gs9rcJFr
zD1mmIeZQuYJmyr2BJIuza1vprtRk/w70pvRvkU5xE6cIhWhnyGS/daJxf45YgOf
BXSVklMZQa6/ogcYao+i
=z79q
-----END PGP SIGNATURE-----

--Sig_/lZ_Pdy4Rg/w9r9zBKEeFj6w--
