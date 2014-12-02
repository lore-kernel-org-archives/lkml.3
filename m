Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753631AbaLBJru (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 04:47:50 -0500
Received: from mail-wg0-f41.google.com ([74.125.82.41]:54727 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464AbaLBJrq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 04:47:46 -0500
Date: Tue, 2 Dec 2014 10:47:42 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Andrew Bresticker <abrestic@chromium.org>,
        Stephen Warren <swarren@wwwdotorg.org>
Cc: Alexandre Courbot <gnurou@gmail.com>, linux-tegra@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Jassi Brar <jassisinghbrar@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Grant Likely <grant.likely@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>,
        Kishon Vijay Abraham I <kishon@ti.com>, Felipe Balbi <balbi@ti.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH V6 05/12] mailbox: Add NVIDIA Tegra XUSB mailbox driver
Message-ID: <20141202094741.GC6135@ulmo>
References: <1416874644-12070-1-git-send-email-abrestic@chromium.org>
 <1416874644-12070-6-git-send-email-abrestic@chromium.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8NvZYKFJsRX2Djef"
Content-Disposition: inline
In-Reply-To: <1416874644-12070-6-git-send-email-abrestic@chromium.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--8NvZYKFJsRX2Djef
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 24, 2014 at 04:17:17PM -0800, Andrew Bresticker wrote:
> The Tegra xHCI controller's firmware communicates requests to the host
> processor through a mailbox interface.  While there is only a single
> physical channel, messages sent by the controller can be divided
> into two groups: those intended for the PHY driver and those intended
> for the host-controller driver.  The requesting driver is assigned
> one of two virtual channels when the single physical channel is
> requested.  All incoming messages are sent to both virtual channels.
>=20
> Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
> Reviewed-by: Stephen Warren <swarren@nvidia.com>
> ---
> Thierry,
>=20
> I've left this as a separate driver because I don't think it should be
> combined with the xHCI host.  Stephen and I discussed this earlier in
> review of v1 of this series and he agreed that the mailbox belongs in
> its own DT node and driver.

My objection wasn't strictly against merging the drivers. What I don't
want to see is two devices sharing the same memory-mapped regions in DT.

That's based on earlier discussion with Stephen as well, because we have
had the same problem with USB and USB-PHY before. Unless I completely
misinterpreted we came to the conclusion that we should avoid this in
the future.

Like I said, this doesn't mean that both need to be in the same driver.
We could use MFD for example, or provide an entry point in the mailbox
driver that can be called from the XUSB driver to instantiate the
mailbox (which is really the same as MFD).

Thierry

--8NvZYKFJsRX2Djef
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUfYq9AAoJEN0jrNd/PrOhAjsP/jQ382JNqadfDFsBPsWxQiqa
pkYO8rripE9yDaU1NtK0601yfpQzganxugkl9OICZ6cU90MTI2hw3RWteaHvvD37
DPhJ1R/13yvDO8OmdjcnAYhiUdNLxuSocEOTtgNuUetmMx83LCEGeOXmXSI+Zt92
jDHHOWEfN+LJ8lY9U8qQ2r/ZzEY1QHnq1C0ACO4SbFku/ABWjtPVcOt67X0GhIit
h1+bLLUC5mPQrdutyKWUy0+32ohIvfMCBkJ5yitxQJ42CSDd2n3DKDMY9xwtBjlx
dxM5UQdajtoBuSd+FlWk0GyoH8EVJePaOBzGwLqTB6gv7DDT41bA+518wy5HMo4W
hXG8zuFeV+Z83iD6tGXQL8Kx46oeRn9RvzVDfGcKQagkspyAHwEcvGfTIh/be9aG
10ssMn8DgeK6nF4DufhMUj0UowNB60MGs1y8qyKgOSEA97p1VfHR9Cktv408sEml
XSrSegN5Tt3ogHKLzfHIgyXTG6PJ3hOy5seMvmkztzzl2eOuMTWornjuQe33eq4U
Rcrgjz03HW/yXF5BEEI0Nb/O/hV1t8RlsdFNmo+KdOaFeaJpjafQm280a9T2Zsr6
uze/bGhT1Y4peOHdl30Nu8dKHpdCths53J3IrvHpQpMPtBI+1bf5Ihqi4wcJNyzT
ByGCnw1O7FR8Pe2ZeIFV
=vDMG
-----END PGP SIGNATURE-----

--8NvZYKFJsRX2Djef--
