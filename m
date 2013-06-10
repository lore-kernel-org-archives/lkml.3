Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752347Ab3FJTzR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 15:55:17 -0400
Received: from mail-bk0-f48.google.com ([209.85.214.48]:63440 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034Ab3FJTzQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 15:55:16 -0400
Date: Mon, 10 Jun 2013 21:55:12 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Jay Agarwal <jagarwal@nvidia.com>
Cc: linux@arm.linux.org.uk, swarren@wwwdotorg.org,
        thierry.reding@avionic-design.de, bhelgaas@google.com,
        ldewangan@nvidia.com, olof@lixom.net, hdoyu@nvidia.com,
        pgaikwad@nvidia.com, mturquette@linaro.org, pdeschrijver@nvidia.com,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        jtukkinen@nvidia.com, kthota@nvidia.com
Subject: Re: [PATCH V3 3/4] ARM: dts: tegra: Correct PCIe entry
Message-ID: <20130610195511.GC25859@mithrandir>
References: <1370372252-4332-1-git-send-email-jagarwal@nvidia.com>
 <1370372252-4332-3-git-send-email-jagarwal@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/Uq4LBwYP4y1W6pO"
Content-Disposition: inline
In-Reply-To: <1370372252-4332-3-git-send-email-jagarwal@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/Uq4LBwYP4y1W6pO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jun 05, 2013 at 12:27:31AM +0530, Jay Agarwal wrote:
[...]
> @@ -29,7 +29,7 @@
>  		ranges = <0x82000000 0 0x00000000 0x00000000 0 0x00001000   /* port 0 configuration space */
>  			  0x82000000 0 0x00001000 0x00001000 0 0x00001000   /* port 1 configuration space */
>  			  0x82000000 0 0x00004000 0x00004000 0 0x00001000   /* port 2 configuration space */
> -			  0x81000000 0 0          0x02000000 0 0x00010000   /* downstream I/O */
> +			  0x81000000 0 0          0x02000000 0 0x00100000   /* downstream I/O */
>  			  0x82000000 0 0x20000000 0x20000000 0 0x10000000   /* non-prefetchable memory */
>  			  0xc2000000 0 0x30000000 0x30000000 0 0x10000000>; /* prefetchable memory */

That increases the I/O region size from 64 KiB to 1 MiB. Why is that
necessary? I/O operations can only address 64 KiB, so I don't think
adding more makes any sense.

Thierry

--/Uq4LBwYP4y1W6pO
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRti8fAAoJEN0jrNd/PrOhxjgQAK+1wN9vDfIequNMrEXlvb6d
Js6PT0otdyJqyYIOkyLDQWX0QxL14v/OKgI0zrcWoxD/IyYNAbEfLbPK9Eu0vTEv
6rRGBzNLml1vg3DLctY07pkJ6reJGszQraqTSyRID98Hf/AfcHMAnjTU54jtvQ4j
sS6Guay5XtYa+dR/3EhTIuVjv4lTPWX36DYKh2fiZeNQfKEZosnPoIVKZtWfTWHU
ozdi8X24PK+5lLVeJpMgAD0/TzIOzzAFgvSqW/SdfLesIPUQk7oqk2WlHlZx75ni
H9o0gujde9Fij2q3ySRNEvRiJAOMxNInGAmo9QyUPxJ928bP2x5FkFN7dcFseFZI
UgPM42ZfZw+nluGQ+ILH153g/YyaSkhwY5tf01mWNe/BIgOqTQ0r0W67HuLCHm92
PPqXwL1xrXpw2QUePolgdR7gHXDGRANlq8Q9yQ2xCiS/p2bSEhZxPlZ+0q7VMWdv
TtM0RJHrL6N3C0O6Wwig004mjqR8/EidoVlB54rfI9Ig74RBr2i6oMx98H9AGmkG
WLgCRHyEXLmF875NOz8Bz38MsFzXhQAlAfqV0Ufxuwvti4bWb14GjOyy5wOLfxpL
vV16A/f3DDkIuLnkqmi/H9FdOii3xYyF8iyfQqGl7qvkayHEebHUaodiAYc/NDBy
+f0h+yfoazYuRKpjrOU3
=xmA8
-----END PGP SIGNATURE-----

--/Uq4LBwYP4y1W6pO--
