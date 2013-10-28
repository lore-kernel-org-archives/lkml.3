Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755336Ab3J1GMh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 02:12:37 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:39041 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751737Ab3J1GMg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 02:12:36 -0400
Date: Mon, 28 Oct 2013 17:12:26 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dave Airlie <airlied@linux.ie>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jani Nikula <jani.nikula@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        <intel-gfx@lists.freedesktop.org>, <dri-devel@lists.freedesktop.org>,
        Rodrigo Vivi <rodrigo.vivi@gmail.com>,
        Ben Widawsky <benjamin.widawsky@intel.com>
Subject: Re: linux-next: manual merge of the drm tree with the
 drm-intel-fixes tree
Message-Id: <20131028171226.a06b0d5448200409fbd39aae@canb.auug.org.au>
In-Reply-To: <20131028164609.bdec95d18a41b59fc37fbae1@canb.auug.org.au>
References: <20131028164609.bdec95d18a41b59fc37fbae1@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.21; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__28_Oct_2013_17_12_26_+1100_mG/K2p8N2_SyZCHu"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__28_Oct_2013_17_12_26_+1100_mG/K2p8N2_SyZCHu
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

On Mon, 28 Oct 2013 16:46:09 +1100 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> @@@ -1486,8 -1542,8 +1562,8 @@@ static void intel_edp_psr_setup(struct=20
>   	intel_edp_psr_write_vsc(intel_dp, &psr_vsc);
>  =20
>   	/* Avoid continuous PSR exit by masking memup and hpd */
>  -	I915_WRITE(EDP_PSR_DEBUG_CTL(dev), EDP_PSR_DEBUG_MASK_MEMUP |
>  +	I915_WRITE(EDP_PSR_DEBUG_CTL, EDP_PSR_DEBUG_MASK_MEMUP |
> - 		   EDP_PSR_DEBUG_MASK_HPD | EDP_PSR_DEBUG_MASK_LPSP);
> + 		   EDP_PSR_DEBUG_MASK_HPD);
>  =20
>   	intel_dp->psr_setup_done =3D true;
>   }

This last hunk is wrong.  I fixed it up to do the reverse of the above.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__28_Oct_2013_17_12_26_+1100_mG/K2p8N2_SyZCHu
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBCAAGBQJSbgBPAAoJEMDTa8Ir7ZwV5eoP/RUVkZQ6l2BbYFxvDr36chvt
yMOL07sNuM9WDJnh0qwv06pTpqdzeOlvgNHOcyrQbFO3MMvwXVYQbRusJmOZvLJE
i0kdzhKi3C8BC8RZhrRczjXirLok71xAdzjTdGPV8yRonObwNLxy0IztaSbMNqTD
U0zxmlGYI2Ye4l6Gx4XQyqS6y5+YvaGOrmNks8RU0HnYRnpAoxb75LpZ4Ga2KX5b
TFbkbk0txrEKU2uqLQAC5o0S3ykzfLsCq6r494nlf1gA39gFdh4Izt6b78crZ1bl
3eA6/YHoJDut2cmnCDluKwEGY+1WxNyWCC4dPzQ7ThQIqjj+GikqSaf11Mh80vZj
CA4IyAuPYv8zxKBEaZH53UCTRQNXJ65462UKK9+J0nj98qXdYPJw0RlZOFt7rIQO
Fx6bZi7Y2I4yDY5cIineNzN0Xxfo/HV++yEzhq+iPOIoC9KR5+ULHSDixG2UiGCr
UyyLs904HpLjy5V2WF9qz6Wq6jpwQJers202T4S6eOL5TlHw0y54Y2nRZBVtoABl
YJZAD9sbapmP9Z8FKolEhfh5ZPCUF8Q/Wb13SeQEpKXS+Qh5MF5r3kaSBAoCGS4/
9REB9uR7jUqhPuZUCRWdZdoVWjzaxWZV5Z4atGN9Km0SfMUHBnOMNFVqEghAVXrQ
ASJNU9buHRKD7M79+oP7
=WSox
-----END PGP SIGNATURE-----

--Signature=_Mon__28_Oct_2013_17_12_26_+1100_mG/K2p8N2_SyZCHu--
