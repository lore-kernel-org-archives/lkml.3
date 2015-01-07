Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753195AbbAGNhh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 08:37:37 -0500
Received: from smtp2-out.insa-rennes.fr ([193.52.94.25]:63075 "EHLO
	smtp2-out.insa-rennes.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751275AbbAGNhf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 08:37:35 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AuwEAJ01rVQKBQEm/2dsb2JhbABUCBaDQliDBsMwhXMCgVIBAQEBAX2EDQEDAiNVARALIRYLAgIJAwIBAgFFBg0BBwEBiDWvJZNHAQEBAQEBBAEBAQEBAQEbjyJWB4JogUEFj3qBKYcZhQEhg2eHSwKEEW4BAYJBAQEB
Message-ID: <54AD3692.7040903@supelec.fr>
Date: Wed, 07 Jan 2015 14:37:22 +0100
From: Laurent Georget <laurent.georget@supelec.fr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
CC: lkml <linux-kernel@vger.kernel.org>, Petr Gajdos <PGajdos@suse.cz>,
        John Stultz <john.stultz@linaro.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Jeff Epler <jepler@unpythonic.net>
Subject: Re: Request for review of adjtimex(2) man page
References: <54AD2C56.10700@gmail.com>
In-Reply-To: <54AD2C56.10700@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="eb7bPC2JHF3Ga1EWLXJMp5ATc8ErhittJ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--eb7bPC2JHF3Ga1EWLXJMp5ATc8ErhittJ
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hello,


>I've added a large number
> of FIXMEs in the draft below, and would be happy if anyone can supply
> some content to fill any of the gaps.

Isn't the man page going to be very long and hard to read if we explain a=
ll=20
the NTP internals in adjtimex.2? I think we could create a second man pag=
e
(for instance ntp.7) in section 7 to provide extensive explanations and r=
efer
to it from adjtimex.2. Does that seem okay?

> .BR STA_PLL
> Enable phase-locked loop (PLL) updates (read-write) via
> .\" FIXME Any pointer to further information about what this means?
> .\"       (It was not immediately obvious from a scan of the RFC, wheth=
er
> .\"       this is described in the RFC.)
> .BR ADJ_OFFSET .

> .BR STA_FLL
> Select frequency-locked loop (FLL) mode (read-write).
> .\" FIXME Any pointer to further information about what this means?
> .\"       (It was not immediately obvious from a scan of the RFC, wheth=
er
> .\"       this is described in the RFC.)

In this particular case, for example, PLL and FLL are the two modes by wh=
ich
the clock offset can be controlled. Roughly speaking, PLL is phase lockin=
g
(the clock time is adjusted to the source time) and FLL is frequency lock=
ing
(the clock frequency is adjusted to the source frequency). Is that level =
of
details be sufficient for adjtimex.2?

Valuable resources that go beyond the content of the RFC are publications=
 and
presentations from Pr. David Mills (http://www.eecis.udel.edu/~mills/) li=
ke
http://www.eecis.udel.edu/~mills/database/brief/clock/clock.pdf.

Cheers,

Laurent


--eb7bPC2JHF3Ga1EWLXJMp5ATc8ErhittJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iF4EAREIAAYFAlStNpcACgkQRTidSplJch5W/QD8Dz0CCSU2oRhrwU1pU8n7jDZb
4PLDSycZbV3ZeKMelT8BAIMNV+h7yQQEsQIqnU8RO42+CHGTIU9wui5qXWQRmKO9
=49lj
-----END PGP SIGNATURE-----

--eb7bPC2JHF3Ga1EWLXJMp5ATc8ErhittJ--
