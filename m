Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757562Ab3GWO3b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 10:29:31 -0400
Received: from smtp.witbe.net ([81.88.96.48]:57281 "EHLO smtp.witbe.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757277Ab3GWO3a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 10:29:30 -0400
Date: Tue, 23 Jul 2013 16:26:59 +0200
From: Paul Rolland (=?UTF-8?B?44Od44O844Or44O744Ot44Op44Oz?=) 
	<rol@witbe.net>
To: Richard Genoud <richard.genoud@gmail.com>
Cc: Paul Rolland (=?UTF-8?B?44Od44O844Or44O744Ot44Op44Oz?=) 
	<rol@witbe.net>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Chaoming Li <chaoming_li@realsil.com.cn>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: rtl8192cu: slow path warning
Message-ID: <20130723162659.5aa59750@tux.DEF.witbe.net>
In-Reply-To: <20130723142907.53103aab@tux.DEF.witbe.net>
References: <20130611123814.GA9854@lnx-rg>
	<20130626142241.GA13107@lnx-rg>
	<51CB0E9C.50408@lwfinger.net>
	<CACQ1gAh+WjQZHo+_afZpzcwt1=KPM8VMBOe=YCHN_LEZu+jPNQ@mail.gmail.com>
	<20130723142907.53103aab@tux.DEF.witbe.net>
Organization: Witbe.net
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.7; x86_64-unknown-linux-gnu)
X-Ncc-RegId: fr.witbe
X-Face: +^rP^g;Vjb!M*"%3$mF6xWU{DwwAx)W=b_<WXQMv}Rk8,fQ)?Wnk0NK/+m,;eWci?+;=I}d^:]I+)D+|r'vxjYjp.?o-8Va|&sD*-GVKn>}?Y)|*X<5cv@M`1P{\:)p9_:$=)(NY2`%AcypV*]z>YIyy5yY"9PUoV5@)*(W:S5e-48Ct7Wu6CkkO[=KB"ox,_2B/FwY&hr/E1H&<9IbOCx6NrBa"}FLA)UIvHg`9%NC\LfYB3ia]
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWsjH1VRjFydFciEg3a1tJxUEM6OCB1zdsDAAACcElEQVQ4jV2Tu3LcMAxFEY7SG/KQNYlY2685Zi1rmF5kQteBNcL/f0JAacfZDUscARePK9itY3Q4Qu5vplJKIFsrvI0t7Ii/8/nmQsERtgJpHAtiGW4ggylOAwhXTxPi0xfIcxDrZIc3qhMGD/kfKdwBExZrAf6l5PeC/Al7cAGfAGD+AgvL5yckcsxegVmG+QZRPgnYXnFUMAC8DLd6QZhAxj6dRo6vT/JNkmZQmPyDtoroMkD2VlaVgHsw2QrCAf1jPM+ou2Ju1j/G8+xINfZT+zGDPDjr7H/xnKewgi6SO4D7zloYoRDafSoogmirP0t9YIOJnN2ibDEKK6zDoSEjTIFXDcYYkwizoO/AjkATm3g+JVsSXPOCZIHwj7uBo2Bi97RMOoflJ4n3b3dvS2kVXDQupjvAk7zvaMEJlu0OJDFy4SsCusRbL95jRynY0LIA/rpyxCMkJ1ie+bWoEy+MG7pzDE3k8Z2C1a5eUdxmi0adGi2mdVjyUr2uvamrW9EeuLTCY84/AUjBj40LtqYbbM23vqolA2mpj5g03gparH45DqBgmsBK2hU0x662+QQLVYJLitxTnHB7yf0es4rraS/xqKW/hF1zPg9lOijpmtIBVrWKOQ6oTSkQjh3YtnarHQc0RrtS1XjtbQnScPrLeNKM6iS+6Qz6e9mVoPvaHHPU6eP5aKu1Ifd2QQvp6EA1bLaP3VREwewXY73xgLppBR2tg4LFg9lXzegHQlusWuxwogLCaswJ+qunQ2cyfuziX6B1p0E26nQazR3Qn2jQarRXVVZT9zP3uB5FV6pNjQG+u03ugbalEsEXqo7/AjAH60VpvOMvAAAAAElFTkSuQmCC
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/tvIVCzGpFo4l4Cn9MjwOEtt"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/tvIVCzGpFo4l4Cn9MjwOEtt
Content-Type: multipart/mixed; boundary="MP_/SlzdQ9ty3NqMtinRSB=L53V"

--MP_/SlzdQ9ty3NqMtinRSB=L53V
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hello Richard,

If you still have the required HW and still would like a patch to remove
that warning on your machine, could you please try the attached one ?

I slightly reworked the original patch by moving the function
rtl_lps_change_work_callback from pci.c to ps.c.=20

I've successfully compiled that on my machine, but I have PCI set in
my .config, so I'd like your feedback.

Best,
Paul

On Tue, 23 Jul 2013 14:29:07 +0200
Paul Rolland (=E3=83=9D=E3=83=BC=E3=83=AB=E3=83=BB=E3=83=AD=E3=83=A9=E3=83=
=B3)  <rol@witbe.net> wrote:

> Hello,
>=20
> On Thu, 27 Jun 2013 09:33:20 +0200
> Richard Genoud <richard.genoud@gmail.com> wrote:
>=20
> > Yes, of course, you can add my
> > Reported-by: Richard Genoud <richard.genoud@gmail.com>
> >=20
> > But the patch doesn't compile on my platform ( since I'm on ARM, I
> > haven't got a PCI bus, so rtlwifi/pci.c is not compiled ) :
> >=20
> > ERROR: "rtl_lps_change_work_callback"
> > [drivers/net/wireless/rtlwifi/rtlwifi.ko] undefined!
>=20
> Is that the reason why this patch is not yet in 3.10.x or 3.11-rcY ?
> I'm running a 3.10.1 with USB dongle including 8192CU, and I can see this
> warning when the machine starts.
> I've check 3.10.1, 3.10.2 and 3.11-rc3 source code, but this fix is not
> there. Is there a different fix that went in in 3.10.2 or 3.11-rc?
>=20
> Best,
> Paul


--MP_/SlzdQ9ty3NqMtinRSB=L53V
Content-Type: application/octet-stream; name=patch
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename=patch

ZGlmZiAtdXByTiAtWCAvdXNyL3NyYy9saW51eC0zLjEwLjIvRG9jdW1lbnRhdGlvbi9kb250ZGlm
ZiBydGx3aWZpLm9yaWcvcGNpLmMgcnRsd2lmaS9wY2kuYwotLS0gcnRsd2lmaS5vcmlnL3BjaS5j
CTIwMTMtMDctMjMgMTU6Mjk6NDcuMDAwMDAwMDAwICswMjAwCisrKyBydGx3aWZpL3BjaS5jCTIw
MTMtMDctMjMgMTU6MzA6NTkuMDAwMDAwMDAwICswMjAwCkBAIC0xMDA4LDE5ICsxMDA4LDYgQEAg
c3RhdGljIHZvaWQgX3J0bF9wY2lfcHJlcGFyZV9iY25fdGFza2xldAogCXJldHVybjsKIH0KIAot
c3RhdGljIHZvaWQgcnRsX2xwc19jaGFuZ2Vfd29ya19jYWxsYmFjayhzdHJ1Y3Qgd29ya19zdHJ1
Y3QgKndvcmspCi17Ci0Jc3RydWN0IHJ0bF93b3JrcyAqcnRsd29ya3MgPQotCSAgICBjb250YWlu
ZXJfb2Yod29yaywgc3RydWN0IHJ0bF93b3JrcywgbHBzX2NoYW5nZV93b3JrKTsKLQlzdHJ1Y3Qg
aWVlZTgwMjExX2h3ICpodyA9IHJ0bHdvcmtzLT5odzsKLQlzdHJ1Y3QgcnRsX3ByaXYgKnJ0bHBy
aXYgPSBydGxfcHJpdihodyk7Ci0KLQlpZiAocnRscHJpdi0+ZW50ZXJfcHMpCi0JCXJ0bF9scHNf
ZW50ZXIoaHcpOwotCWVsc2UKLQkJcnRsX2xwc19sZWF2ZShodyk7Ci19Ci0KIHN0YXRpYyB2b2lk
IF9ydGxfcGNpX2luaXRfdHJ4X3ZhcihzdHJ1Y3QgaWVlZTgwMjExX2h3ICpodykKIHsKIAlzdHJ1
Y3QgcnRsX3BjaSAqcnRscGNpID0gcnRsX3BjaWRldihydGxfcGNpcHJpdihodykpOwpkaWZmIC11
cHJOIC1YIC91c3Ivc3JjL2xpbnV4LTMuMTAuMi9Eb2N1bWVudGF0aW9uL2RvbnRkaWZmIHJ0bHdp
Zmkub3JpZy9wcy5jIHJ0bHdpZmkvcHMuYwotLS0gcnRsd2lmaS5vcmlnL3BzLmMJMjAxMy0wNy0y
MyAxNToyOTo0Ny4wMDAwMDAwMDAgKzAyMDAKKysrIHJ0bHdpZmkvcHMuYwkyMDEzLTA3LTIzIDE1
OjQ5OjUwLjAwMDAwMDAwMCArMDIwMApAQCAtOTIyLDMgKzkyMiwxNyBAQCB2b2lkIHJ0bF9wMnBf
aW5mbyhzdHJ1Y3QgaWVlZTgwMjExX2h3ICpoCiAJZWxzZQogCQlydGxfcDJwX25vYV9pZShodywg
ZGF0YSwgbGVuIC0gRkNTX0xFTik7CiB9CisKK3ZvaWQgcnRsX2xwc19jaGFuZ2Vfd29ya19jYWxs
YmFjayhzdHJ1Y3Qgd29ya19zdHJ1Y3QgKndvcmspCit7CisJc3RydWN0IHJ0bF93b3JrcyAqcnRs
d29ya3MgPQorCSAgICBjb250YWluZXJfb2Yod29yaywgc3RydWN0IHJ0bF93b3JrcywgbHBzX2No
YW5nZV93b3JrKTsKKwlzdHJ1Y3QgaWVlZTgwMjExX2h3ICpodyA9IHJ0bHdvcmtzLT5odzsKKwlz
dHJ1Y3QgcnRsX3ByaXYgKnJ0bHByaXYgPSBydGxfcHJpdihodyk7CisKKwlpZiAocnRscHJpdi0+
ZW50ZXJfcHMpCisJCXJ0bF9scHNfZW50ZXIoaHcpOworCWVsc2UKKwkJcnRsX2xwc19sZWF2ZSho
dyk7Cit9CisKZGlmZiAtdXByTiAtWCAvdXNyL3NyYy9saW51eC0zLjEwLjIvRG9jdW1lbnRhdGlv
bi9kb250ZGlmZiBydGx3aWZpLm9yaWcvcHMuaCBydGx3aWZpL3BzLmgKLS0tIHJ0bHdpZmkub3Jp
Zy9wcy5oCTIwMTMtMDctMjMgMTU6Mjk6NDcuMDAwMDAwMDAwICswMjAwCisrKyBydGx3aWZpL3Bz
LmgJMjAxMy0wNy0yMyAxNTozMjoxNS4wMDAwMDAwMDAgKzAyMDAKQEAgLTQ5LDUgKzQ5LDYgQEAg
dm9pZCBydGxfc3dscHNfcmZfYXdha2Uoc3RydWN0IGllZWU4MDIxMQogdm9pZCBydGxfc3dscHNf
cmZfc2xlZXAoc3RydWN0IGllZWU4MDIxMV9odyAqaHcpOwogdm9pZCBydGxfcDJwX3BzX2NtZChz
dHJ1Y3QgaWVlZTgwMjExX2h3ICpodywgdTggcDJwX3BzX3N0YXRlKTsKIHZvaWQgcnRsX3AycF9p
bmZvKHN0cnVjdCBpZWVlODAyMTFfaHcgKmh3LCB2b2lkICpkYXRhLCB1bnNpZ25lZCBpbnQgbGVu
KTsKK3ZvaWQgcnRsX2xwc19jaGFuZ2Vfd29ya19jYWxsYmFjayhzdHJ1Y3Qgd29ya19zdHJ1Y3Qg
KndvcmspOwogCiAjZW5kaWYKZGlmZiAtdXByTiAtWCAvdXNyL3NyYy9saW51eC0zLjEwLjIvRG9j
dW1lbnRhdGlvbi9kb250ZGlmZiBydGx3aWZpLm9yaWcvdXNiLmMgcnRsd2lmaS91c2IuYwotLS0g
cnRsd2lmaS5vcmlnL3VzYi5jCTIwMTMtMDctMjMgMTU6Mjk6NDcuMDAwMDAwMDAwICswMjAwCisr
KyBydGx3aWZpL3VzYi5jCTIwMTMtMDctMjMgMTU6MzI6NTEuMDAwMDAwMDAwICswMjAwCkBAIC0x
MDcwLDYgKzEwNzAsOCBAQCBpbnQgcnRsX3VzYl9wcm9iZShzdHJ1Y3QgdXNiX2ludGVyZmFjZSAq
CiAJc3Bpbl9sb2NrX2luaXQoJnJ0bHByaXYtPmxvY2tzLnVzYl9sb2NrKTsKIAlJTklUX1dPUkso
JnJ0bHByaXYtPndvcmtzLmZpbGxfaDJjX2NtZCwKIAkJICBydGxfZmlsbF9oMmNfY21kX3dvcmtf
Y2FsbGJhY2spOworCUlOSVRfV09SSygmcnRscHJpdi0+d29ya3MubHBzX2NoYW5nZV93b3JrLAor
CQkgIHJ0bF9scHNfY2hhbmdlX3dvcmtfY2FsbGJhY2spOwogCiAJcnRscHJpdi0+dXNiX2RhdGFf
aW5kZXggPSAwOwogCWluaXRfY29tcGxldGlvbigmcnRscHJpdi0+ZmlybXdhcmVfbG9hZGluZ19j
b21wbGV0ZSk7Cg==

--MP_/SlzdQ9ty3NqMtinRSB=L53V--

--Sig_/tvIVCzGpFo4l4Cn9MjwOEtt
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iEYEARECAAYFAlHukrMACgkQZP464AVDf+CRrwCguutdtr8wrEa5KdcdjJKpxhkk
EqIAn3q4Qn5Sxjj73brAk4uOCbaySCjm
=OnqA
-----END PGP SIGNATURE-----

--Sig_/tvIVCzGpFo4l4Cn9MjwOEtt--
