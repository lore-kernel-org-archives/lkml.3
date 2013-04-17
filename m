Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966511Ab3DQOKX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 10:10:23 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46258 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966321Ab3DQOKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 10:10:19 -0400
Date: Wed, 17 Apr 2013 15:10:18 +0100
From: Mark Brown <broonie@kernel.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Bengt Jonsson <bengt.g.jonsson@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>,
        Yvan FILLION <yvan.fillion@stericsson.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] regulator: ab8500: Fix set voltage for AB8540_LDO_AUX3
Message-ID: <20130417141017.GS13687@opensource.wolfsonmicro.com>
References: <1366131020.7842.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3sseE1tnmEs+TkKq"
Content-Disposition: inline
In-Reply-To: <1366131020.7842.1.camel@phoenix>
X-Cookie: Be different: conform.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3sseE1tnmEs+TkKq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Apr 17, 2013 at 12:50:20AM +0800, Axel Lin wrote:
> When setting voltage for AB8540_LDO_AUX3, current code only updates one of
> info->voltage_reg and info->expand_register registers which is wrong.
> To ensure we set to correct voltage, it always needs to clear or set
> expand_register.voltage_mask bit of expand_register.

Applied, thanks.

--3sseE1tnmEs+TkKq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRbq1DAAoJELSic+t+oim9QSwP/AzBdHn+r1T0fxZK1+b8fuxr
9A7tYp3+xqbTXT7JNfd7DiaQo1LIjBcKrpPNL8aMfHOr0M4isqG1x/wY4Pp4F13B
RLW4f/idGw1qKDcK+7kytZ48LB+wseHaWEBjKgHUJyvIoIZSesE6ecqzgF8CHNnZ
GKiEU+dctxgK9hCNYMSQlg/MRW2vQvnReiTPNJGsr3bZPP9GmqWQ9VBgcWn8uroM
D9TzJn6/jSEaGY9JwLaUfk2G47vV2Mw/KSFCM4wQeXVJGCqoQTMZvGws9E15PML2
d0VffwkzdboiwV4KcaIV7aDZuxRZYqrQLYl7kxF5aVfLzX4+MWYIsEGOGGJATf7/
D1UnlgctEyssJZ1FRrSzI/+9b3YsYMGxVE8I/fy16IO2AyPSXbf5oPKKS4/vjGqS
3KheFnKWPWFTu87kP4wFfvE0wh5++LAK4Hqm1j2Mpia2f3fGqjOBZTg6ku4pk/gx
PXVYCUQjacaJd6sipFdyuUBVoe5gKQ23xz+EyCKBfYV0TMbWl6VGc2UxUbKBunty
pUzsmHOoigajdt59DWPAcR3iFMQw8o4c/F0MDWBKHMLcyxC7tIqYEp4XNwd38iVN
M0CAxPyQ1oX8jb2YKP4/ON3jVROtnSNOJiA9YNlJeV/o67OPhYDa8t+mO2JODdn4
fNHThP/IiQUjaLahx/F6
=QAHO
-----END PGP SIGNATURE-----

--3sseE1tnmEs+TkKq--
