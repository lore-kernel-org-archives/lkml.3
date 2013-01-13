Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755309Ab3AMX3z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2013 18:29:55 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36393 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754758Ab3AMX3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2013 18:29:54 -0500
Date: Mon, 14 Jan 2013 08:29:38 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "rob@landley.net" <rob@landley.net>, "lrg@ti.com" <lrg@ti.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/4] mfd/regulator: tps65090: add DT support and
 suspend/resume cleanups
Message-ID: <20130113232937.GQ5041@opensource.wolfsonmicro.com>
References: <1356686981-4152-1-git-send-email-ldewangan@nvidia.com>
 <50EC1046.3000701@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8HhMLSHvAouSipEr"
Content-Disposition: inline
In-Reply-To: <50EC1046.3000701@nvidia.com>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--8HhMLSHvAouSipEr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 08, 2013 at 05:55:42PM +0530, Laxman Dewangan wrote:

> I am not sure that the patches are created on correct sequence for
> adapting this in regulator subsystem and mfd subsystem.
> Can you please review whether the changes split is fine or not?
> Idea was to make independent patch for mfd and regulator so that
> they can apply independently.

The addition of pdata to the header means that they can't be applied
independantly but that's not the end of the world.

--8HhMLSHvAouSipEr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQ80NHAAoJELSic+t+oim9DQQP/3BZX1kTC5bm9upkt+JSD0Er
UDq9cSrc4Uu6z/MaY7qNiPLCfnnNk/hiyuAvxrpHq9FC6lWqeIpvns5TJKzHHkLt
0y82TdAguHVvVn6+3xiogbN96ouIfFVEC+/Y07lZnxeQSS9NVOkeF+R1Qkz9KEUJ
/gTdpttm4PCUb2Ch8zj93zHVaG9nktmK81MPi+zl6jFmJyiKEWBtGO/vKCNKqMPJ
d3LR5WoH3yRwtqglBafRRYLUzeVarfCUmjB6NT16EXU3SIUzYX8XQDh71BQM8A8K
LxiehxEZyVGao5popuxiAXbSDy6gsvslOZ84tvzr93crz0sWWYULPvi5y7CtvLTI
/NJsQRH6TKKJxPq7TMfgz/y7MUJ4gBOFyBj4mVEcnAn5xkCGJoMJtrFNC/WlJOmk
mulPJ3EMJMJ9q3+360ZI7vqT3gXKypxlCXl2yHKq2L95EUE8fLIhnccxz39/dB56
r21En4THZ0GuXCYmH75AWPg/lm3mXCp7C0lAz1d+wA6M6JRgIXecfvBXhuMMSuOD
jUoPbNYE52fXFcUeBJ0rMUlh7WZWN3/bi67juuGWO1wySrjKKBQUhZqUUS0kjgkI
aywMq1IC0R8VHe0mx0r9wArqmNbnR6T8BZ2Df7nPQIRWWcmpSrmOCQOnxiGgloR6
OKmfmWhLGEFi7Csta4og
=KBIN
-----END PGP SIGNATURE-----

--8HhMLSHvAouSipEr--
