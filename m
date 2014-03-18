Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758292AbaCRVyG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 17:54:06 -0400
Received: from mail-bk0-f51.google.com ([209.85.214.51]:38514 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757199AbaCRVyD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 17:54:03 -0400
Date: Tue, 18 Mar 2014 22:53:58 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Matt Porter <mporter@linaro.org>
Cc: Tim Kryger <tim.kryger@linaro.org>, Rob Herring <robh+dt@kernel.org>,
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
Subject: Re: [PATCH v3 0/5] Add Broadcom Kona PWM Support
Message-ID: <20140318215357.GI5917@mithrandir>
References: <1394655346-30048-1-git-send-email-tim.kryger@linaro.org>
 <20140314134324.GY25092@beef>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="k9xkV0rc9XGsukaG"
Content-Disposition: inline
In-Reply-To: <20140314134324.GY25092@beef>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--k9xkV0rc9XGsukaG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 14, 2014 at 09:43:24AM -0400, Matt Porter wrote:
> On Wed, Mar 12, 2014 at 01:15:41PM -0700, Tim Kryger wrote:
> > This series introduces the driver for the Kona PWM controller found in
> > Broadcom mobile SoCs like bcm281xx and updates the device tree and the
> > defconfig to enable use of this hardware on the bcm28155 AP board.
> >=20
> > Changes since v2:
> >   - SoC DTS file updated to use real clock's phandle + specifier
> >   - Toggle smooth mode off during apply so new settings take immediately
> >=20
> > Changes since v1:
> >   - Fixed up macros to be clearer and more complete
> >   - Corrected spelling and punctuation mistakes
> >   - Added support for polarity
> >   - Made peripheral clock use more efficient
> >   - Made prescale and duty computation clearer
> >   - Moved Makefile addition to keep alphabetical
> >   - Split complex lines into multiple steps
> >=20
> > Dependencies:
> > The "ARM: dts: Declare the PWM for bcm11351 (bcm281xx)" patch depends
> > upon "ARM: dts: bcm281xx: define real clocks" which is queued up in
> > for-next of arm-soc. See https://lkml.org/lkml/2014/2/14/451
> >=20
> > Tim Kryger (5):
> >   Documentation: dt: Add Kona PWM binding
> >   pwm: kona: Introduce Kona PWM controller support
>=20
> Thierry, are you planning to merge these first two for 3.15? If so, I
> will apply dts patches for my last mach-bcm 3.15 pull. I don't want to
> do so until the binding is accepted.

I've reviewed this and it doesn't look like 3.15 material.

Thierry

--k9xkV0rc9XGsukaG
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTKMB1AAoJEN0jrNd/PrOh838P/iOx0jBvU8WyFgVf7QAlrPd4
gFCSHAmju3qqzjuv1k+79aHCuf2MyNeFYG4BBZS6bBg9DpsX4uqtVbyuK1T3A656
1cIC+dPDDiiU/RgxHYZJehS03BtYobOfGtvI51psuJ+AE5x2ChWGkhsbnCgUTDE2
+gdAy8zb7bYxFZ0UbyUMJvRCSajbrjs2QPTqsGqGgLjr7zsGd7wnzfTJ54lJ9e3e
lyXfskKMQJrOiZRYAw1vHs9mYBrbApBxf3trJqWj2htqhT+QoEfw9vkjBMjgKJid
XMc4eocnZLSKsM6LLycVpncMV0Km8p8MBqtriAXDGamND78XyZcHc/k9khhkgY0x
HPRYkwtbUyNM2SsytU20QuoKz7S+mpy6NnLDNpcfbqbuo7N3fMfwvU7eeGA2U9p1
ae/C8n2p11DxQPd7Ne3mIQUZ2xYBjzXw132XzmXi7lJpYKAWGUAx0beMEgXZfkFL
5oTfAtJajZQQQ++uh0ppY7l1upzIaV+Gf+9Nel6/N0GnTmonBEAiN7GU+Bcd1T00
ocUQoG7yDTsE14v7DdMkSKYl6XMMMieo3V4i712xDnXxnodyHeYLZ+VcZhKwFyH4
L/wpTzx/T23HPKNWhKVHxN7VY64biHVaBVOjj61kM6DiOinYcxL/ZHE1xxXzvIB7
xrvVZszr1/r6mRANVMip
=Rq9l
-----END PGP SIGNATURE-----

--k9xkV0rc9XGsukaG--
