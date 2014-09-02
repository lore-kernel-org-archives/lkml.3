Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754775AbaIBQbj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 12:31:39 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:46771 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752831AbaIBQbh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 12:31:37 -0400
Date: Tue, 2 Sep 2014 17:31:05 +0100
From: Mark Brown <broonie@kernel.org>
To: Doug Anderson <dianders@chromium.org>
Cc: Chris Zhong <zyw@rock-chips.com>, Sonny Rao <sonnyrao@chromium.org>,
        Heiko Stuebner <heiko@sntech.de>, linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        zhangqing@rock-chips.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <20140902163105.GY29327@sirena.org.uk>
References: <1409674469-12123-1-git-send-email-dianders@chromium.org>
 <1409674469-12123-3-git-send-email-dianders@chromium.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+1tcKVLXPU0QafK6"
Content-Disposition: inline
In-Reply-To: <1409674469-12123-3-git-send-email-dianders@chromium.org>
X-Cookie: Simulated picture.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/2] dt-bindings: Add input supplies to rk808 bindings
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+1tcKVLXPU0QafK6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Sep 02, 2014 at 09:14:29AM -0700, Doug Anderson wrote:
> The original bindings for rk808 didn't include input supplies.  Add
> them.

Acked-by: Mark Brown <broonie@linaro.org>

You probably want to send this to Lee...

--+1tcKVLXPU0QafK6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUBfDGAAoJELSic+t+oim9WG4P/1Xq4YJpZJdp04srl/v3YgUP
4SjEN3iM+QDQpf6L3AromyqspVOKU9FYpUuqWMyvfiRjPJilS6s+dWaDf+xWdIT5
Mqx7nc9dOXN3wLYxkC/Lhju8Nib0/gMFI9FmrfqaQ+PyABiIQLm2LHQ2Pj4fCO7+
+Q4hZZMNpkHfRUbLg02cyWIgaUse5OPyfjaGkGLqjdcgDCp+1ylOMcv+fD1Q5tja
VURysDkP1DKRiluV2oBGnOgtQvEp+n12kCJo8D+zUs7HwTp795eypt4qxgq9AaFZ
R8ZyJQzVe6EWl+koFDycWMC57WiKJdpcvGBMNWv4eiPAeW9LEn9Y+ahzKtuyfFgQ
/k6DR0068o2ts69DW0hdCGIyULKvp/8N6MfALW11r1GE6FF2EqQkDY3pTC/t3e4B
J7bt3VeNS8OJ0oyeL8m/+4Eo7C5BDeo+ZKV99jv+DcuLlyuEZNrFPtqzeJpfcws3
PYxtsuMCPnrueSiX9onkYWydPqCFOFo4v3Wd5OZMqvzi6/AZADyHUwYhi6Y+F4CP
+HyMFn35p8zRu01xjy87GFS6bTTgzkBrukVrPZtxN0n8Iqa440K/iZNzf60Qxjzq
GZ2r1PyhyYC2UuukMJrSGQO+dTzqZ063XcbJ/zzOSJgXEau3y3AZhtvjchLEMRwI
3hBPwIpkkHQwyV2gM6bE
=sJgB
-----END PGP SIGNATURE-----

--+1tcKVLXPU0QafK6--
