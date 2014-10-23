Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755254AbaJWLju (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 07:39:50 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:46869 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754377AbaJWLjs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 07:39:48 -0400
Message-ID: <5448E8CE.7040405@ti.com>
Date: Thu, 23 Oct 2014 14:38:54 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Daniel Vetter <daniel@ffwll.ch>
CC: Jani Nikula <jani.nikula@intel.com>, <linux-kernel@vger.kernel.org>,
        <dri-devel@lists.freedesktop.org>, <linuxppc-dev@lists.ozlabs.org>,
        <platform-driver-x86@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <linux-fbdev@vger.kernel.org>, Jingoo Han <jg1.han@samsung.com>,
        Daniel Drake <dsd@laptop.org>, Jens Frederich <jfrederich@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jon Nettleton <jon.nettleton@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Darren Hart <dvhart@infradead.org>,
        Daniel Vetter <daniel.vetter@intel.com>, Bryan Wu <cooloney@gmail.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH] drivers: depend on instead of select BACKLIGHT_CLASS_DEVICE
 and ACPI_VIDEO
References: <1413580403-16225-1-git-send-email-jani.nikula@intel.com> <54476492.6090105@ti.com> <20141023081034.GA26941@phenom.ffwll.local>
In-Reply-To: <20141023081034.GA26941@phenom.ffwll.local>
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="Nn26dT9qtJTf6VjBixu4iLbwGnd55SpBm"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Nn26dT9qtJTf6VjBixu4iLbwGnd55SpBm
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 23/10/14 11:10, Daniel Vetter wrote:

> If we want to make BACKLIGHT_CLASS_DEVICE into a library thing then I
> guess we could do that, but we must then also drag it out of all the ot=
her
> meta options to make sure it's always available. No need I think to dit=
ch

BACKLIGHT_CLASS_DEVICE only depends on HAS_IOMEM and
BACKLIGHT_LCD_SUPPORT so there are no other meta options to avoid.
HAS_IOMEM comes from drivers/video/Kconfig's "Graphics support", and I
guess we can ignore it.

> the entire BACKLIGHT_LCD_SUPPORT meta option. And then everyone could
> select it.

I don't quite understand what purpose does BACKLIGHT_LCD_SUPPORT serve.
It doesn't enable any code, it just opens up new Kconfig options. Why
can't the Kconfig options be always available? It's just another option
to 'select', without any reason I can see.

 Tomi



--Nn26dT9qtJTf6VjBixu4iLbwGnd55SpBm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUSOjOAAoJEPo9qoy8lh71ZtAP/R0WADvDaKCQZijK3sTtHI9a
Ic7QSu772o5C2vybbt3iKEM7NA4mugQJJnvnN/SOyLpKmA8T0RWAJyhV9QYpp/UC
a3/ULiGv7AB/I5V+GJUrsUevFTCdConhYDlXN4K2Q9r7aOYv41xiQkLfxb9LEy5t
4NcrIDU+ycG/aqlXGbroVz3DV9PMVhbiRjFgxR92VCReXeoJ/zh6P2oIOAEWtdL5
D2CK82WYO6EqVF1/RAeUA1k1XRHYFe3ogSxIZ+n04EMUZQ6ZFFx6FaBX5sgjUIp+
CDxkcbRLjNx4Bgj4Pe6Qo3VdtOcubkXh8mkWqbiYr7cQ+o6ZhQfxmTili+wBQGPG
84ylu0Kgvp5YG+1bAa5wew+mtf+szTucLar5a6dI2MMnB8yZkDO/Ku8y8Aj/cdmw
/AZWRtvrvhJyzjbx5JSnoHEeUFZNYDS6h8Uxf7q/nBjDrvwXQ67Ldh3zCc3jYPnL
8GQ/RC+e4ypxdxPf2FQmIpNqY4SHosoXxZ7zAPqqq5qUjP2Hry47a0etXrKp9bqa
86Hrwj75xLCkLTd/btf573nx23Vh0b4+n5p5ZwLh1QfjtETtbVApJR/FgVkJQEU7
d+3R63LoNDO0AO69WOJfyM7o2gIkr77faoh2dAoahMbZwwjG1r7UGmSxHxKMIrpW
/DxSFIsy4aulA+U8ekEg
=TpMx
-----END PGP SIGNATURE-----

--Nn26dT9qtJTf6VjBixu4iLbwGnd55SpBm--
