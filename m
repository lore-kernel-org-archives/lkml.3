Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752643AbaBSH6Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 02:58:25 -0500
Received: from mail-pd0-f180.google.com ([209.85.192.180]:49297 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752065AbaBSH6X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 02:58:23 -0500
Date: Wed, 19 Feb 2014 15:58:12 +0800
From: Kevin Hao <haokexin@gmail.com>
To: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Rob Herring <robh+dt@kernel.org>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH v2 2/4] of: reimplement the matching method for
 __of_match_node()
Message-ID: <20140219075812.GE14031@pek-khao-d1.corp.ad.wrs.com>
References: <1392762680-1498-3-git-send-email-grant.likely@linaro.org>
 <1392790862-18025-1-git-send-email-haokexin@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JBi0ZxuS5uaEhkUZ"
Content-Disposition: inline
In-Reply-To: <1392790862-18025-1-git-send-email-haokexin@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--JBi0ZxuS5uaEhkUZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Feb 19, 2014 at 02:21:02PM +0800, Kevin Hao wrote:
> +		/*
> +		 * Matching compatible is better than matching type and name,
> +		 * and the specific compatible is better than the general.
> +		 */
> +		if (matches->compatible[0] &&
> +			 __of_device_is_compatible_score(node,
> +						matches->compatible, &score))
> +			score = INT_MAX - 4 * score;

It seems that we also need to adjust the above as what we do for the type
and name. The v3 is coming.

Thanks,
Kevin

--JBi0ZxuS5uaEhkUZ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQEcBAEBAgAGBQJTBGQUAAoJEJNY7TDerrFx4LMH/0Nfvr8v1VbSaIrqqWwTeFO2
nKkI0wjOQI6Ca1pJqC6GM3EcdO6aE1tS0hp385+7N0fnOUvg+RAzjA6gylTuEJIf
DYtMQZkpQ+RAKlbIeqs/uzBD/YjuHuVQR4v5Vu7khsePb91Y+ZgcmmgOagu6iFa5
yZn5UH98tosn1fo61p+p+ZwPl2qDM+xkPaHCdbslmqcKp4Pw3S9AmXmGKRgsruzo
mk2X7omQ2O1Yw2tkWhGSMKLk82LvD4Zg0h+PXoIq1iMNP4JkpyXOZidLIDplqJzS
T9xayZxoHBU6nGEGleORIBYuXIC0WYgOt41sKMY36WLssX0ZkZqD1tdahgkHOfA=
=aXlQ
-----END PGP SIGNATURE-----

--JBi0ZxuS5uaEhkUZ--
