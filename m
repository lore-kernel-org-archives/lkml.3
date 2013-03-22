Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932460Ab3CVKj7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 06:39:59 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:56180 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932278Ab3CVKj5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 06:39:57 -0400
Date: Fri, 22 Mar 2013 11:39:49 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Jingoo Han <jg1.han@samsung.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pwm: samsung: convert s3c_pwm to dev_pm_ops
Message-ID: <20130322103949.GD4567@avionic-0098.mockup.avionic-design.de>
References: <000201ce1bb1$e5df6fb0$b19e4f10$%han@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="J5MfuwkIyy7RmF4Q"
Content-Disposition: inline
In-Reply-To: <000201ce1bb1$e5df6fb0$b19e4f10$%han@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:6Wncq5Oca1qoZbhxRz4eCk9cQGMKLFv1nqauZJ00ZeQ
 uGgCzj0x+pmyZWB0Nosm/o3bLbk9P4g2jqlAaA16uopYbYlNbf
 EkKHrlf3KQ/R8upnQZELzPZpnbWjknDIGAFpmI80bj3rX0CwNy
 s582AZKITAD7vFc8dBVnP8EdZNk7Tt8cdzFehhlD9MSw9h4FE6
 2iShBe6OgjKFKai1847Jx9PM/LkupdLH1uhvTV20GTQbrClLqG
 WNe0hKMBlS4gA3dvoJ40SS8dh1oTNPQ6aE5BSL29HOUN3xV3nL
 FAOjtWp7qSYQM9h3OF5C4yMa/XGlNCvowIJilHJ/uWJqxNOKt6
 n7zY6n1/TpsJXOuK7O8v4Pbi8hrYSg9Cyx8LY+Advw4YqnENQH
 fIsdq6fTNXsydjnprGJV2v64j/1R9uqmQsVmAeUMGzk/16z82U
 bbOSS
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--J5MfuwkIyy7RmF4Q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 08, 2013 at 01:03:31PM +0900, Jingoo Han wrote:
> Instead of using legacy suspend/resume methods, using newer dev_pm_ops
> structure allows better control over power management.
>=20
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> ---
>  drivers/pwm/pwm-samsung.c |   20 +++++++++-----------
>  1 files changed, 9 insertions(+), 11 deletions(-)

Applied, thanks.

Thierry

--J5MfuwkIyy7RmF4Q
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRTDT1AAoJEN0jrNd/PrOhKc8P/RZCjWFoQ4owTdkDWeFu1fGJ
4KsSHSeeumQlGLbmf3BT+ApWx2bKXNEgZFJJf1xnUQqGwN62YfE2sFuyYODpmuht
kKJ9JSikcKbylxWs5kmILqdepOCWSJGKD7ChkyAaATre5BcQUhsMFXhzfSjcaeqp
IE29D2i1ovnuwwH+wJnxNo88ThbP9OlWitOnKSoSAcCQqfgbyYoSY3fkMt74Nra5
zw7jI9w7Pwwsl7dh8ld6fNSJBVG1mvBoiHnG7XRItMlYLECrG0WQ23U4PUqSbcDP
+QFpvUAyoRL4tJGXdkYvcsznGDzDBT5NpTwPnFnhrutcil0DTYt0xvRMxfjPrhFz
mBZF1QpFhU4SwdoOoTnCkNLmf9zhzaDHz542GHEO11dCJj+5dPMS9choZpQ0HUFd
nmkvG/wsavGEm4IXw9WwHoxhazAcuvoNZ6f3pv4mQrIwFSDKUZRo/oFWp/kFQKOC
2oj5b/Yvj1z6yaGom6D3ucfrXKYHH66TBhX2lZzX2qAw7NLSDgc05QnZ8xOIEYIL
WuKjr6DUmFzmt6q03Ua8jcbO0kcJbSYRyq9mxPuEbjsrkxgXq7hbgxcJ9OSjKYlB
EvHQ0INnzfZ0YRSYMOlmyjaMngNrn+ScNA+qrIm62Cp4+H/1HRZv1WqtoJdekEBv
UdGcABApGAf5vIIFltoh
=G7hs
-----END PGP SIGNATURE-----

--J5MfuwkIyy7RmF4Q--
