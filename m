Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755914Ab3CEKAm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 05:00:42 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54350 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754561Ab3CEKAl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 05:00:41 -0500
Date: Tue, 5 Mar 2013 18:00:09 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@ingics.com>
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>,
        "Jett.Zhou" <jtzhou@marvell.com>, Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND 1/3] regulator: core: Add enable_is_inverted flag
 to indicate set enable_mask bits to disable
Message-ID: <20130305100003.GF9391@opensource.wolfsonmicro.com>
References: <1362464160.1111.1.camel@phoenix>
 <20130305070339.GE9391@opensource.wolfsonmicro.com>
 <CAFRkauDJbEZCn-qdnv_WzQSV=zDfR369YcDX19pbkAu2c4bxfQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7cm2iqirTL37Ot+N"
Content-Disposition: inline
In-Reply-To: <CAFRkauDJbEZCn-qdnv_WzQSV=zDfR369YcDX19pbkAu2c4bxfQ@mail.gmail.com>
X-Cookie: Beware of Bigfoot!
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7cm2iqirTL37Ot+N
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Mar 05, 2013 at 03:09:51PM +0800, Axel Lin wrote:

> I think it is because of commit 5838b032fd
> "regulator: core: update kernel documentation for regulator_desc".

> I found the patch (sent on https://lkml.org/lkml/2013/2/16/14 ) does not apply
> to today's linux-next tree. So I re-generate the patchs against linux-next.

> Should I resend the previous version of this patch?

No, that's fine - I've applied them now, thanks.

--7cm2iqirTL37Ot+N
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRNcF3AAoJELSic+t+oim9mwQQAJtSoYNEKf+icO0SOVr9co8y
/x0F+EUqnmC0dxc48nwBqrT5M+mw5UHIQD8EgOOF3FfajNim4+9X0cW1OslMymEx
XRyJ+ClFSA0ODw4kxdQ+/4p7pnq40SL07CAV/YV2DCy1wz59LyUOmFUOGSfA/Isc
FP9ka6ip0E5QDXy8b6ArWVuumpNHrPLhOiiWVo3NhX/gxBC59UIKO1ugMSHyjbjX
VggZssgzO499CO3VieXPiKe1KP2BFU4jsueSXattjnxF97EQRiSiZcOtxkEC2U4X
u8tnmzXqnjr1ED8AanetylEb1zKg4y5V0nMtS9Mt3uPSHty+1cUL98ptftKXnIxJ
of7ETClSWEh0qTgIvtnyY9zS2ZSrT0HWwOsi5vKpHFFUYuVYrryhZcJWx/+X2BGp
oQ6VtqrX0MeFUVAvPOv57Ngoe5chehayP53ygaC9RbI3GjaDy5CyBqOoDIcNcS0x
Wt3A99kENY6WPEo9muyt2Q18xadnvs8zw3C2DVCgGfs1mk7Skqqt24NcMIV2x/Fy
HGSThkF0ggM2ElNwK+lLgtMhTfZwu+Pbib+Lc9kHbwNkR1ol/KZZL9I6crVWF39/
W63eMnAOgxt1jXShnTTumylJ5rt1d2pWQ+xeQVkNrntoeFGzK4WQuwaUkqrHV23E
FaANCefXEL51hsBEYMwy
=xQvT
-----END PGP SIGNATURE-----

--7cm2iqirTL37Ot+N--
