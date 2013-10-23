Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753244Ab3JWKnR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 06:43:17 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:33161 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752697Ab3JWKnP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 06:43:15 -0400
Message-ID: <5267A840.60007@gmail.com>
Date: Wed, 23 Oct 2013 12:43:12 +0200
From: =?UTF-8?B?VmxhZGltaXIgJ8+GLWNvZGVyL3BoY29kZXInIFNlcmJpbmVua28=?= 
	<phcoder@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131005 Icedove/17.0.9
MIME-Version: 1.0
To: Daniel Kiper <daniel.kiper@oracle.com>
CC: The development of GNU GRUB <grub-devel@gnu.org>,
        boris.ostrovsky@oracle.com, david.woodhouse@intel.com,
        ian.campbell@citrix.com, jbeulich@suse.com, keir@xen.org,
        konrad.wilk@oracle.com, pjones@redhat.com,
        richard.l.maliszewski@intel.com, ross.philipson@citrix.com,
        stefano.stabellini@eu.citrix.com, xen-devel@lists.xen.org,
        linux-kernel@vger.kernel.org
Subject: Re: EFI and multiboot2 devlopment work for Xen
References: <20131021125756.GA3626@debian70-amd64.local.net-space.pl> <526599A8.9090501@gmail.com> <52663D54.2020800@gmail.com> <20131023070528.GQ3626@debian70-amd64.local.net-space.pl>
In-Reply-To: <20131023070528.GQ3626@debian70-amd64.local.net-space.pl>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="----enig2WBDAXFMQIRGMUUXUAEEX"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2WBDAXFMQIRGMUUXUAEEX
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 23.10.2013 09:05, Daniel Kiper wrote:
> Thanks. Could you send me a pointer to current multiboot2 protocol docs=
?
It's managed as "multiboot2" branch in our repo:
http://git.savannah.gnu.org/cgit/grub.git
Note: we're in process of moving from bzr to git which may cause the
link to change.


------enig2WBDAXFMQIRGMUUXUAEEX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)
Comment: Using GnuPG with Icedove - http://www.enigmail.net/

iF4EAREKAAYFAlJnqEAACgkQNak7dOguQgk5sQD/QKDCaebNrSyXzxWvkl8g0UHz
x6sOOs+liV7cmYz+34kA/0Ro4oL9hLUe9ccwgQSaf6M/Q79OEl4xfYa68ElOEgD3
=yg1b
-----END PGP SIGNATURE-----

------enig2WBDAXFMQIRGMUUXUAEEX--
