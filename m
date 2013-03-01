Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751896Ab3CAHS3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 02:18:29 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:34678 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750879Ab3CAHS2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 02:18:28 -0500
Date: Fri, 1 Mar 2013 15:17:58 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "Kim, Milo" <Milo.Kim@ti.com>
Cc: Axel Lin <axel.lin@ingics.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 1/4] regulator: core: support shared enable GPIO
 concept
Message-ID: <20130301071747.GG25302@opensource.wolfsonmicro.com>
References: <A874F61F95741C4A9BA573A70FE3998F792729F1@DQHE02.ent.ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UKNXkkdQCYZ6W5l3"
Content-Disposition: inline
In-Reply-To: <A874F61F95741C4A9BA573A70FE3998F792729F1@DQHE02.ent.ti.com>
X-Cookie: Condense soup, not books!
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UKNXkkdQCYZ6W5l3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Feb 18, 2013 at 06:50:39AM +0000, Kim, Milo wrote:

> +	pin->gpio = config->ena_gpio;
> +	pin->ena_gpio_invert = config->ena_gpio_invert;
> +	list_add(&pin->list, &regulator_ena_gpio_list);

We should really validate that the invert settings are consistent but
it's not so important since this is a user error that they'd probably
notice.

--UKNXkkdQCYZ6W5l3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRMFYRAAoJELSic+t+oim9ZU4P/2sWBSd+oGh2VAygxccV+zyR
T4SSsexLT4Wgs7LEgSGNA+Ob/kifhyynJcy2GTtboDPofy6MEycd8cCg6Iy8bCKM
yMr+q3iCu4YFFBekLUucwjL78jpBlP6TdXrVjj/Iw4CvQmqWcKXFl4EZajvOpYg0
t6PZoVwVXCW+BJCg1+WZ2ZG5p2T1fTgjzMupHw+1BCvwtZwxs8dmTtDsSpiCI+hV
ZBXrb/rnjyWQznf2/Uu5awrywblnaH865r9kdzUVBqsFmx4nDhJuaHKyGx574rIm
uDpgDeZfL9o0DLprbjNOW1U0Cf9CqBdS2QQqUJdjvUvlHae3eMn1XK3iENyksrle
68ScJgM9we/eIpvLVhlAyarEaKd3iqiZm+0BJmlo81QUToT0lrbSH7HGnfD8xlnx
vTkkT7gaK5JNFYIqMTl4WhwFdA8BXisD3AVd71ul+OKKW/tV0MO0jBDJB7DeK0Zh
vcaVGxmPzWWxN2kQXw4Z7ssP3IiSto20CWQ1f0wwGH6IEUbdMjSrSXxRLQah2QZW
fv+eNq38kFA3HVo8kK75xYJ5HBb2SGSUBXEeHiS61R4w5CzRlRzn84SROmGpC89j
FoUu+IOjgNXyGLm7+wR4/E97G/MgtY9HnQenBO6w/txE2/LWDHs4yqpfxWoEGf/a
HD1M8LIWJzmPfm+eZhvO
=Q08h
-----END PGP SIGNATURE-----

--UKNXkkdQCYZ6W5l3--
