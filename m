Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964832AbaH0TPa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 15:15:30 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:44181 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935490AbaH0TP0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 15:15:26 -0400
Date: Wed, 27 Aug 2014 14:15:07 -0500
From: Felipe Balbi <balbi@ti.com>
To: Kiran Kumar Raparthy <kiran.kumar@linaro.org>
CC: <linux-kernel@vger.kernel.org>, Todd Poynor <toddpoynor@google.com>,
        Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>,
        Android Kernel Team <kernel-team@android.com>,
        John Stultz <john.stultz@linaro.org>
Subject: Re: [RFC 2/2] usb: otg: Temporarily hold wakeupsource on charger and
 disconnect events
Message-ID: <20140827191507.GE6347@saruman.home>
Reply-To: <balbi@ti.com>
References: <1408701000-8555-1-git-send-email-kiran.kumar@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="10jrOL3x2xqLmOsH"
Content-Disposition: inline
In-Reply-To: <1408701000-8555-1-git-send-email-kiran.kumar@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--10jrOL3x2xqLmOsH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 22, 2014 at 03:20:00PM +0530, Kiran Kumar Raparthy wrote:
> From: Todd Poynor <toddpoynor@google.com>
>=20
> usb: otg: Temporarily hold wakeupsource on charger and disconnect events
>=20
> Allow other parts of the system to react to the charger connect/disconnect
> event without allowing the system to suspend before the other parts can p=
rocess
> the event. This wakeup_source times out after 2 seconds; if nobody else h=
olds a
> wakeup_source by that time then the device can sleep.
>=20
> This patch also refactoras the logic of wakeupsource_init,otg_notificatio=
ns and
> handle event funtions

refactoring should be in another patch.

> This is one of the number of patches from the Android AOSP tegra.git tree,
> which is used on Android devices. so I wanted to submit it for
> review to see if it should go upstream.

this paragraph doesn't need to be in commit log.

--=20
balbi

--10jrOL3x2xqLmOsH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJT/i47AAoJEIaOsuA1yqREiM4P/1Q0K54pYscGKv/JG7rDbemv
a7pvLSxd5BMMtdo2jDnz9fWGBW5My2AmWR6EkhgAok5KZGrHnk6EkMrPnNEh0vK8
m5tO1T4f+MOMuZgxvsR5wndo8NqHGMwsqvFEqQXFXPYBMQhQIyzkImqZR3DW22pN
1tYUi1RRnHDE4fp98HzJBy4vsqzrH5HllNfOcH1HdJgNsn/3IUnyUCLtoyPxesHo
DMGYs+kQKpiQrQ+tGZa1N39Z115Q7rvhcD6Ro8V1bLre5jlHN3a9Jvn7ThrGJ+WT
74yYPCYjiN1CMixAQubJcsNocFO4OtIj8A1iWF3DUSkdkLi+HTy5r8Uf3Wn45LDx
kkp2kV6FbYY//q0Ke0PD6I/jVvDx0XOm5kiANve4eGKs2f/8OMDWwWuvmRGKK86t
j0U1AumxNjxHZTEDSjuhJdeIGRNLODTaaGTKtgVH4R2lKW9h0NgSALftslqFBhsp
ic2ARubNYdAQehC+zm9odcevxQN/o+miqT6bF+URF/qoEBP5OpwOwRQSgfnxY4uM
1u8+K/X4z1+jfj2vdjk8gm+wFa3IjvrgCHTYKnj5kwg2ux7NHwm1a3Re591R71/5
bm8X5ygBAvlTZjRtXPlJuc1GZQmFvKkB6lLTTCfZoliL1m/2kvItQcIMm7D+av/e
hO8lwQYHE5pXhBJ0DHCf
=q4i+
-----END PGP SIGNATURE-----

--10jrOL3x2xqLmOsH--
