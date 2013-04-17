Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966505Ab3DQOKE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 10:10:04 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46251 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966321Ab3DQOKC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 10:10:02 -0400
Date: Wed, 17 Apr 2013 15:10:00 +0100
From: Mark Brown <broonie@kernel.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Bengt Jonsson <bengt.g.jonsson@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>,
        Yvan FILLION <yvan.fillion@stericsson.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] regulator: ab8500-ext: Don't update
 info->update_val if set_mode() fails
Message-ID: <20130417141000.GR13687@opensource.wolfsonmicro.com>
References: <1366126152.14735.2.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PY8tzLeNxmyMVNR3"
Content-Disposition: inline
In-Reply-To: <1366126152.14735.2.camel@phoenix>
X-Cookie: Be different: conform.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--PY8tzLeNxmyMVNR3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Apr 16, 2013 at 11:29:12PM +0800, Axel Lin wrote:
> This ensures info->update_val status is still correct if set_mode() call fails.
> Otherwise, get_mode() may return wrong status if a set_mode() call fails.

Applied both, thanks.

--PY8tzLeNxmyMVNR3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRbq0wAAoJELSic+t+oim9e6AP/1+9iZByhXgzp0FQI3cQSe+a
F2bk1FnwEQVYOG90yojMFWnlNxqI3QNqvTHE7Hdnek7tOo+qFPn3VCwbsxSEekhU
jeBtWVQY7Y0zGfu4lJfMBL5Mt0gYEoxVjEpXEr33L1gigkNCodXPuTqN9/lkyPN6
FCBfVHTfJX/qx+8y388MkmoKOeu8o50dN9Ok5fVHzl/OP6WOYjE725Y8OEKmesxF
NZoYg7o1CoBgV0GpScvJWK3wQnOggDChDm90UziSQcdQaADB7VhoKmVCG7cmPrmX
5rixWPY5PU+BrOy0y3q7unF1xyJKbn0sliRmttSRvAb6qfmFgbjFsbwhHm6aQ/DQ
wE9/Bru29srOSDjNCh2ThnQ//vhx1+Fq+/4QsV1R8NBjlovYi6Pxovr138AqBDIe
7cdFvbdKmqP2WiZXVDZe/uawHra36kZeOsPnKqOMA9vMuUiB3ZNp8X25EsEmUHBq
udr9aDfZIw7TElt4H/XBE3Ox5OcM37ePuK4XzgWfg5Sj7zFqEyQikgs6gcH5F5Sy
MxjyEwPMG7vcPV+KjeKaHa72TeD5ZckIX8eupAefqf/jmVbz6qPwqwC/QeLJRt8N
qHmVBgltnDQHcI5TWxggdagFwxijU8hKbkwlahHvFGLvO4hHnnyATbR4wM2Q2Vs/
KKu578Ujbsf2zxZ24+wo
=LV8j
-----END PGP SIGNATURE-----

--PY8tzLeNxmyMVNR3--
