Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752878Ab3JWRCA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 13:02:00 -0400
Received: from mail-ee0-f43.google.com ([74.125.83.43]:46891 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751275Ab3JWRB7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 13:01:59 -0400
Message-ID: <52680103.50601@gmail.com>
Date: Wed, 23 Oct 2013 19:01:55 +0200
From: =?UTF-8?B?VmxhZGltaXIgJ8+GLWNvZGVyL3BoY29kZXInIFNlcmJpbmVua28=?= 
	<phcoder@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131005 Icedove/17.0.9
MIME-Version: 1.0
To: The development of GNU GRUB <grub-devel@gnu.org>
CC: Jan Beulich <jbeulich@suse.com>, ian.campbell@citrix.com,
        konrad.wilk@oracle.com, keir@xen.org, david.woodhouse@intel.com,
        stefano.stabellini@eu.citrix.com, daniel.kiper@oracle.com,
        linux-kernel@vger.kernel.org, mjg59@srcf.ucam.org,
        xen-devel@lists.xen.org, ross.philipson@citrix.com,
        boris.ostrovsky@oracle.com, richard.l.maliszewski@intel.com
Subject: Re: [Xen-devel] EFI and multiboot2 devlopment work for Xen
References: <20131021185758.GD3626@debian70-amd64.local.net-space.pl> <1382433990.1657.66.camel@hastur.hellion.org.uk> <5266620602000078000FCA48@nat28.tlf.novell.com> <1382435127.1657.70.camel@hastur.hellion.org.uk> <526668A502000078000FCA7B@nat28.tlf.novell.com> <20131022134252.GA27302@phenom.dumpdata.com> <1382449985.18283.12.camel@hastur.hellion.org.uk> <20131022140947.GA17829@phenom.dumpdata.com> <1382451868.18283.21.camel@hastur.hellion.org.uk> <1382455358.18283.31.camel@hastur.hellion.org.uk> <20131022162632.GB19189@phenom.dumpdata.com> <1382517150.22417.21.camel@hastur.hellion.org.uk> <526803E902000078000A56D3@nat28.tlf.novell.com>
In-Reply-To: <526803E902000078000A56D3@nat28.tlf.novell.com>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="----enig2HRPXMTJBVPKNGVMHOVJJ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2HRPXMTJBVPKNGVMHOVJJ
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

> GrUB - which iiuc stays in memory
> after transferring control - could export its file system support to it=
s
> descendants).

Xen shouldn't need to load any file after multiboot2 entry point. The
needed files would already be in memory with pointers to them passed.
If you insist on being able to load directly from EFI, then IMO the best
way is to have a PE executable with one of sections containing Xen and
code which would load remaining files to memory and call common entry poi=
nt.



------enig2HRPXMTJBVPKNGVMHOVJJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)
Comment: Using GnuPG with Icedove - http://www.enigmail.net/

iF4EAREKAAYFAlJoAQMACgkQNak7dOguQgktqAEApWB2vyLUSH9cNvT+1CJ5KN/X
nEQnGvn8Yc/EJ0OxpUQA/3R/VLuWOngk+k5JwT0mD+Zp6gJ19mmH6ugUQshKngm6
=bis2
-----END PGP SIGNATURE-----

------enig2HRPXMTJBVPKNGVMHOVJJ--
