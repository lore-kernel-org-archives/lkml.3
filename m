Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752929AbaKLOWK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 09:22:10 -0500
Received: from mail-wi0-f173.google.com ([209.85.212.173]:49439 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752532AbaKLOWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 09:22:07 -0500
Date: Wed, 12 Nov 2014 15:22:03 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Tomeu Vizoso <tomeu.vizoso@collabora.com>
Cc: linux-tegra@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        mikko.perttunen@kapsi.fi, acourbot@nvidia.com,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Alexandre Courbot <gnurou@gmail.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 05/13] of: Document timings subnode of nvidia,tegra-mc
Message-ID: <20141112142202.GB26488@ulmo>
References: <1415779051-26410-1-git-send-email-tomeu.vizoso@collabora.com>
 <1415779051-26410-6-git-send-email-tomeu.vizoso@collabora.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LpQ9ahxlCli8rRTG"
Content-Disposition: inline
In-Reply-To: <1415779051-26410-6-git-send-email-tomeu.vizoso@collabora.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LpQ9ahxlCli8rRTG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Nov 12, 2014 at 08:56:28AM +0100, Tomeu Vizoso wrote:
[...]
> diff --git a/Documentation/devicetree/bindings/memory-controllers/nvidia,tegra-mc.txt b/Documentation/devicetree/bindings/memory-controllers/nvidia,tegra-mc.txt
[...]
> +Example board file:
> +
> +/ {
> +	memory-controller@0,70019000 {
> +		emc-timings-3 {
> +			nvidia,ram-code = <3>;

I guess the alternative would be to keep the old names and simply use
the reg property instead of nvidia,ram-code to be compliant with best
practices in DT:

		emc-timings@3 {
			reg = <3>;

> +
> +			timing-12750000 {
> +				clock-frequency = <12750000>;

And:

			timing@12750000 {
				reg = <12750000>;

But I haven't been following this series too closely so far, so maybe
that had already been rejected.

Thierry

--LpQ9ahxlCli8rRTG
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUY20KAAoJEN0jrNd/PrOh3X8P/3Y5fCBqtDLQ126JvvXUvpHF
XdRGiVpx36Qeze/ZL/9/p2N4ofl0Y3t19QVBFAe3jmexfy1DlEEakQIawRMu50i3
vmZRgNPJ5uzPc3E5tCtWYacOiQk7Ol3Ousd86REKHaIR7hc1uSyiaViqalldpPmK
1w3kkSA0iNFxrEWqlKF+bvaiUb+R/4p+sNwLJeyKHT6gXLTRwV3mnz3w7ztuzkcG
G6WTy/qMbjFHkfiN7JF0pZ/XpS/cVX8JDgIwwSFj9opy30ZoeqOpK2hhD7MTkV7g
Qp4uJm0tt2isqmHZdYHah7on/FD3XLS/5X/LEfZ6MrpOXx4pHv7lZ+8gshKn4Pnc
pHPnY8bioyZi80hd2kso4XKsoN3k8bSPES8JPplMGhGHCawquTX8a56KrCBg1+IV
iSPtDRlGDzh3/PYIzHcrdVau3Rg8j6zRRGTDC3oK9QdWuUfA1fn9mnLG/LIO/R3C
GM5bJ9yXECAdnc4pgXToPess8zmYYqBJpoESM3bdLIcvkANuNJ/c6jqupHw46B3O
P3kCXkYHi4FxPVP+8Xtm3+H1zWGe5jh3LZNpHmHGo9q5IyXMpxwW9SV8Mq+pjQ1Z
O+cnNu+kj6wQJbO6EJ1K6u0MSIf6SQBM5Hx44KM4NRd1qqKQcntIaQVPWecjD7OT
e5+5sGsPduHayJXEYJkS
=d8aL
-----END PGP SIGNATURE-----

--LpQ9ahxlCli8rRTG--
