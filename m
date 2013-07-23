Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757382Ab3GWMnf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 08:43:35 -0400
Received: from smtp.witbe.net ([81.88.96.48]:60992 "EHLO smtp.witbe.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756432Ab3GWMnd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 08:43:33 -0400
X-Greylist: delayed 698 seconds by postgrey-1.27 at vger.kernel.org; Tue, 23 Jul 2013 08:43:32 EDT
Date: Tue, 23 Jul 2013 14:29:07 +0200
From: Paul Rolland (=?UTF-8?B?44Od44O844Or44O744Ot44Op44Oz?=) 
	<rol@witbe.net>
To: Richard Genoud <richard.genoud@gmail.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        Chaoming Li <chaoming_li@realsil.com.cn>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        rol@witbe.net
Subject: Re: rtl8192cu: slow path warning
Message-ID: <20130723142907.53103aab@tux.DEF.witbe.net>
In-Reply-To: <CACQ1gAh+WjQZHo+_afZpzcwt1=KPM8VMBOe=YCHN_LEZu+jPNQ@mail.gmail.com>
References: <20130611123814.GA9854@lnx-rg>
	<20130626142241.GA13107@lnx-rg>
	<51CB0E9C.50408@lwfinger.net>
	<CACQ1gAh+WjQZHo+_afZpzcwt1=KPM8VMBOe=YCHN_LEZu+jPNQ@mail.gmail.com>
Organization: Witbe.net
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.7; x86_64-unknown-linux-gnu)
X-Ncc-RegId: fr.witbe
X-Face: +^rP^g;Vjb!M*"%3$mF6xWU{DwwAx)W=b_<WXQMv}Rk8,fQ)?Wnk0NK/+m,;eWci?+;=I}d^:]I+)D+|r'vxjYjp.?o-8Va|&sD*-GVKn>}?Y)|*X<5cv@M`1P{\:)p9_:$=)(NY2`%AcypV*]z>YIyy5yY"9PUoV5@)*(W:S5e-48Ct7Wu6CkkO[=KB"ox,_2B/FwY&hr/E1H&<9IbOCx6NrBa"}FLA)UIvHg`9%NC\LfYB3ia]
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWsjH1VRjFydFciEg3a1tJxUEM6OCB1zdsDAAACcElEQVQ4jV2Tu3LcMAxFEY7SG/KQNYlY2685Zi1rmF5kQteBNcL/f0JAacfZDUscARePK9itY3Q4Qu5vplJKIFsrvI0t7Ii/8/nmQsERtgJpHAtiGW4ggylOAwhXTxPi0xfIcxDrZIc3qhMGD/kfKdwBExZrAf6l5PeC/Al7cAGfAGD+AgvL5yckcsxegVmG+QZRPgnYXnFUMAC8DLd6QZhAxj6dRo6vT/JNkmZQmPyDtoroMkD2VlaVgHsw2QrCAf1jPM+ou2Ju1j/G8+xINfZT+zGDPDjr7H/xnKewgi6SO4D7zloYoRDafSoogmirP0t9YIOJnN2ibDEKK6zDoSEjTIFXDcYYkwizoO/AjkATm3g+JVsSXPOCZIHwj7uBo2Bi97RMOoflJ4n3b3dvS2kVXDQupjvAk7zvaMEJlu0OJDFy4SsCusRbL95jRynY0LIA/rpyxCMkJ1ie+bWoEy+MG7pzDE3k8Z2C1a5eUdxmi0adGi2mdVjyUr2uvamrW9EeuLTCY84/AUjBj40LtqYbbM23vqolA2mpj5g03gparH45DqBgmsBK2hU0x662+QQLVYJLitxTnHB7yf0es4rraS/xqKW/hF1zPg9lOijpmtIBVrWKOQ6oTSkQjh3YtnarHQc0RrtS1XjtbQnScPrLeNKM6iS+6Qz6e9mVoPvaHHPU6eP5aKu1Ifd2QQvp6EA1bLaP3VREwewXY73xgLppBR2tg4LFg9lXzegHQlusWuxwogLCaswJ+qunQ2cyfuziX6B1p0E26nQazR3Qn2jQarRXVVZT9zP3uB5FV6pNjQG+u03ugbalEsEXqo7/AjAH60VpvOMvAAAAAElFTkSuQmCC
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Vmhjf/KX18mZcfFQH++q5Q+"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/Vmhjf/KX18mZcfFQH++q5Q+
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hello,

On Thu, 27 Jun 2013 09:33:20 +0200
Richard Genoud <richard.genoud@gmail.com> wrote:

> Yes, of course, you can add my
> Reported-by: Richard Genoud <richard.genoud@gmail.com>
>=20
> But the patch doesn't compile on my platform ( since I'm on ARM, I
> haven't got a PCI bus, so rtlwifi/pci.c is not compiled ) :
>=20
> ERROR: "rtl_lps_change_work_callback"
> [drivers/net/wireless/rtlwifi/rtlwifi.ko] undefined!

Is that the reason why this patch is not yet in 3.10.x or 3.11-rcY ?
I'm running a 3.10.1 with USB dongle including 8192CU, and I can see this
warning when the machine starts.
I've check 3.10.1, 3.10.2 and 3.11-rc3 source code, but this fix is not
there. Is there a different fix that went in in 3.10.2 or 3.11-rc?

Best,
Paul

--Sig_/Vmhjf/KX18mZcfFQH++q5Q+
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iEYEARECAAYFAlHudxMACgkQZP464AVDf+DQQwCggiZm/Z9jhld9l6twYkzKDgrf
P7IAn3BHVpFJNQoiGoK96Rvac8xZ9ezx
=45Kc
-----END PGP SIGNATURE-----

--Sig_/Vmhjf/KX18mZcfFQH++q5Q+--
