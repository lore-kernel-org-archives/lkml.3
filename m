Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757838Ab3IEIDD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 04:03:03 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:56308 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756452Ab3IEIC4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 04:02:56 -0400
Message-ID: <52283AA4.9050609@ti.com>
Date: Thu, 5 Sep 2013 11:02:44 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: David Herrmann <dh.herrmann@gmail.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fbdev <linux-fbdev@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [GIT PULL] fbdev changes for 3.12
References: <5228294E.8050401@ti.com> <CANq1E4Rd2eEaNnX8b3WAQcQX-T4+fR-4OMAtoSaAp9XwdGLpSg@mail.gmail.com>
In-Reply-To: <CANq1E4Rd2eEaNnX8b3WAQcQX-T4+fR-4OMAtoSaAp9XwdGLpSg@mail.gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="bFxOJFpLL21wXf0fh7EDUROE1vNTMeTX8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--bFxOJFpLL21wXf0fh7EDUROE1vNTMeTX8
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 05/09/13 10:48, David Herrmann wrote:

>> There's a conflict in drivers/video/simplefb.c, which you can resolve =
by using
>> the version in your tree.
>=20
> No, both need to be merged. The current version lacks support for
> ABGR8888. The fbdev tree lacks the DRM format, which should be:
>   { "a8b8g8r8", 32, {0, 8}, {8, 8}, {16, 8}, {24, 8}, DRM_FORMAT_ABGR88=
88 }

Ah, right you are. a8b8g8r8 looks too much like a8r8g8b8, so my morning
groggy eyes didn't see that.

>> I guess the simplefb changes were taken through Ingo's tree because th=
e series
>> includes x86 arch changes, but it would have been nice to see the patc=
hes in
>> the linux-next...
>=20
> simplefb was in linux-next. I also acked the fixup from Stephen. See
> this commit from a pre-3.12 -next tree:
>   http://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/commi=
t/include/linux/platform_data/simplefb.h?id=3D44ed8fb588e517a2ef917c6757e=
e11ee47348978

Right. And I have the mail about the conflict from Stephen in my
mailbox, which I had read, but successfully forgot about it during my
vacation.

So, what I said about conflict resolution and the series missing from
linux-next was wrong, and the conflict resolution in linux-next is what
should be used.

 Tomi



--bFxOJFpLL21wXf0fh7EDUROE1vNTMeTX8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJSKDqkAAoJEPo9qoy8lh71/lYP/RwSQQhZ1Kvq0sHWRF9tOmbY
eHT9vigbT0OCiCj0u7JLFwNnhN+reD0Fr3EgzlCY1kMyQtoiUl6z/rDpQbVzP3O1
Xin4z6es+KMNTVCk2kN9QiFaJuNH1I/C0u961YjED3Yxqwti7K+V3v0NqMZj7R9q
DUO+yHBhNnmKrh/1Pgzb0kOzMF/S++Q6qftdWO5A8OLb/CIhCrimNR//Yi9M6sYy
svyj5OUpEsda+JsCAvhxwaKZsn9hWjC9EOxQzSdFoRvcPW2BNQeOZKC92w+/rmG/
xpz8Kkbr6rcpIahn9avJnLvsfmw4pWViFmqH5GGTBynU3yMgIiiOOmMZTCnRVhW1
NU03dCdeCw4RaY0zACNkdPGLLDsQDxYevcNSRySKfT1h7mMS0/56RKA8lfimetwO
QPVk947gfLAA1RFyZkxEzsloZiA2qH/V1OUwEftMr1gfBfbORbtKlSTdcKLJzOIT
z8NQadYV1S6KkBxMlTe2Pw7z77gX8k2ok6jaWdD4Rdu0+y/USZZXhkOl/4ZM9iTm
N3Xh05zZj3VfuQs60ztfVemInn9kXYNwx5zvIujqT4+SkolIoHgNqualu4faE+/E
3Ba5YPrfzFGqtMmOMEfQf5YgMm3eSzl0ED2hfAb/32Vzb46yFHmlF4gBmXJh89MQ
usTRbZGPI10u5qJs9a2S
=ZE7L
-----END PGP SIGNATURE-----

--bFxOJFpLL21wXf0fh7EDUROE1vNTMeTX8--
