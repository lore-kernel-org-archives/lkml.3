Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753687AbaLBEbK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 23:31:10 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:41444 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752638AbaLBEbH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 23:31:07 -0500
Message-ID: <547D409F.7090004@gentoo.org>
Date: Mon, 01 Dec 2014 23:31:27 -0500
From: Richard Yao <ryao@gentoo.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.8.0
MIME-Version: 1.0
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
CC: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-api@vger.kernel.org
Subject: Re: Why not make kdbus use CUSE?
References: <20141129063416.GE32286@woodpecker.gentoo.org> <20141201142311.37c81ff1@lxorguk.ukuu.org.uk>
In-Reply-To: <20141201142311.37c81ff1@lxorguk.ukuu.org.uk>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="tS9NJEJItXTghmmhX0AdBmqND2G4KcK7g"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--tS9NJEJItXTghmmhX0AdBmqND2G4KcK7g
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 12/01/2014 09:23 AM, One Thousand Gnomes wrote:
>> told quite plainly that such distributions are not worth consideration=
=2E If kdbus
>> is merged despite concerns about security and backward compatibility, =
could we
>> at least have the shim moved to libc netural place, like Linus' tree?
>=20
> I would expect any other libc would fork the shim anyway (or just not
> bother with systemd in most cases).

If the shim were in glibc, then that would be reasonable, but the shim
is in systemd. That would make the systemd developers the gate keepers
ta kernel interface. If we are going to enforce Linus' stable API
policy, then the shim should be in a repository that has a track record
for interface stability, which the systemd developers simply do not
have. It was not that long ago that firmware loading was moved into the
kernel because they had caused problems. I do not think that the systemd
developers are the correct ones to assume stewardship over such code. If
kdbus is merged, I think the best situation would be to move it into
Linus' tree.


--tS9NJEJItXTghmmhX0AdBmqND2G4KcK7g
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJUfUCtAAoJECDuEZm+6ExkSlEQAJqpYK86k19nl/6ETvzkS0Np
Il9FpkT91xfhQq+Ur35ex7fdrGAgFTk+Fl5zDyQT9goSPN3G2z3wDBpgcsCGlPK9
JGFWcUOXfccOSpn361UkoYsh0LoNdvO427uHpAw8gLJH+xo19nPJpQqjeQx050gT
4ricEEFs2RfPwYUBi0/8vSBTaOtTZNBC/TnuuiFDGTj71DguRirmOpeOd+U2KQMm
s4ztABqMtm7RnCdyAVsjiiKz/c6DNSaQ0hRidQHVPNnzNr6vhJZUFt3Dvw3zmFQq
YPTy6DCqEMOOd3YligsVf1UNepWWAVsm/BtoNfMBMrcGJbpHjCDw7hC/R5sUfaRB
1FerHJAOf9Ldk9pFf0V75JyUALvPL3Wb0LJcHt1udBBP2kFdsu/DlZOpL2so16BI
/jYSdAwkBUaH7T/g0fvem9Nt4daTc+cvwTP6XthCr6vsEZc4C2EyKkZSCUzywcqa
rBI8kMDEtGStaLKZV+QaFtUi+v22QdYLu9jc1FKkD5Ljaxb3nX0InpxoQGzXC0li
kfw1PXjbBGj7MDJtoXoByulg5bU/afxU6TolXtSmfD2iJiTUJL5NR2wjJEwWrFaM
UHCgzvVUdfbS4toiUpTKdMazKNQuzNTSKUY+VwTM9WQyiI8C2hIOfellx0E/timO
HHtAeSi+JvInBYL9vV5/
=N/OZ
-----END PGP SIGNATURE-----

--tS9NJEJItXTghmmhX0AdBmqND2G4KcK7g--
