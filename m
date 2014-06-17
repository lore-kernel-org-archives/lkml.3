Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967755AbaFQWiH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 18:38:07 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:50928 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966205AbaFQWiE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 18:38:04 -0400
Date: Wed, 18 Jun 2014 00:38:00 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Tomeu Vizoso <tomeu.vizoso@collabora.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        David Airlie <airlied@linux.ie>,
        Mike Turquette <mturquette@linaro.org>, myungjoo.ham@samsung.com,
        kyungmin.park@samsung.com, devicetree@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-pm@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [RFC PATCH 2/4] ARM: tegra: Add Tegra124 EMC support
Message-ID: <20140617223759.GB25309@mithrandir>
References: <1402925713-25426-1-git-send-email-tomeu.vizoso@collabora.com>
 <1402925713-25426-3-git-send-email-tomeu.vizoso@collabora.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hQiwHBbRI9kgIhsi"
Content-Disposition: inline
In-Reply-To: <1402925713-25426-3-git-send-email-tomeu.vizoso@collabora.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--hQiwHBbRI9kgIhsi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 16, 2014 at 03:35:11PM +0200, Tomeu Vizoso wrote:
[...]
> +	memory-controller@7001b000 {
> +		compatible = "nvidia,tegra124-emc";
> +		reg = <0x00 0x7001b000 0x00 0x1000>;

For consistency, perhaps s/0x00/0x0/?

> +		#address-cells = <1>;
> +		#size-cells = <0>;
> +		clocks = <&tegra_car 57>;

TEGRA124_CLK_EMC?

Thierry

--hQiwHBbRI9kgIhsi
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJToMNHAAoJEN0jrNd/PrOh4J0P/2Ajb9j2ajRa6Cndcx1T4twP
XFlb1dyeZaiRslwkbckA8g5g/ZkNuyrsKOth9Q8a5U1r32o38IZCHBt8yKBKOgyc
d/Gspq5rP7zWKZ94ixCtCt4CBx54ZEeZ7t8dFV2ybnR6YXYM9+lGrKkM2KQ1vg6v
QhfQWVU5WHuRaxQGofbq/NWgznUp+IwXeYP5ci0sbekFeO0qKUkAs4zb5EtiDL3r
dESbUFRYOezLR1JWQis4eD9lGB5CckcZ/bJ7k3LDcDcgQwAk7X7m/lH/vPxQZNZT
VxtHYBlkjrt1GNHdzWSMiPjxE7FqZyX+TQQFO2IAli1CxrJQ6CbpiqzvVg3+clHU
lIgcvOd1buTbjWu8KgS8zbociQ3gRjmmzum11sFLqrTmc90mqf+HnASxwCGKCqsA
pjObfqdnG7+t/pJJyqjW5KcqOtna77X9HfUHLHe5+upeFqZueOHybbRS6OVcCdat
dKfskedRd9e9thxDK4FJX6B7cXCg5Ttn0Uji2Aj5Ri+8gam+2ZYmiHNa3GRnk4uO
9tUoNZh8eRx7hmT0KSyI5Pr+ieS/5m52HJqXoctkmZMpwDjVODim7z8sw3xBkNcn
/eBcNh1KfLWrwm6rxZBJFyRcRNMDCC+UhAIOuWGIaILkGNw+puj+9xsOmjBxHmXN
N9qMcdNIsyz/DqE1FA55
=eL70
-----END PGP SIGNATURE-----

--hQiwHBbRI9kgIhsi--
