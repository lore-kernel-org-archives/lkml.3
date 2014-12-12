Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968218AbaLLNzj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 08:55:39 -0500
Received: from mailapp01.imgtec.com ([195.59.15.196]:59482 "EHLO
	imgpgp01.kl.imgtec.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S967907AbaLLNzh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 08:55:37 -0500
X-PGP-Universal: processed;
	by imgpgp01.kl.imgtec.org on Fri, 12 Dec 2014 13:55:34 +0000
Message-ID: <548AF3D5.8000109@imgtec.com>
Date: Fri, 12 Dec 2014 13:55:33 +0000
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: <mchehab@osg.samsung.com>
CC: Sifan Naeem <sifan.naeem@imgtec.com>, <linux-kernel@vger.kernel.org>,
        <linux-media@vger.kernel.org>, <james.hartley@imgtec.com>,
        <ezequiel.garcia@imgtec.com>
Subject: Re: [PATCH v2 3/5] rc: img-ir: biphase enabled with workaround
References: <1418328386-9802-1-git-send-email-sifan.naeem@imgtec.com> <1418328386-9802-4-git-send-email-sifan.naeem@imgtec.com> <548ADA82.80603@imgtec.com>
In-Reply-To: <548ADA82.80603@imgtec.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="3HKU0mwBHUS1N42qJILbOn6TdwRQPw0D6"
X-Originating-IP: [192.168.154.101]
X-ESG-ENCRYPT-TAG: b93fcccb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--3HKU0mwBHUS1N42qJILbOn6TdwRQPw0D6
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 12/12/14 12:07, James Hogan wrote:
> Hi Sifan,
>=20
> On 11/12/14 20:06, Sifan Naeem wrote:
>> Biphase decoding in the current img-ir has got a quirk, where multiple=

>> Interrupts are generated when an incomplete IR code is received by the=

>> decoder.
>>
>> Patch adds a work around for the quirk and enables biphase decoding.
>>
>> Changes from v1:
>>  * rebased due to conflict with "img-ir/hw: Fix potential deadlock sto=
pping timer"
>>  * spinlock taken in img_ir_suspend_timer
>>  * check for hw->stopping before handling quirks in img_ir_isr_hw
>>  * new memeber added to img_ir_priv_hw to save irq status over suspend=

>=20
> For future reference, the list of changes between patchset versions is
> usually put after a "---" so that it doesn't get included in the final
> git commit message. You can also add any Acked-by/Reviewed-by tags
> you've been given to new versions of patchset, assuming nothing
> significant has changed in that patch (maintainers generally add
> relevant tags for you, that are sent in response to the patches being
> applied).
>=20
> Anyway, the whole patchset looks okay to me, aside from the one questio=
n
> I just asked on patch 3 of v1, which I'm not so sure about. I'll let yo=
u
> decide whether that needs changing since you have the hardware to verif=
y it.
>=20
> So for the whole patchset feel free to add my:
> Acked-by: James Hogan <james.hogan@imgtec.com>

Mauro: Assuming no other changes are requested in this patchset, do you
want these resent with the moving of changelogs out of the main commit
messages?

Cheers
James


--3HKU0mwBHUS1N42qJILbOn6TdwRQPw0D6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUivPVAAoJEGwLaZPeOHZ6k6kQAJfLgUfnxfEiK/TjriTTBrxc
zuHgpbyrvCjHKtV1dyxJZUzeMfPBAKVKMYEQtDqCjmWk57M1NOC4ExaYIzdo8/Tx
8rz9qJj/bMOK38cpNGu5Acok1Xwy5wKJ98Pjp7TSrOirbiuKiRIUTN2EZxMw5vhJ
p5YgKeDww3DDWiQfUUVq0rAVl/6wP7xlwAsrCf7z5OlUcZ+3x7DdGMZmgyo1AIgq
ZeLiPoRB1kXgQInEShrVFrqgMus4nnZDsxli1LfDEhpO6GXQPt75s80U589rTi85
H9sh7WYUvJrmxcY0N7PNCRrFjxUUg0i5uOSHBypMbR/D4T+G6SBFFtl53arWOdtm
Uughymr//aTYzb18SvUbfNXYa6kgCQ2MVg8NcxMeNhIqH8A4I0djCacczeGf373E
7AWlNcDSuYiMOljkcKA+lJs3Zf34nh7PAdW9kAe6VTwCPQ5BAiX59vvWfpSwPzKE
3zWV2Xoe13DWvl5Fd9q4v2bX0JpA0vxgpaP7/yDMkh61RYdYTCZ9+WzieaH/N0Yl
zzaw6mTU/S3+Ysgc8txhkZ1IUz2W1DjaMmml1LJCxdbF/A95sjWGnuM6Kd4Q0hmP
Uyfk2C1OIiAlPZq6YQ/BVahgabD1IdG7sIOq/ZA1T45/HD3cSPuS0NsbxPohApjN
21irJy3kz6fFXtvw/AQr
=I+8u
-----END PGP SIGNATURE-----

--3HKU0mwBHUS1N42qJILbOn6TdwRQPw0D6--
