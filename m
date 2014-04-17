Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753030AbaDQHIY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 03:08:24 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:51024 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019AbaDQHIW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 03:08:22 -0400
Message-ID: <534F7DDC.5060006@ti.com>
Date: Thu, 17 Apr 2014 10:08:12 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fbdev <linux-fbdev@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [GIT PULL] fbdev fixes for 3.15
References: <534E4775.8010009@ti.com> <CA+55aFz7Hgjc9wmiriqGT8VXNF-7b0aUKf96r=TCP+1NOTSVeQ@mail.gmail.com>
In-Reply-To: <CA+55aFz7Hgjc9wmiriqGT8VXNF-7b0aUKf96r=TCP+1NOTSVeQ@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="HCsVGFT31XBGsUWQnMjisxtsNgphE6JWx"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--HCsVGFT31XBGsUWQnMjisxtsNgphE6JWx
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 17/04/14 02:04, Linus Torvalds wrote:
> On Wed, Apr 16, 2014 at 2:03 AM, Tomi Valkeinen <tomi.valkeinen@ti.com>=
 wrote:
>>
>> The drivers/video/Kconfig change in this pull request will conflict wi=
th the
>> fbdev reorder series, which is not yet in your tree. If that's an issu=
e, I can
>> resend this without the Kconfig change.
>=20
> I was actually hoping/expecting you to just resend the renaming
> rebased on top of 3.15-rc1. Or maybe you could do it on top of this.

Oh, sorry. I somehow got the impression that you were fine with what I
had sent, and you'll just merge it after -rc1.

I'll send a rebased version, based on fbdev-fixes-3.15. So pull this one
first.

 Tomi



--HCsVGFT31XBGsUWQnMjisxtsNgphE6JWx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJTT33cAAoJEPo9qoy8lh71/08QAKUBoAtTqZCd3+yTOXw+8iSm
tdgKcuJHXwJoKY4UqL3F0R9FXLjE6DD6M7iop7zEv7YSByUXnkCcmnyqIemaBJ8P
cV/c4H4vz6O/DInog9KqQeZpZ0AHN7zIh99rqd1PCnngtDUghmAQwn8AhRR0Ackt
cVofm+KjQoZMoMwgtcLI/PoPccv0FIaFBfOIXsR5C69Xj+GfNIrHqKz+TGb9tJOd
WMPvxJ/rl7U3esGO03pHAmAV9KZ768hKeYU9ZaJz0CDhSJdXjSP26PZdBbf3YNCK
9aBA0RoGnklbZ9RzoZ5lK6rHZuggwwDDx16os7f42zVJ9Gn+vbxCTuCObKJWz+K+
JNVs+LXzOcHCx7gGW6qxRtI2qTFjFBvav8DlXFvf0T3kZx0Mby2o1LPitBbbayLn
Jdy+HZoVNJnN1aE7bdjhD+yE6wfdcuytu9TSSbng4qgmUIokJICigTLnnGJ0M5vi
9xqSUg90Tb8+3XjE5+cZ6VfNy94jqzA6AHSwNp4YGyuXlrErmATivC6khLhCV/p/
8r7ICJxVOGrK5waCMqH3a3PPFCzg81gjwMsdGOvGOEDuu8TZsbMDrcWxnXcnyWV2
mR+qHg+baftzdQHt/0UGJgKLcGJJf0EFZKwRlyDYb7vSsxWtGlCET1LJT2vbrjGE
is/Vohm+zJA5w0I7op8J
=Ipv+
-----END PGP SIGNATURE-----

--HCsVGFT31XBGsUWQnMjisxtsNgphE6JWx--
