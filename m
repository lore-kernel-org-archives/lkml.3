Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753181AbaKEESm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 23:18:42 -0500
Received: from ozlabs.org ([103.22.144.67]:41465 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751129AbaKEESk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 23:18:40 -0500
Date: Wed, 5 Nov 2014 15:18:25 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paul Bolle <pebolle@tiscali.nl>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: linux-next: manual merge of the usb tree with the usb.current tree
Message-ID: <20141105151825.26c53948@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/Xm7sXO5zU+kDxsJCpZEa_oj"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/Xm7sXO5zU+kDxsJCpZEa_oj
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the usb tree got a conflict in
drivers/usb/host/Kconfig between commit cd6e245a2d06 ("usb: Remove
references to non-existent PLAT_S5P symbol") from the usb.current tree
and commit dd3cf17488b1 ("usb: host: Remove optional dependencies on
PLAT_S5P") from the usb tree.

I fixed it up (I used the usb tree version) and can carry the fix as
necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/Xm7sXO5zU+kDxsJCpZEa_oj
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUWaUWAAoJEMDTa8Ir7ZwVTxQP/1t2G9cRmBKARaiuJ/4k96XC
AmtCRwEFHKlaPCW5Ew5QKiugYuoI7IEr+4VixH1bpwSm7/J3Oj0Z20HjZT+ysqPx
Siojedgh6YHdC9hAtMjLoSw0dTSCNw0IJD+RDc9xmk37bmdXF2Yn4/KBwprLKfZJ
IL/HDCTziV4x3vtBDJjYgndWCknwe8+kOWVP+H0HUvyL2wyyE2KQBuQD/dauMX6h
SZ1vMXck1lNZqYqJvzKqBhnJrRXMQ1aLuH9sj7mCf+kgrw3+foEnO7wncMH2dTvm
RG7dhHpPbIl2fB3INs6ht7oEJQsxs9OA+JdoJjkPzJcuxPNjt7THIXNB36wYZOD5
bDaQETjZDQWO/+qN40Nxz2tzCE2xrH2PbfqWZR29zS1fyDCJlUQwVno4DE5MGP4r
dhv8luLK+SQawLpBidt04V3Rgi+P4KO+5OzS8l7YizCDHgypa0hDGK0kd/0LBxfL
+i7XTbqu9SRQnW7EvamqbuP/Iqx0PYDksoFRu3hatc6xesB7y0reZy6v6bLWtOk7
JNIlwejOziiPD2yvGxgLhWLffvNkknpdV3JTImdh74stVPyCXrpI1Js1LvvOplz6
Botfs0NwizcpP+zi36XKUJp/90hioIXGSbTrARQMjuP1UzZRrasmKrkCLLwiOPBC
6yapkyhMmk7c7uI461Fd
=2DAI
-----END PGP SIGNATURE-----

--Sig_/Xm7sXO5zU+kDxsJCpZEa_oj--
