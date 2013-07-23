Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933377Ab3GWPvk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 11:51:40 -0400
Received: from smtp.witbe.net ([81.88.96.48]:44784 "EHLO smtp.witbe.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932138Ab3GWPvj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 11:51:39 -0400
Date: Tue, 23 Jul 2013 17:49:04 +0200
From: Paul Rolland (=?UTF-8?B?44Od44O844Or44O744Ot44Op44Oz?=) 
	<rol@witbe.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Richard Genoud <richard.genoud@gmail.com>,
        Chaoming Li <chaoming_li@realsil.com.cn>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        rol@witbe.net
Subject: Re: rtl8192cu: slow path warning
Message-ID: <20130723174904.00d6fab4@tux.DEF.witbe.net>
In-Reply-To: <51EE9BB6.8000501@lwfinger.net>
References: <20130611123814.GA9854@lnx-rg>
	<20130626142241.GA13107@lnx-rg>
	<51CB0E9C.50408@lwfinger.net>
	<CACQ1gAh+WjQZHo+_afZpzcwt1=KPM8VMBOe=YCHN_LEZu+jPNQ@mail.gmail.com>
	<20130723142907.53103aab@tux.DEF.witbe.net>
	<51EE9BB6.8000501@lwfinger.net>
Organization: Witbe.net
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.7; x86_64-unknown-linux-gnu)
X-Ncc-RegId: fr.witbe
X-Face: +^rP^g;Vjb!M*"%3$mF6xWU{DwwAx)W=b_<WXQMv}Rk8,fQ)?Wnk0NK/+m,;eWci?+;=I}d^:]I+)D+|r'vxjYjp.?o-8Va|&sD*-GVKn>}?Y)|*X<5cv@M`1P{\:)p9_:$=)(NY2`%AcypV*]z>YIyy5yY"9PUoV5@)*(W:S5e-48Ct7Wu6CkkO[=KB"ox,_2B/FwY&hr/E1H&<9IbOCx6NrBa"}FLA)UIvHg`9%NC\LfYB3ia]
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWsjH1VRjFydFciEg3a1tJxUEM6OCB1zdsDAAACcElEQVQ4jV2Tu3LcMAxFEY7SG/KQNYlY2685Zi1rmF5kQteBNcL/f0JAacfZDUscARePK9itY3Q4Qu5vplJKIFsrvI0t7Ii/8/nmQsERtgJpHAtiGW4ggylOAwhXTxPi0xfIcxDrZIc3qhMGD/kfKdwBExZrAf6l5PeC/Al7cAGfAGD+AgvL5yckcsxegVmG+QZRPgnYXnFUMAC8DLd6QZhAxj6dRo6vT/JNkmZQmPyDtoroMkD2VlaVgHsw2QrCAf1jPM+ou2Ju1j/G8+xINfZT+zGDPDjr7H/xnKewgi6SO4D7zloYoRDafSoogmirP0t9YIOJnN2ibDEKK6zDoSEjTIFXDcYYkwizoO/AjkATm3g+JVsSXPOCZIHwj7uBo2Bi97RMOoflJ4n3b3dvS2kVXDQupjvAk7zvaMEJlu0OJDFy4SsCusRbL95jRynY0LIA/rpyxCMkJ1ie+bWoEy+MG7pzDE3k8Z2C1a5eUdxmi0adGi2mdVjyUr2uvamrW9EeuLTCY84/AUjBj40LtqYbbM23vqolA2mpj5g03gparH45DqBgmsBK2hU0x662+QQLVYJLitxTnHB7yf0es4rraS/xqKW/hF1zPg9lOijpmtIBVrWKOQ6oTSkQjh3YtnarHQc0RrtS1XjtbQnScPrLeNKM6iS+6Qz6e9mVoPvaHHPU6eP5aKu1Ifd2QQvp6EA1bLaP3VREwewXY73xgLppBR2tg4LFg9lXzegHQlusWuxwogLCaswJ+qunQ2cyfuziX6B1p0E26nQazR3Qn2jQarRXVVZT9zP3uB5FV6pNjQG+u03ugbalEsEXqo7/AjAH60VpvOMvAAAAAElFTkSuQmCC
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/AagHTG=sZ422WoRYeybo2nQ"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/AagHTG=sZ422WoRYeybo2nQ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hello Larry,

On Tue, 23 Jul 2013 10:05:26 -0500
Larry Finger <Larry.Finger@lwfinger.net> wrote:

> The reason that patch is not in mainline is that it takes time. If you
> want to have it, you can get the official patch from=20
> http://marc.info/?l=3Dlinux-wireless&m=3D137242880222442&w=3D2, or you ne=
ed to=20
> implement kernels from the wireless-testing git tree, where it was added
> on June 28 as commit bcfb879. My original patch included the following
> note for John Linville:
>=20
> "Ideally, this patch should be pushed to the 3.10 stream; however, at
> this late time that is not possible. Please push it for 3.11 and the Cc
> to stable will get it into 3.10.X."
>=20
> As you see, it was marked with a Cc for Stable, and it will be propagated
> to 3.10 when it gets incorporated by Linus. I think I have done all that
> I can do for now.
>=20
> If you want to lobby Linus to get stuff accepted faster, that is your=20
> prerogative; however, I could not recommend that action, and I certainly
> will never do anything like that.

Neither will I... I was just wondering and asking, nothing else, as I'm
also facing this warning.=20

I'm glad to see the link you sent is presenting a patch that is the same as
the one I prepared. I'm going to use that while waiting for the patch to
hit mainline !

Thanks for replying,=20
Best,
Paul


--Sig_/AagHTG=sZ422WoRYeybo2nQ
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iEUEARECAAYFAlHupfEACgkQZP464AVDf+CdpACWIJ2aZ7LfcAW9oFqtoH9Tv3y0
GACgmrpBsLaQR+9fyV+gnu6ujzjtHDY=
=4B0j
-----END PGP SIGNATURE-----

--Sig_/AagHTG=sZ422WoRYeybo2nQ--
