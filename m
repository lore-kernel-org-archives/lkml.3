Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758150AbaCRVSQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 17:18:16 -0400
Received: from mail-bk0-f43.google.com ([209.85.214.43]:40608 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755126AbaCRVSL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 17:18:11 -0400
Date: Tue, 18 Mar 2014 22:18:07 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Tim Kryger <tim.kryger@linaro.org>
Cc: Matt Porter <mporter@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Christian Daudt <bcm@fixthebug.org>,
        Grant Likely <grant.likely@linaro.org>,
        Linux PWM List <linux-pwm@vger.kernel.org>,
        Device Tree List <devicetree@vger.kernel.org>,
        Linux Doc List <linux-doc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Broadcom Kernel Feedback List 
	<bcm-kernel-feedback-list@broadcom.com>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3 1/5] Documentation: dt: Add Kona PWM binding
Message-ID: <20140318211806.GG5917@mithrandir>
References: <1394655346-30048-1-git-send-email-tim.kryger@linaro.org>
 <1394655346-30048-2-git-send-email-tim.kryger@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4ndw/alBWmZEhfcZ"
Content-Disposition: inline
In-Reply-To: <1394655346-30048-2-git-send-email-tim.kryger@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--4ndw/alBWmZEhfcZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 12, 2014 at 01:15:42PM -0700, Tim Kryger wrote:
> Add the binding description for the Kona PWM controller found on Broadcom=
's
> mobile SoCs.
>=20
> Signed-off-by: Tim Kryger <tim.kryger@linaro.org>
> Reviewed-by: Alex Elder <elder@linaro.org>
> Reviewed-by: Markus Mayer <markus.mayer@linaro.org>
> ---
>  .../devicetree/bindings/pwm/bcm-kona-pwm.txt       | 24 ++++++++++++++++=
++++++
>  1 file changed, 24 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/pwm/bcm-kona-pwm.txt
>=20
> diff --git a/Documentation/devicetree/bindings/pwm/bcm-kona-pwm.txt b/Doc=
umentation/devicetree/bindings/pwm/bcm-kona-pwm.txt
> new file mode 100644
> index 0000000..c8e2d13
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/pwm/bcm-kona-pwm.txt
> @@ -0,0 +1,24 @@
> +Broadcom Kona PWM controller device tree bindings
> +
> +This controller has 6 channels.
> +
> +Required Properties :
> +- compatible: should be "brcm,kona-pwm"

This is somewhat inconsistent because the example below clearly doesn't
set the compatible property to "brcm,kona-pwm". Perhaps better wording
would be:

	- compatible: should contain "brcm,kona-pwm"

> +- reg: physical base address and length of the controller's registers
> +- clocks: phandle + clock specifier pair for the external clock
> +- #pwm-cells: should be 3.  The first cell specifies the per-chip index
> +  of the PWM to use, the second cell is the period in nanoseconds, and
> +  the third cell is the flags.

Please use the canonical description for this:

	- #pwm-cells: Should be 3. See pwm.txt in this directory for a
	  description of the cells format.

> +Refer to pwm/pwm.txt for generic pwm controller node properties.

With the above, this line should go away. But still: "pwm controller" ->
"PWM controller".

Thierry

--4ndw/alBWmZEhfcZ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTKLgOAAoJEN0jrNd/PrOhdPoP/in+sozoaEIa6Cdl51/NuIzl
WAN+rlNjkkwyUVm4XY87guwwdnu0scjX0Cal8PaRoxmxdFSMNcRS5AX2W8pCylZo
9Te4RkFDnLJaXaYlcpvhevRz014HmY1tGnWdaSxySPt2jUXP3Y/d1rLZAVX9kOh6
BpBxER71Jd6htT8BkM2OSMdCHUPDxy48WLbtiyb2zngsrChqEa4OOHQf9YRKFdQD
SYWvQqP6gAeBTYH8amtTQjCf+4JAphlCm29ZaaMYsncbbiVKm24NXNFDTYXA8hcz
U7su5nwwHJOFhGGdsTX+wQ/9WHItewIsqIMnysdaRAU4xZ6E00N8tSoAIrKtA6HP
nvV5pWgpEaIDR1VKck38sNa6g1PKFJ1hDx1dHAjvKOKUxHiN8Yt4YdgAs7/NDhYP
7xtaYS0bCukAZrQxyo6CL7rASuy45TkRC4KyIZ29IeHrW+tHXpFfT8rAI0HUTVVm
8MxUAGyiuY+23wtSmqL9tI4l8LXvmXUk4xREYF1T9G+bQNrYvONczaY8gDNgybqc
ga22mMCnqH7Yo0vu0Vi/eZDw1JKu3728NSGfkCAwxPi0lsbybQ03dJJMoYkYGG6K
yfSDN1t2ei2RNmGXf81onNm5L5lU15lDvuERAc61c7/+VYk880l6gphOL1m+BiaR
1CKE+TDQGKAv0aY/wBxt
=z6zP
-----END PGP SIGNATURE-----

--4ndw/alBWmZEhfcZ--
