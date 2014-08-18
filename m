Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751910AbaHRONp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 10:13:45 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:46768 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751837AbaHRONn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 10:13:43 -0400
Date: Mon, 18 Aug 2014 08:18:32 -0500
From: Mark Brown <broonie@kernel.org>
To: Tim Kryger <tim.kryger@gmail.com>
Cc: Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Ulf Hansson <ulf.hansson@linaro.org>, Chris Ball <chris@printf.net>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        Haijun Zhang <Haijun.Zhang@freescale.com>,
        Doug Anderson <dianders@chromium.org>, Olof Johansson <olof@lixom.net>,
        Yuvaraj Kumar C D <yuvaraj.cd@gmail.com>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-ID: <20140818131832.GS14537@sirena.org.uk>
References: <1408019940-11153-1-git-send-email-javier.martinez@collabora.co.uk>
 <CAD7vxxKvzxvmzgx=S5ZZn54ts99ca2TqBYFvY1SXZQZDkhjq3w@mail.gmail.com>
 <20140814151958.GY17528@sirena.org.uk>
 <CAD7vxxLHtk2ywHGoBtDp6x3-5BtDdaFnCdc_pfgMwq63Cg8Qow@mail.gmail.com>
 <53EDBB5B.4000209@collabora.co.uk>
 <CAD7vxxKvZCxnDpPn3X1Uch_6m7Hfj_vApNfxUS2Wex9BjjBUdg@mail.gmail.com>
 <20140815222914.GM17528@sirena.org.uk>
 <CAD7vxxKTk2Na9B4ae6EGT8HaKDRp0iu4zX1tB8DPtmePKbHrLw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="o0y1lerN6xYE2ROn"
Content-Disposition: inline
In-Reply-To: <CAD7vxxKTk2Na9B4ae6EGT8HaKDRp0iu4zX1tB8DPtmePKbHrLw@mail.gmail.com>
X-Cookie: Beware of Bigfoot!
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 216.80.64.155
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/1] mmc: core: Use regulator_get_voltage() if OCR mask
 is empty.
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--o0y1lerN6xYE2ROn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Aug 17, 2014 at 10:11:30AM -0700, Tim Kryger wrote:
> On Fri, Aug 15, 2014 at 3:29 PM, Mark Brown <broonie@kernel.org> wrote:

> > Nobody has written suitable code, and please bear in mind that even if
> > the code is written there will probably be cases where it's too
> > expensive for whatever reason so Javier's change is going to be needed.

> I fail to see how replicating similar logic at all current
> regulator_list_voltage call sites would be any more efficient than
> handling this directly in regulator core.

If you feel like writing a helper function that would be fine but
list_voltage() can't be doing expensive talking to the hardware
operations - it needs to be something people can be comfortable calling
a lot.

--o0y1lerN6xYE2ROn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT8f0gAAoJELSic+t+oim9TV0QAILiMg/AzFiTY7eKoQIHgf61
2AF/Sp9jz8fzjRIv/QSYGyoai/XTI26ABkIhObN8s9gyY6hYzCC02f6+/y3LzzNf
H9eGFQfXYgPLszPWOrRFaDoMa/KGRxSdhsHP8xhiQu3vaAnhphzhvpqkDoa6fuyZ
YTDaIOIa9K2zvjWiRGq0cTh4/hTby8zy8uXdFFNKv37gAaHA0bM1DEVxjUT/+c2M
F4atmzZ9SKqR7vBIm6MGvNCSeGKkOZkufg8yHV9I6O3OFlvZfNXrdkrzsAqf0yAi
Pp6VsQdVJ6K+vTP1V1zynF8pwZaY4j1lzkkOXeFHEJU0OAlP+RtXJObY7taH4atm
1AxsxhLtUUmT02RxRLFjBbEHhUU0qtnY6tc55xo3K9OhTo924ISelfmJ225ByD+I
YUuNWEvXKx1KN1rxyeQWBBZjM4ben9l6SN6FtMhKWje1I8t+Ls0lgSMJ3dLFPSRJ
92VpVxU1R9IDw0Q8AM3yokAeyNyco6JYDOvqk5FdO+dG5UOZZL7slj0BB7ZlJxGZ
NIh0lPQzWJXtVsDALgVi6FacG62mbcbeUU433qvJ3EHASFiQKa1Kw5s2ruCZ1gLz
mDHkeiJmAaxtVOAhJZS+I0yKN5xzR6ZXLDCBA7xGKppgKg4wInP5mNHDBrq1ZgQa
+xEKmWFWwQgJKPDYsUk9
=LNH1
-----END PGP SIGNATURE-----

--o0y1lerN6xYE2ROn--
