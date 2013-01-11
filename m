Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755606Ab3AKNSM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 08:18:12 -0500
Received: from multi.imgtec.com ([194.200.65.239]:52746 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755183Ab3AKNSJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 08:18:09 -0500
Message-ID: <50F010AA.2010708@imgtec.com>
Date: Fri, 11 Jan 2013 13:16:26 +0000
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: <linux-kernel@vger.kernel.org>, <linux-arch@vger.kernel.org>
Subject: Re: [PATCH v3 00/44] Meta Linux Kernel Port
References: <1357831872-29451-1-git-send-email-james.hogan@imgtec.com> <20130111103442.b80ddbfb11ef322ed28ca3b3@canb.auug.org.au> <50EFD824.3010502@imgtec.com> <20130112000336.1f24c42237fab4fe0c305ff6@canb.auug.org.au>
In-Reply-To: <20130112000336.1f24c42237fab4fe0c305ff6@canb.auug.org.au>
X-Enigmail-Version: 1.4.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="------------enig823A3CD30027C9D3E2467A1F"
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01181__2013_01_11_13_18_06
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--------------enig823A3CD30027C9D3E2467A1F
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Stephen,

On 11/01/13 13:03, Stephen Rothwell wrote:
> On Fri, 11 Jan 2013 09:15:16 +0000 James Hogan <james.hogan@imgtec.com>=
 wrote:
>>
>> On 10/01/13 23:34, Stephen Rothwell wrote:
>>> You really should not base development work on linux-next and before =
I
>>> can include it there you will need to rebase it onto Linus' tree (or =
some
>>> other tree that does not rebase).  Its OK to test by doing a merge wi=
th
>>> linux-next ...
>>
>> Thanks for the info Stephen. So I suppose if the patchset depended on
>> things in -next the normal way to do it would be to merge in the
>> individual trees I needed first?
>=20
> Yep, but please let the maintainers of those trees know that you expect=

> their tree to not be rebased.  Or, if if they aren't really dependencie=
s
> just conflicts, then leave the other tree out and let me and Linus fix
> the conflicts when we merge your tree.
>=20

Okay, thanks. Due to the recent merge window the dependencies are
trivial at the moment, and it wouldn't introduce build breakage to
exclude them (i.e. it's just removing selects from Kconfig files and
defconfigs that have been removed in linux-next), so I'll exclude those
changes for now and deal with them later.

Cheers
James


--------------enig823A3CD30027C9D3E2467A1F
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQ8BC8AAoJEKHZs+irPybfYfAP/jY3PVHNZdb4SHsvUII13uIR
/8mhNdpuIMMWSKHdXwCsu/A/AhbjIT77ubwtIQoZgfI6d3RIdzEKV3eyr0UcP0lW
JwG++P1wuSLSQTu9/pZVLR7LJsydFj2qsyQhnBNt1ApdjrkoEW+0nDrSfk6Wy0vY
5Wb0hSLft/CZRa5iWcXBt5JEI0VWPXwQBOXanrEfGCGFk97yB1Ysjj24PjJXaeJG
6/Ue3Dns2abEK1O+anzbYT/BrHEo9C+LtcxooNgD9G4NfjoNgJ+ZAFq1xRdmicqQ
19/wg99m7HfSLcf+GQhzSX7vi8wfvN/VQx1uf8/HlDoE5fiNNfqTM/tyeu7p2oRT
tgVGNuQSAqnT8Lr2hUExETHoS1lXJsyIuhxgDdEStROgexIWYDNflD5n2Z8/6aOl
cQ3UTsIY56+K2td5br3BX96RzuTniYNMSl4q1Q5QGsePwhLQBM++72txx3qhVKJY
FVn02bBGIqKd4vyVEJ0mCn8oLgv/PAGtP5Xjp3sZ92+kHyLVPvoFR7Wtc/sJyICy
zzR1Y1UW5STSJKqs9BvHbydpCzEFQ/8ulix8F6GlLeGJNfqDoWow0NSPOuWkxA8x
/3+oEbg81IeqFC0/98hnxmslJ9yxy07Q9JF9s5kNtT6c6ZJJmRK/xnQItrMqR1H3
Lcs+RmlKm8D3N0Lfb/+h
=tEmQ
-----END PGP SIGNATURE-----

--------------enig823A3CD30027C9D3E2467A1F--

