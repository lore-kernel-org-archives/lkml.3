Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757264AbaHGLqu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 07:46:50 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33130 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754267AbaHGLqt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 07:46:49 -0400
Date: Thu, 7 Aug 2014 21:46:39 +1000
From: NeilBrown <neilb@suse.de>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Dave Hansen <dave.hansen@intel.com>, Christoph Hellwig <hch@lst.de>,
        LKML <linux-kernel@vger.kernel.org>, lkp@01.org,
        Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [fs] e691fc4583e: -59.7% dbench.throughput-MB/sec
Message-ID: <20140807214639.62f5dbbb@notabene.brown>
In-Reply-To: <20140807105538.GC17655@localhost>
References: <20140807105538.GC17655@localhost>
X-Mailer: Claws Mail 3.10.1-123-gae895c (GTK+ 2.24.22; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/_jdrpvOopk6ODdPCq106otg"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/_jdrpvOopk6ODdPCq106otg
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 7 Aug 2014 18:55:38 +0800 Fengguang Wu <fengguang.wu@intel.com> wro=
te:

> Hi Neil,
>=20
> We noticed the below dbench regression on
>=20
> git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
> commit e691fc4583e512f936bd04efb870815fe1ed750d ("fs: allow ->d_manage() =
to declare -EISDIR in rcu_walk mode.")

Thanks.
That patch is buggy - Dan Carpenter found it.
A replacement has been sent to Al Viro who has acknowledged it.
So it should be good before it gets to Linus.

Thanks,
NeilBrown

--Sig_/_jdrpvOopk6ODdPCq106otg
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU+NnHznsnt1WYoG5AQL1pg/+I8G0eOMerpCj2CsenjOUkcpnmOE1kuRh
seJ9bcWnw5gW5Ib5xf/f1yYdAtondnW+uiBiQG8FEnt8dlx52V62MSLGTcT/GeZq
9sQF3E0Izq/QX/s6MubIv54cV/uBp6R+H5AVSN1Q1Zm5+nzHamLW84KZfN1uqURA
od6i1CuD/4y72DiZF+qRvmEH8YTJCemdgPXjvF+hSXEcHpu0QZ5zP4T+qdiYtvMZ
6wbI5dcYpG7wo3EiqXb/cBrd8I7HaxeH9BMmCaPoVJ4WaPi5eAzO9Auz/cb/XytD
2RGzWO1OxTw7WqUXTKiAjbBwwj3ksFIvZPEFz8GHFtwVAhi0O+h7u3e5Vfo47+XL
yYkAxgYUyUlMaIDk3iLXexYDKDCYHUzByKJbu2p8bcZzvHvwLvbNgelW7jBLRAl8
0+3XbmiP1LWM+sVKNtRZmOXZtkBlLXWoGJ8jC5goU5cW2LOEvsnQI3MynRNguVhh
3lmcedLexbC+d7ALX3iY4CAxCYUc7g9t9fK/rCvrsvnPCxCPGPf78HzCwIKn1ZL4
OuGh+5XZIqqiWvrGVNPdhSKjS2hZ9uDqW9E3/o62Sh4NPJeKB19q9mdBrYRGsC65
JEt+Ou8UDwtq5hayT1VZ6Lma/y5cpHG1Xa1zpn8hCI7ALQpj7Fz/06eWNxV1+wVn
9wBBxxOZKLE=
=xv9w
-----END PGP SIGNATURE-----

--Sig_/_jdrpvOopk6ODdPCq106otg--
