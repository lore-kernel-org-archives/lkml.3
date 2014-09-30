Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751219AbaI3XkQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 19:40:16 -0400
Received: from ozlabs.org ([103.22.144.67]:54747 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750760AbaI3XkO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 19:40:14 -0400
Date: Wed, 1 Oct 2014 09:40:01 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Russell King <linux@arm.linux.org.uk>,
        Wim Van Sebroeck <wim@iguana.be>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        linux-watchdog@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-pm@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        Will Deacon <will.deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        Heiko Stuebner <heiko@sntech.de>,
        Jonas Jensen <jonas.jensen@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Tomasz Figa <t.figa@samsung.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Sebastian Reichel <sre@kernel.org>,
        Mike Turquette <mturquette@linaro.org>
Subject: Re: [PATCH v7 00/11] kernel: Add support for restart handler call
 chain
Message-ID: <20141001094001.2b85f54c@canb.auug.org.au>
In-Reply-To: <20140930223000.GA20946@roeck-us.net>
References: <1408495538-27480-1-git-send-email-linux@roeck-us.net>
	<20140930142002.e09ef32392a2b5a7c81e5e57@linux-foundation.org>
	<20140930223000.GA20946@roeck-us.net>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/Gy42xwtiNT+p6PE05f0+fRy"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/Gy42xwtiNT+p6PE05f0+fRy
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Guenter,

On Tue, 30 Sep 2014 15:30:00 -0700 Guenter Roeck <linux@roeck-us.net> wrote:
>
> On Tue, Sep 30, 2014 at 02:20:02PM -0700, Andrew Morton wrote:
> > On Tue, 19 Aug 2014 17:45:27 -0700 Guenter Roeck <linux@roeck-us.net> w=
rote:
> >=20
> > > Introduce a system restart handler call chain to solve the described =
problems.
> >=20
> > So someone has merged eight of these patches into linux-next but these
> > three:
> >=20
> > watchdog-s3c2410-add-restart-handler.patch
> > clk-samsung-register-restart-handlers-for-s3c2412-and-s3c2443.patch
> > clk-rockchip-add-restart-handler.patch
> >=20
> > were omitted.  What's up?
>=20
> Most likely PBKC on my side; Looks like I forgot to add those when I crea=
ted
> the immutable branch for others to merge. Sorry for that :-(.
>=20
> Having said that, I somehow thought that the clock patches would go in th=
rough
> the clock tree. Heiko, did I get that wrong ? Separately, I sent a pull r=
equest
> that includes the watchdog patch to Wim.

So far, that immutable branch has been merged into the battery tree
(and thus into linux-next) by Sebastian in order to add (I assume):

18a702e0de98 power: reset: use restart_notifier mechanism for msm-poweroff
371bb20d6927 power: Add simple gpio-restart driver

on top of it.

So, I guess the watchdog and clk trees also need to merge that
immutable branch and then add their respective patches from the mmotm
series to their trees.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/Gy42xwtiNT+p6PE05f0+fRy
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUKz9aAAoJEMDTa8Ir7ZwVTDQQAI8iUdIp+v4VeTxn/6FbuhOZ
e1n1OJBjeRwYkHjg831LF14VnUhesMmVm5/NavwyjFIzlhnSN1wSfkdZpfQ4j4G+
K0aYCUBo5OQ6A4umtuH249dw6kHbTyxf0p3hxaHyebma+WCwsJK3RHQXzSYqwP+D
57LpKTIWd5psPNWvNwYO4zL51VfpjakC+NeO/jAVB/XvSTOvCFk/Ds296QKsHPyJ
NkZzozaEUDXbglfHk7FvtJYQmJfW3aim0j2B/bYs5Syx6Pt0OqkaESRW6jNJ+dzl
l/InzIT5tQAS26JiZvyOP2U3BbTFP98qjlpGG9VHYh+fWcO4oYVMU0otZV8QFnA4
mjnxsxTnpY1e0EXddyIM2ofyNG3sgkUGlcUL0oHwUYjOkvqaH2jplPm7ZFTkuRKM
AQWwMAtHi6mdUFmVhaTOj5abwoedeWSjXnKWXLMhBhSBn/sL3CKqxNI8Na930Nk5
rxDEn71ifyNOp++gxNt/kP0bjGh17mvtbvsX7vejd5u1QAseUpVVwhzdcDtbNe3q
WfCfrP+Skbvuymeky62Q/95JWrp4URYunqbcx2w/K3MBvtoesaHWrSNgdEeNmKQZ
kzLe0MrFz1FNHe0rk1x1OIcl9zhdOGafax5Nft2lZY/rxRdbBcUUCECHHBtzA41x
BhiA2DCmhTYk9na6KlaB
=4F6P
-----END PGP SIGNATURE-----

--Sig_/Gy42xwtiNT+p6PE05f0+fRy--
