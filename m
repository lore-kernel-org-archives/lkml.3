Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751426Ab3HTNZq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 09:25:46 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44603 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034Ab3HTNZo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 09:25:44 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: Kamal Mostafa <kamal@canonical.com>
Cc: Aaro Koskinen <aaro.koskinen@iki.fi>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: Re: [3.10][3.8][3.5] ARM: Fix FIQ code on VIVT CPUs (was Re: [PATCH 076/133] ARM: update FIQ support for relocation of vectors)
References: <1376692475-28413-1-git-send-email-kamal@canonical.com>
	<1376692475-28413-77-git-send-email-kamal@canonical.com>
	<20130818210952.GI3067@blackmetal.musicnaut.iki.fi>
	<1376928143.18111.12.camel@fourier>
Date: Tue, 20 Aug 2013 14:25:34 +0100
In-Reply-To: <1376928143.18111.12.camel@fourier> (Kamal Mostafa's message of
	"Mon, 19 Aug 2013 09:02:23 -0700")
Message-ID: <87mwoclcj5.fsf@canonical.com>
User-Agent: Gnus/5.130008 (Ma Gnus v0.8) Emacs/24.3.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Kamal Mostafa <kamal@canonical.com> writes:

> Thanks Aaro.  I'll apply "2ba85e7 ARM: Fix FIQ code on VIVT CPUs" to
> 3.8-stable.
>
> Greg KH and Luis Henriques:  Heads up!  3.10-stable and 3.5-stable also
> need 2ba85e7 but it isn't marked cc: stable.
>
>  -Kamal
>

Thanks.  I've also seen your IRC msg.  I'll hold this commit for now.

Btw, not sure if you've seen the discussion around

58ad436 genetlink: fix family dump race

Looks like there's a regression introduced by this commit.  I'm
holding it as well.

Cheers,
=2D-=20
Luis


>
> On Mon, 2013-08-19 at 00:09 +0300, Aaro Koskinen wrote:
>> On Fri, Aug 16, 2013 at 03:33:38PM -0700, Kamal Mostafa wrote:
>> > 3.8.13.7 -stable review patch.  If anyone has any objections, please l=
et me know.
>> >=20
>> > ------------------
>> >=20
>> > From: Russell King <rmk+kernel@arm.linux.org.uk>
>> >=20
>> > commit e39e3f3ebfef03450cf7bfa7a974a8c61f7980c8 upstream.
>> >=20
>> > FIQ should no longer copy the FIQ code into the user visible vector
>> > page.  Instead, it should use the hidden page.  This change makes
>> > that happen.
>>=20
>> FYI, this patch introduced regression (kernel crash) at least on Amstrad
>> E1 board (where FIQ is used for the keyboard). See the following thread:
>> http://marc.info/?t=3D137583169900003&r=3D1&w=3D2
>>=20
>> So any stable kernels where this patch was added should also take:
>>=20
>> 	commit 2ba85e7af4c639d933c9a87a6d7363f2983d5ada
>> 	Author: Russell King <rmk+kernel@arm.linux.org.uk>
>> 	Date:   Thu Aug 8 11:51:21 2013 +0100
>>=20
>> 	ARM: Fix FIQ code on VIVT CPUs
>>=20
>> That patch fixes the regression.
>>=20
>> A.
>>=20
>

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJSE25OAAoJENt0rrj9ziT8J+UQAKj4bTAdlqq81TCgPz9/F2aG
tyReRfSRfffX0Bl/PAMIhTVTt5JTyXMjhRf2kZH/8ocmGeUtynBGVCDesscXGbll
NU/tZyODuh0eeTFdGX51II27pRsbBr+OHLHAc/1kzh2/6HE6Nx6lI1sGAcQW2CMB
gA+wJPwk4HR16UIk2JRtWZHV/3YNXCOf9O4zey6zfUYQAYI3TId1NGZ3BpCBBqnL
DQRqlsp9Q+mMHXQA/eF9GKNKcBMXXYVuJGf1m7DPiLzNxUEkZ3Hn5hVK6WGUnRA8
cxSNBTGmSRDU/O2zQFxf2VGxZs4u30AVVMLCWQtZnfU9195mv+/8iyPJpB5udDMG
icwklbfNwLE30ve164hpu0CvAckmscJuWSHJ4XdSG57blN+pPzJ5/ihZDBKvYEuu
i+TV2oon9SJ71fxnzXRR0oCPCLvRqPWk4/O4msxnft2jU+Y9NA2zn9n4lMI/NtBp
oYtcjYWXEW1o3d1c7+MKl3sRx/mZfpHKgypE466c5MRm+O0NBwpZMHpmau38tVx/
531dp/3IMnYHAflvSGxO2cp5p4TPHWdo7R4g3CHivR54Isfa3P9Bhq4pqbkpWVZ8
g+0IMgzLbYnYbNeq0Tft89QFwDiDVyW8NLZmdHBZDw+NT72EJjXu6A9wEg6wXVL3
UtSsn2RKU6DyWBOTF/vh
=QNWu
-----END PGP SIGNATURE-----
--=-=-=--
