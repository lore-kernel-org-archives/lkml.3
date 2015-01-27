Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757373AbbA0BOe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 20:14:34 -0500
Received: from cantor2.suse.de ([195.135.220.15]:37383 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754575AbbA0BOb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 20:14:31 -0500
Message-ID: <54C6E672.4030602@suse.de>
Date: Tue, 27 Jan 2015 02:14:26 +0100
From: =?UTF-8?B?QW5kcmVhcyBGw6RyYmVy?= <afaerber@suse.de>
Organization: SUSE LINUX Products GmbH
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: =?UTF-8?B?U8O2cmVuIEJyaW5rbWFubg==?= <soren.brinkmann@xilinx.com>
CC: monstr@monstr.eu, Michal Simek <michal.simek@xilinx.com>,
        devicetree@vger.kernel.org,
        Peter Crosthwaite <peter.crosthwaite@xilinx.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Ola Jeppson <ola@adapteva.com>,
        linux-gpio@vger.kernel.org, linux-usb@vger.kernel.org,
        Felipe Balbi <balbi@ti.com>
Subject: Re: [PATCH v3] ARM: zynq: DT: Add USB to device tree
References: <1417536431-27759-1-git-send-email-soren.brinkmann@xilinx.com> <d78fedd84f354d80985187f851cb3cd1@BN1AFFO11FD055.protection.gbl> <54C5F89A.3090901@suse.de> <54C5F965.90100@monstr.eu> <54C5FBC3.7030903@suse.de> <54C60A56.7010403@suse.de> <c65880cef67945ebaf61306febc1349b@BN1BFFO11FD010.protection.gbl> <54C6698F.5020301@suse.de> <8f367d9b85924f8e9cc9cb6fdff9a054@BN1BFFO11FD040.protection.gbl> <bb50396a16ab4042bdb554f72bde0bf7@BL2FFO11FD023.protection.gbl>
In-Reply-To: <bb50396a16ab4042bdb554f72bde0bf7@BL2FFO11FD023.protection.gbl>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="0vbSgPsroBhq357Q9j59S8G7CXH4BCoQM"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--0vbSgPsroBhq357Q9j59S8G7CXH4BCoQM
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

+ linux-gpio, linux-usb, Felipe Balbi

Am 26.01.2015 um 19:44 schrieb S=C3=B6ren Brinkmann:
> On Mon, 2015-01-26 at 08:23AM -0800, S=C3=B6ren Brinkmann wrote:
>> On Mon, 2015-01-26 at 05:21PM +0100, Andreas F=C3=A4rber wrote:
>>> Am 26.01.2015 um 16:50 schrieb S=C3=B6ren Brinkmann:
>>>> On Mon, 2015-01-26 at 10:35AM +0100, Andreas F=C3=A4rber wrote:
>>>>> Am 26.01.2015 um 09:33 schrieb Andreas F=C3=A4rber:
>>>>>> Am 26.01.2015 um 09:23 schrieb Michal Simek:
>>>>>>> On 01/26/2015 09:19 AM, Andreas F=C3=A4rber wrote:
>>>>>>>> And if I apply it to my -next based tree, adding corresponding n=
odes to
>>>>>>>> zynq-parallella.dts, I get repeatedly:
>>>>>>>>
>>>>>>>> [  +0,012242] ci_hdrc ci_hdrc.0: no of_node; not parsing pinctrl=
 DT
>>>>>>>> [  +0,000157] ci_hdrc ci_hdrc.0: ChipIdea HDRC found, lpm: 0; ca=
p:
>>>>>>>> f090e100 op: f090e140
>>>>>>>> [  +0,000081] platform ci_hdrc.0: Driver ci_hdrc requests probe =
deferral
>>>>>>>> [  +0,005360] ci_hdrc ci_hdrc.1: no of_node; not parsing pinctrl=
 DT
>>>>>>>> [  +0,000120] ci_hdrc ci_hdrc.1: ChipIdea HDRC found, lpm: 0; ca=
p:
>>>>>>>> f0910100 op: f0910140
>>>>>>>> [  +0,001810] platform ci_hdrc.1: Driver ci_hdrc requests probe =
deferral
>>>>>>>>
>>>>>>>> Am I missing any other patches or config options?
[...]
>>>>>>> Why is it deferred? Is it because of pinmuxing stuff?
>>>>>>
>>>>>> No, happened without as well.
>>>>>>
>>>>>> Looking at a different place in dmesg, I spot this:
>>>>>>
>>>>>> [  +0,003988] usb_phy_generic phy0: GPIO lookup for consumer reset=
-gpios
>>>>>> [  +0,000012] usb_phy_generic phy0: using device tree for GPIO loo=
kup
>>>>>> [  +0,000015] of_get_named_gpiod_flags: can't parse 'reset-gpios-g=
pios'
>>>>>> property
>>>>>>  of node '/phy0[0]'
>>>>>> [  +0,000013] of_get_named_gpiod_flags: can't parse 'reset-gpios-g=
pio'
>>>>>> property
>>>>>> of node '/phy0[0]'
>>>>>> [  +0,000010] usb_phy_generic phy0: using lookup tables for GPIO l=
ookup
>>>>>> [  +0,000153] usb_phy_generic phy0: lookup for GPIO reset-gpios fa=
iled
>>>>>> [  +0,000012] usb_phy_generic phy0: Error requesting RESET GPIO
>>>>>> [  +0,004360] usb_phy_generic: probe of phy0 failed with error -2
>>>>>> [  +0,004991] usb_phy_generic phy1: GPIO lookup for consumer reset=
-gpios
>>>>>> [  +0,000012] usb_phy_generic phy1: using device tree for GPIO loo=
kup
>>>>>> [  +0,000013] of_get_named_gpiod_flags: can't parse 'reset-gpios-g=
pios'
>>>>>> property
>>>>>>  of node '/phy1[0]'
>>>>>> [  +0,000013] of_get_named_gpiod_flags: can't parse 'reset-gpios-g=
pio'
>>>>>> property of node '/phy1[0]'
>>>>>> [  +0,000010] usb_phy_generic phy1: using lookup tables for GPIO l=
ookup
>>>>>> [  +0,000012] usb_phy_generic phy1: lookup for GPIO reset-gpios fa=
iled
>>>>>> [  +0,000011] usb_phy_generic phy1: Error requesting RESET GPIO
>>>>>> [  +0,004337] usb_phy_generic: probe of phy1 failed with error -2
>>>>>>
>>>>>> So, I guess the chipidea driver is deferring because the phys want=
 a
>>>>>> property that neither me nor you are specifying? [...]
[...]
>>>>> In my manuals and notes I can't find any GPIO being used as reset f=
or
>>>>> the USB PHYs. Any thoughts appreciated.
>>>>
>>>> Such a connection is optional. The platform might rely on its reset
>>>> circuit, though it might not work for warm reboots.
>>>> I haven't looked at parallela docs, but if there is a schematic
>>>> available, that should tell you if/what is connected to the PHY rese=
t
>>>> pin.
>>>
>>> I do have the schematic, and the way I read it, only the on-board res=
et
>>> button resets the PHYs.
>>>
>>> Yet it looks as if usb-nop-xceiv insists on a reset-gpios above, no?
>>> Does it work on your boards with linux-next?
>>
>> I haven't re-tested it since I submitted the patches, but at that time=

>> it worked. But I also didn't test USB with the pinctrl patches togethe=
r.
>> I'll do some testing later today.
>=20
> So, just did a test. I took all the pinctrl stuff and this patch and ra=
n
> it on a zc702. I plugged in a thumb drive and that worked just fine. So=
,
> basically this patch could go in, despite missing pinctrl properties.

For my board I needed the following workaround:

diff --git a/drivers/usb/phy/phy-generic.c b/drivers/usb/phy/phy-generic.=
c
index dd05254241fb..96c7c36e22a6 100644
--- a/drivers/usb/phy/phy-generic.c
+++ b/drivers/usb/phy/phy-generic.c
@@ -218,13 +218,13 @@ int usb_phy_gen_create_phy(struct device *dev,
struct usb_phy_generic *nop,
                        clk_rate =3D 0;

                needs_vcc =3D of_property_read_bool(node, "vcc-supply");
-               nop->gpiod_reset =3D devm_gpiod_get(dev, "reset-gpios");
+               /*nop->gpiod_reset =3D devm_gpiod_get(dev, "reset-gpios")=
;
                err =3D PTR_ERR(nop->gpiod_reset);
                if (!err) {
                        nop->gpiod_vbus =3D devm_gpiod_get(dev,

"vbus-detect-gpio");
                        err =3D PTR_ERR(nop->gpiod_vbus);
-               }
+               }*/
        } else if (pdata) {
                type =3D pdata->type;
                clk_rate =3D pdata->clk_rate;

[  +0,004738] usb_phy_generic phy0: Looking up vcc-supply from device tre=
e
[  +0,000018] usb_phy_generic phy0: Looking up vcc-supply property in
node /phy0 failed
[  +0,000011] phy0 supply vcc not found, using dummy regulator
[  +0,004844] usb_phy_generic phy1: Looking up vcc-supply from device tre=
e
[  +0,000017] usb_phy_generic phy1: Looking up vcc-supply property in
node /phy1 failed
[  +0,000008] phy1 supply vcc not found, using dummy regulator

Basically, usb-nop-xceiv fails to probe when reset-gpios property is
absent (and probably also when vbus-detect-gpio property is absent).
So I don't understand why it would work for your boards without such
properties on today's linux-next... sounds like you tested a different tr=
ee?

Take a look at __gpiod_get_index() called from devm_gpiod_get():
http://lxr.free-electrons.com/source/drivers/gpio/gpiolib.c#L1648

!desc || desc =3D=3D ERR_PTR(-ENOENT) results in the above "using lookup
tables for GPIO lookup", then IS_ERR(desc) in "lookup for GPIO %s failed"=
=2E

My interpretation is that this gpiolib code is probably okay but that
the generic usb phy code fails to check for specific error codes such as
absent property (as opposed to deferred resolution of a phandle, where
we do want to return -EDEFER early).

My work tree: https://github.com/afaerber/linux/commits/parallella-next

Regards,
Andreas

--=20
SUSE Linux GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg, Germany
GF: Felix Imend=C3=B6rffer, Jane Smithard, Jennifer Guild, Dilip Upmanyu,=

Graham Norton; HRB 21284 (AG N=C3=BCrnberg)


--0vbSgPsroBhq357Q9j59S8G7CXH4BCoQM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUxuZyAAoJEPou0S0+fgE/sGcQALdILVg+2ZHJMVfd2Du011p6
YNU6KDnysA197a+mwOh9cYnVpFxtMH7KhabS/j8OkgIKMmrBcz3XyBEG5MIcqztf
KGxbZ5zNiUWuafPPDm6kuiIIhaNBNmDSbMBSJvmJtMUYALS0VX/79xQpjwhHw2wk
foyYkCCACjT94uaS6mbXEF38UvMJfdf4Mj85QhJjEZGDkHo/qq7Wbm1xFjnADO/m
0MAwz16SmG4utfdYeWhmUziXc2RY9yewqjJ/XbvbRn9SDp6UxmJv9NJPYJgw7VKb
UbX6+0wTeVY/PoHUhbIIyACSho7vwoiJn7vUV0xNxnc9d9W+vyd2RWdarTIoNO8o
9vf94s0xTVulNqGUoTVHF2r9HfBPZkujch1y063FV0Mi1C2NL2y3AG01DeNehT+6
sNXDa0nAeACDVCmNq5OX8QqO2Qom8+zlDE4a9U2WskHv062R4YrksasDKf4kS5t/
VGoSUNVZj4Iur2sR9FGotSRHCKyAFMI2DPSDzU8rOavgdn294t9+smLwoGvp1kQ4
sHMAAUUzQD3o4nsPtDkIpr1+Md6UUkzr+Llx+t7aPjZRijJgy0VtWYX/5vdkitBZ
1sha0f2Gd+cqkvO3X6eCpB/V/d0tvzLoZshtqhSmu9nJ/CfAMv6jTjOCqzjY7JkP
44p1TkDCOm2Dlax1cBC9
=3ev5
-----END PGP SIGNATURE-----

--0vbSgPsroBhq357Q9j59S8G7CXH4BCoQM--
