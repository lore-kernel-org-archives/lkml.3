Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753340Ab3CJWc2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 18:32:28 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:55334 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751487Ab3CJWc1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 18:32:27 -0400
Date: Sun, 10 Mar 2013 23:32:20 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: akpm@linux-foundation.org, a.zummo@towertech.it, swarren@wwwdotorg.org,
        rtc-linux@googlegroups.com, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] rtc: tegra: Use struct dev_pm_ops for power
 management
Message-ID: <20130310223220.GB4743@avionic-0098.mockup.avionic-design.de>
References: <1362852588-13362-1-git-send-email-ldewangan@nvidia.com>
 <1362852588-13362-3-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Yylu36WmvOXNoKYn"
Content-Disposition: inline
In-Reply-To: <1362852588-13362-3-git-send-email-ldewangan@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:w4Z9e3aHS8J74Y9zkuNj61YQkXtSMryUz3jpmWSKlwW
 Qx7QzzofHtgnPFoxqKc9NpPl6so6WnGa6C/FOO1JVLmW/tsiR9
 CGyHsaEIWN+JCEm5y1lwpxsTbWrxmed5p/0eaGRnRgstgmhEGv
 SVsvwo7/3ICKsKTn49zyHs3pZJXAwJPXSrcLvI5M5wtTGGX9Z5
 5XJMuB6s090gesG9QaIY75lROL/NSwnQwEwkfRTIxXbtfe3EFo
 AIhv5GbOkl7vb2NHSzH8e6A+umew0SkwgO+wPjewseMdWXj5F1
 vmMXir+CE6XD6lINpOkcwWdfqfIo6Kz8SEvAKrEFaKRQdq0gX6
 neMTCo4l5asEb9VWBbM39wqwYX1zAHbar7akbipc49ekW18DIW
 p4BTp7p4wf30gmk2FulF1yFGUXtddOCJ0c=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Yylu36WmvOXNoKYn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Mar 09, 2013 at 11:39:46PM +0530, Laxman Dewangan wrote:
[...]
> @@ -431,6 +429,10 @@ static int tegra_rtc_resume(struct platform_device *=
pdev)
>  }
>  #endif
> =20
> +static const struct dev_pm_ops tegra_rtc_pm_ops =3D {
> +	SET_SYSTEM_SLEEP_PM_OPS(tegra_rtc_suspend, tegra_rtc_resume)
> +};

SIMPLE_DEV_PM_OPS?

--Yylu36WmvOXNoKYn
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRPQn0AAoJEN0jrNd/PrOh86wP/jtkPl3VpeO25340mAEGjTER
07bEB94whlRYs0qFvXGlNljnZPesZp73pKVlTbA9V83iRtcFq0Oelp7e1LFlTpBs
ZG8tuKBJU5wIm4r0ajUYw/JAsbqOnRnalvFBqCNHvZ8NyMy2V9Aq9UWhVNI6Z5Nl
5BqpGRokUNzCfCCLPhLbrl/nxtF1Cp5eETmSiDVMM5YS2oiuKIQtspm9cUmr7AXY
nBhxju1YudaQ9Mz1Fx5/n3/C919y+agmZacnc4XuqQHjp+JHivmMTbEdCb/NOGqW
yK/JtSiI+gKRe1nHX5QNVtnDfleHRRTJcM46UICN5SS0j2cz2B0cYQkpG9MyIv85
NmD9io0veBQvlo7tr8olxO0qzUma62iCEkvVlsB6Rfb6rF0ZDGuNY4PvhrSCR1RZ
87dR9oyK9eqwai0OVLqRcCgtYFvVdMUXuirDm69J1rAenmlj1sZozxkXQKZBLdT7
yxIYNgvKRazDjG3yCxAnyhJoyGL0LNqCOuOlACfknpV+v71Db0OAAzVJ08/TBa6w
VF6wao1JM7GrpeWunkhuPF8IzWWEN5j14a+mrPtLJo0D9h/x1Yevr6RknIEPfM6l
N8gFG6fyk6QpxCcVuIt42vxREYF+Rd34DLvG9dKM3AoXUxsP7I6Fo0xmiYP655IY
iYBP+UD6T88daX68JN8g
=QuVI
-----END PGP SIGNATURE-----

--Yylu36WmvOXNoKYn--
