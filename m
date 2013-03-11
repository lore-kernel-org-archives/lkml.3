Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753359Ab3CKIvj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 04:51:39 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:63852 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752327Ab3CKIvi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 04:51:38 -0400
Date: Mon, 11 Mar 2013 09:51:33 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: akpm@linux-foundation.org, a.zummo@towertech.it, swarren@wwwdotorg.org,
        rtc-linux@googlegroups.com, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 2/5] rtc: tegra: Use struct dev_pm_ops for power
 management
Message-ID: <20130311085132.GA7900@avionic-0098.mockup.avionic-design.de>
References: <1362991468-30226-1-git-send-email-ldewangan@nvidia.com>
 <1362991468-30226-3-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EeQfGwPcQSOJBaQU"
Content-Disposition: inline
In-Reply-To: <1362991468-30226-3-git-send-email-ldewangan@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:Hnos3vRXVMP0dwIcfzfi+iyHhwEHEHowMeScAUYDoke
 JGkCP7UG8sP4wAh4XEh8A63J7GWa0KkyIhkC7vhRIEF5rzAMoD
 epJ3i8kMGmsQAWQeR7m/JPAEmZipFSRGesTb1+RH8zAqTwNYlm
 HegtnXBiwxSmjPCLsPYcx4B7K5CICDSsuex15sQmBPM/IKGT4m
 cU5d08ewVqawnzYaAKdbNvIcp8wzxYEmpeTXwk2N4x4A+auW/m
 mwLNb0wkV4qsvXfgnlSPktrjdqBlC5JKtcMlSyuCfTAcfYq9VN
 40f5Xk3r3PXuwzJoqydaW2ghikbttxbFiHmTbLmEcMygiNJJL+
 TJEf/M1XiuYehMgNjX98ttkehJAk5r1DqCV6mQD77ufpAtS07W
 ZQCmK+DbHP2yljD595teDAvW8I62c0npjPxujlmYdFYepjjdi1
 6pEvn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--EeQfGwPcQSOJBaQU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 11, 2013 at 02:14:25PM +0530, Laxman Dewangan wrote:
[...]
> diff --git a/drivers/rtc/rtc-tegra.c b/drivers/rtc/rtc-tegra.c
[...]
> @@ -431,6 +430,8 @@ static int tegra_rtc_resume(struct platform_device *p=
dev)
>  }
>  #endif
> =20
> +SIMPLE_DEV_PM_OPS(tegra_rtc_pm_ops, tegra_rtc_suspend, tegra_rtc_resume);

I should've been more explicit. Since you had this marked as static in
the previous patch, this needs to be static SIMPLE_DEV_PM_OPS.

With that change,

Reviewed-by: Thierry Reding <thierry.reding@avionic-design.de>

--EeQfGwPcQSOJBaQU
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRPZsUAAoJEN0jrNd/PrOhUaUP/2PS48iepRWIsPSSrdthlRII
Fy0S55ZZQarzWxe79GiKaKPb5deA7wMpQaALspP3r5PJ1wmZgpDw5CgoRpOz6R8A
gNjuGXBs+7vzoljxzwF4giA2djUyHBy28VJ/BD+yTDoMHKj3fWtDJb39GOGdgL9C
Y3k6oJgb9rJs9mhMYs9f/ZV9qcetozz6x/Sd01l9qcZZKzFPoJPbqI3xTlaiqFHN
iTMR+3esZ+hHqhkfo/v11fy/VJaDFWX+/JSQuQS/jnSKn62KZypeinQgIYfrLcDD
KVCUQ2BnMBeEzejv2NzbosRUMVNX7gvJK9tTrrTvlra0FCmZIknIrI/L+bx86Vf/
VtkhgCWt/W5bRhrhUZOPvcIKD8n3GrpXoIw3qHvq71p1o9EgQVFJ7MMrE7WRVDrI
XWJaWhC0lXEkZ5Cr4qkZjIH7SKo57Slb5agrGLlGp8peMjFjB+xFNWzcD+SbSHUW
tC/HRmP673t/N2HmetxQ+s8eMKGL7FgtxkfADJuRYNb6vxwLjUXMn5t77YDI+t7o
NNDFKtGP8BJjzxPfcGpMXzlGdgSLZzh/b6rL8Yv/GYSCa7h+Fnr+xQGLHr3bYXtQ
UcxBTgo12rWSnyK2jPJHEpzLVgxTVzmXxP1BPpQxQpLGV3847S5EFHzgEbkhHNxj
ZDAq+4Apchsm04hH8X5H
=q9I2
-----END PGP SIGNATURE-----

--EeQfGwPcQSOJBaQU--
