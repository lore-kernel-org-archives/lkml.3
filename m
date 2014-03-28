Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751579AbaC1WqK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 18:46:10 -0400
Received: from sauhun.de ([89.238.76.85]:33427 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751068AbaC1WqI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 18:46:08 -0400
Date: Fri, 28 Mar 2014 23:46:02 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Bjorn Andersson <bjorn.andersson@sonymobile.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Grant Likely <grant.likely@linaro.org>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Andy Gross <agross@codeaurora.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>
Subject: Re: [PATCH v5 2/2] i2c: New bus driver for the Qualcomm QUP I2C
 controller
Message-ID: <20140328224602.GB29200@katana>
References: <1394762863-12154-1-git-send-email-bjorn.andersson@sonymobile.com>
 <1394762863-12154-3-git-send-email-bjorn.andersson@sonymobile.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Bn2rw/3z4jIqBvZU"
Content-Disposition: inline
In-Reply-To: <1394762863-12154-3-git-send-email-bjorn.andersson@sonymobile.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Bn2rw/3z4jIqBvZU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 13, 2014 at 07:07:43PM -0700, Bjorn Andersson wrote:
> This bus driver supports the QUP i2c hardware controller in the Qualcomm =
SOCs.
> The Qualcomm Universal Peripheral Engine (QUP) is a general purpose data =
path
> engine with input/output FIFOs and an embedded i2c mini-core. The driver
> supports FIFO mode (for low bandwidth applications) and block mode (inter=
rupt
> generated for each block-size data transfer).
>=20
> Cc: Andy Gross <agross@codeaurora.org>
> Cc: Stephen Boyd <sboyd@codeaurora.org>
> Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
> Signed-off-by: Bjorn Andersson <bjorn.andersson@sonymobile.com>

spatch told me...

drivers/i2c/busses/i2c-qup.c:481:7-26: pm_runtime_get_sync returns < 0 as e=
rror. Unecessary IS_ERR_VALUE at line 482

Fixed that and Applied to for-next, thanks!


--Bn2rw/3z4jIqBvZU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJTNfupAAoJEBQN5MwUoCm2vgAP/0sy+c7P05c47UXrpegR3r65
tt29KhDKh6iKzCEUVmmL1MnhY6R59LI2StK9rCusD2reXL9RdMMoA0koFLmBLIe3
uCKMS1tofy3KTLsDmEuik6eEwRgeMmZLkGt7EHrbWtJhrfQD7GNyP3Ptg5BUNKFZ
41cn4GhR9eF0yqQTKIM/ILffoCTyG4BNP4ZRzbV35UxUzjjjdVYGHnvFg9GMDoHV
3sxyc1l3O4Qz6B0io73fpbO7U74lD7FiTM9xg90qnJ/O9jFR2bI1uUxAoI9sU76v
XGsvOzs/Jsk0EcRgwo6ur/GI8xeekL3Tns4khObtKclE9hW9S5bxbfdPZ/i27wA6
O25FyORBTuwYPfuKP4O3bsrMgAdmGoXwcwSpEFyH2EWpN2iQ/1uY7jFof2+ODtX1
3+kWOcyPtIF8k6thVE3GZ1Be/2k7nifEWhMLQ3XAVqneaFT5u1MSF1IA1X0Eh757
tis+cdStqfG5JOWa/z2LrXc543MbZJP87MtXd+bWFoRkKCNu8SofPFpc6uq1t7gV
Dr8B8YwX1RDNkQ7VjF2GpQoVKICEbYCZuPhc1A5/Yjz7MqDuRQqHS/RKSR3OKxHV
+24HafNlhl43hC8i7/t0Pl/NBOTHXjZSqnd4eE/EYGtYxYr8YTeNljlEhhpjp6J6
rq+1N/B5P+0oyoo+035O
=nxQl
-----END PGP SIGNATURE-----

--Bn2rw/3z4jIqBvZU--
