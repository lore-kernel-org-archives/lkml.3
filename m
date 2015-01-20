Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754226AbbATQdj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 11:33:39 -0500
Received: from mail.kernel.org ([198.145.29.136]:36917 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753458AbbATQdh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 11:33:37 -0500
Date: Tue, 20 Jan 2015 17:33:26 +0100
From: Sebastian Reichel <sre@kernel.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        devicetree@vger.kernel.org, linux-api@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: Re: [PATCH v5 0/5] power: Add max77693 charger driver
Message-ID: <20150120163326.GA18034@earth.universe>
References: <1421748056-25735-1-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="tKW2IUtsqtDRztdT"
Content-Disposition: inline
In-Reply-To: <1421748056-25735-1-git-send-email-k.kozlowski@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--tKW2IUtsqtDRztdT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

On Tue, Jan 20, 2015 at 11:00:51AM +0100, Krzysztof Kozlowski wrote:
> You already acked some earlier version of this patch. In that time
> there were more dependencies on MFD tree. Now the MFD patch (2/5)
> is acked by Lee Jones so could you pick up everything?

Thanks for the patchset, queued:

http://git.infradead.org/battery-2.6.git/commit/f8f847b51a0e1cb0c96e706d5da0ac507d96c605

-- Sebastian

--tKW2IUtsqtDRztdT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJUvoNTAAoJENju1/PIO/qawI4P/3v7IYV5EPZE5Uk1R+rj9Fzp
1eTPsuVRR7cfCFB72G5cbPkl33yLvgX7wxQvSWvI8zlsJ/K4QKWj49amskj3djni
cjFoi2QBLdD1q1NvA3THFEy73LozEywA79tTlVZPx1Wg7EzWX56+zrfAjXQZ45st
FHXXzGu4Aio0susB4h2uH9lTjh3dJ4kbwp9HqKT/lNzfLTipfexo1HqoxNYjsNbQ
8+wx+SHTo9aOhRkCtLpn8n++xjwKSGOsYLCbD91u2tlyR53dP5irzJI7PAFz2uyj
ZiV9x677Mbr1NBA5Tk7T63fUIl9hAtFvkAzTRzTF97c7ADGMZH7U60FtwJEy90gC
eM4tNzOh4oAVn9m14mtTcTv1/kEOwRvBSxSX5H7j6xr7SMi/V4/po1VX4rwlA3+q
1NLoi63kJIxKj3ykkdyoHr7e6tfGK9zPRjoKa4Z9NzPTB2yNt2rFRP55EGOPvKHP
dDtYF9kuUj0kFNrAqLELNclGhh9SqsbOurco+pulHQ3FOWJ+jL0rnrJZ3P2A/2FH
x7zUduh4NqXm0y7VBcMcpdR7fm+CDRZdcAYR4pVap4QxtiIrmXP3W17T1QVtAUid
QcNPaE8nz+ReBrPjreLepqiL8UvSNSceFCMfUsheABFIg8Y4eJ7PrmfGuyZbF0tp
fB0/WFOCR7lo9aZlTPYw
=hFF9
-----END PGP SIGNATURE-----

--tKW2IUtsqtDRztdT--
