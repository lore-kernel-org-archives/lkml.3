Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753669Ab3JVPji (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 11:39:38 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:51071 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752319Ab3JVPjh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 11:39:37 -0400
Message-ID: <52669C2C.90509@gmail.com>
Date: Tue, 22 Oct 2013 17:39:24 +0200
From: =?UTF-8?B?VmxhZGltaXIgJ8+GLWNvZGVyL3BoY29kZXInIFNlcmJpbmVua28=?= 
	<phcoder@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131005 Icedove/17.0.9
MIME-Version: 1.0
To: The development of GNU GRUB <grub-devel@gnu.org>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Ian Campbell <ian.campbell@citrix.com>, keir@xen.org,
        david.woodhouse@intel.com, stefano.stabellini@eu.citrix.com,
        Daniel Kiper <daniel.kiper@oracle.com>, linux-kernel@vger.kernel.org,
        xen-devel@lists.xen.org, Jan Beulich <JBeulich@suse.com>,
        ross.philipson@citrix.com, boris.ostrovsky@oracle.com,
        richard.l.maliszewski@intel.com
Subject: Re: EFI and multiboot2 devlopment work for Xen
References: <20131021135437.GD1283@fenchurch.internal.datastacks.com> <20131021185758.GD3626@debian70-amd64.local.net-space.pl> <1382433990.1657.66.camel@hastur.hellion.org.uk> <5266620602000078000FCA48@nat28.tlf.novell.com> <1382435127.1657.70.camel@hastur.hellion.org.uk> <526668A502000078000FCA7B@nat28.tlf.novell.com> <20131022134252.GA27302@phenom.dumpdata.com> <1382449985.18283.12.camel@hastur.hellion.org.uk> <20131022140947.GA17829@phenom.dumpdata.com> <1382451868.18283.21.camel@hastur.hellion.org.uk> <20131022145140.GA18679@phenom.dumpdata.com>
In-Reply-To: <20131022145140.GA18679@phenom.dumpdata.com>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="----enig2BWVKSVXKTGGIWNNLLBCG"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2BWVKSVXKTGGIWNNLLBCG
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 22.10.2013 16:51, Konrad Rzeszutek Wilk wrote:
> If you use 'linux' module, it will call ExitBootService.
> If you use 'multiboot' module, it will call ExitBootService too.
>=20
> So if you don't want to the module to call 'grub_efi_finish_boot_servic=
es'
> you need to use 'linuxefi' :-)
That's a very limited logic. Commands can be modified and protocols can
be extended.
There was only one e-mail explaining the needs and I answered with
proposing possible solutions yet the 2 e-mails in question were
completely ignored.
What's the need behind not calling ExitBootService? This is a point
which was never really explained to me. EFI specification specifically
tells to call ExitBootService.


------enig2BWVKSVXKTGGIWNNLLBCG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)
Comment: Using GnuPG with Icedove - http://www.enigmail.net/

iF4EAREKAAYFAlJmnCwACgkQNak7dOguQglZDwD/ZQBV6YYlR6r4FAavYI0rXlp5
f+yAvxeS4C2vr+blOEgA/0tbcECFzgDeusAE68qEJ4kvnNxf+wLAsiDiMrD3la6Z
=gysx
-----END PGP SIGNATURE-----

------enig2BWVKSVXKTGGIWNNLLBCG--
