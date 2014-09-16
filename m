Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754066AbaIPPBp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 11:01:45 -0400
Received: from bues.ch ([80.190.117.144]:42701 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753000AbaIPPBo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 11:01:44 -0400
Date: Tue, 16 Sep 2014 17:01:16 +0200
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: Amos Kong <akong@redhat.com>
Cc: virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        herbert@gondor.apana.org.au, mpm@selenic.com, rusty@rustcorp.com.au,
        amit.shah@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/3] hw_random: increase schedule timeout in
 rng_dev_read()
Message-ID: <20140916170116.65f8d883@wiggum>
In-Reply-To: <20140916002740.GA5671@zen>
References: <1410796949-2221-1-git-send-email-akong@redhat.com>
	<1410796949-2221-4-git-send-email-akong@redhat.com>
	<20140915181331.4e3f5fed@wiggum>
	<20140916002740.GA5671@zen>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/7=Ee=1KEUuR5Fsm=4e3N5nX"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/7=Ee=1KEUuR5Fsm=4e3N5nX
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 16 Sep 2014 08:27:40 +0800
Amos Kong <akong@redhat.com> wrote:

> Set timeout to 10:
>   non-smp guest with quick backend (1.2M/s) -> about 490K/s)

That sounds like an awful lot. This is a 60% loss in throughput.
I don't think we can live with that.

--=20
Michael

--Sig_/7=Ee=1KEUuR5Fsm=4e3N5nX
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUGFC8AAoJEPUyvh2QjYsO1rQP/3BUqE2P6lKKSVE6J0l47J/1
dgNKWEyQBPEa4wz7jcaQkniVEfTRbn5xZVFuVtdWGVLcLa3XCYWgveo3Jo4f/Aon
6t0nUZXEeENbi4hBYYrZ8LnG+12SqcYvaVSNCrTL4fCmfcYEv3OUdUiEYh5iw1Py
iFKDfUzohhbKlObgm2rMOCNXTv3ZPwKalE6cxvbKpbaAe/wVXHgVWhK9rGnQmzpA
Lk56gn/G7cDJ7G+HMT06p0qe2/QyFAJLNKVr8aOqCHMftRBkw8VhFYKX6P0EW7RI
ARH100K8ZPjxyyYjy3+rPbBSTEGX5ioddqAm1nwzMlRkXc9xB/Q34rlt0eoMRKmF
eiU9DcKu5DvrVsnmvj8cO1Htz2lYUMQsYRn2K5RIw0Ogej4buZHf0fkiSDwUupAV
CdTnekusbz58CwQSjAnikBvL0HykytmiQmjt43/BW41D4J5v6AETmO9pcqPORxle
CNTnPvAdeRlO5iEhyw3XTKzBidDHVi4h8uH311gWeXtq/NcfRcUpRHYWHBd6BB8w
pEYw0ukyxNkHFIDu0a7h88DgcwfvmViK5Cvl3z1djkIKaPRrONCkaXv+mLCz6LrO
kcf9lM8LMhWvyzo8/+gs3miFMROCNG+u7W3r1cBraZ8MlD+ZOp1Je9rvEuXFHe1M
45cPqwNkbt4hswTlBjCl
=8+vG
-----END PGP SIGNATURE-----

--Sig_/7=Ee=1KEUuR5Fsm=4e3N5nX--
