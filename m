Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932466AbaHGOY5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 10:24:57 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:53021 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932128AbaHGOYz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 10:24:55 -0400
Date: Thu, 7 Aug 2014 16:24:48 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel@stlinux.com, linux-pwm@vger.kernel.org,
        devicetree@vger.kernel.org, ajitpal.singh@st.com
Subject: Re: [PATCH v2 09/11] pwm: sti: Ensure same period values for all
 channels
Message-ID: <20140807142446.GB11095@ulmo.nvidia.com>
References: <1405348412-7352-1-git-send-email-lee.jones@linaro.org>
 <1405348412-7352-10-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PmA2V3Z32TCmWXqI"
Content-Disposition: inline
In-Reply-To: <1405348412-7352-10-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--PmA2V3Z32TCmWXqI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jul 14, 2014 at 03:33:30PM +0100, Lee Jones wrote:
[...]
> +/* Calculate the number of PWM devices configured with a period. */
> +unsigned int sti_pwm_count_configured(struct pwm_chip *chip)

This should've been static, which is what made sparse complain. I've
fixed it up.

Thierry

--PmA2V3Z32TCmWXqI
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT44wuAAoJEN0jrNd/PrOh0aIP/0HXvRYtb6MKcrdPpJ0UtPrt
P7uI8KgGT78WzZBAKvkBmn9ljk57U/iFDn579TD9ZAItjF4BwMvjg0fGHOYXP5bD
W6qHnzavyE492GZSHP1fIENM652siWZCywg8LdYKOPP9If7a4oI+e+xB5gaSWLHd
hCl3Oq3G/ATbLr7ZIB9M4lvPGOLkYv4l/q7TPxnC2rA9EurQmCI/Ipf6dXv9uF5Q
4Ggnz6n/uvNQzV2WDJ/GxNt8/gz/RFgOwvDLGpngWHPDpGCjQiZjKuIAzxHRRzfB
kkZhL86cPnD9j2W0hM6V8zi/yR9Q/SbfVpObkZxrf8lpyt++we3wkPisB+yn1Ua3
MxO9YEh8NuLzUT4Jkac35rv8uhjHRlHL1uAjl8fkXEBm1CtW7BoO3Yx31Q18IJqu
R5DP8pH04a1h73P2rMiHFSQyMvGe91TnEeMb7VRziGuMxzLOREqG7cpITaNcj2Ef
1NW2MPStklLh2fLkj0sapA+oL9kd8FQkQZumY3pQIL0pvsp0bk3pbB6rB1uz+p57
6rzHjYtljkF7UcM4w3yNUqW6+uXLT86/MRryeTp0L1s4CLnIMri3zJ5Yklnb3dSG
m18p34/JCw0aVdvD2+fX39lH7EemgM61z5rkOkH+BQdxEa1aEzOTC5VaQue9aPN9
EmiiDnSpTwVwfu7CjNr3
=7ixd
-----END PGP SIGNATURE-----

--PmA2V3Z32TCmWXqI--
