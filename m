Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755170AbaJ1Njb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 09:39:31 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:39709 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753516AbaJ1Nj2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 09:39:28 -0400
Date: Tue, 28 Oct 2014 08:38:56 -0500
From: Felipe Balbi <balbi@ti.com>
To: Huang Rui <ray.huang@amd.com>
CC: Felipe Balbi <balbi@ti.com>, Alan Stern <stern@rowland.harvard.edu>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paul Zimmerman <Paul.Zimmerman@synopsys.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Jason Chang <jason.chang@amd.com>, Vincent Wan <vincent.wan@amd.com>,
        Tony Li <tony.li@amd.com>, <linux-usb@vger.kernel.org>,
        <linux-pci@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 19/19] usb: dwc3: add support for AMD NL platform
Message-ID: <20141028133856.GB8123@saruman>
Reply-To: <balbi@ti.com>
References: <1414497280-3126-1-git-send-email-ray.huang@amd.com>
 <1414497280-3126-20-git-send-email-ray.huang@amd.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MfFXiAuoTsnnDAfZ"
Content-Disposition: inline
In-Reply-To: <1414497280-3126-20-git-send-email-ray.huang@amd.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--MfFXiAuoTsnnDAfZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

almost there...

On Tue, Oct 28, 2014 at 07:54:40PM +0800, Huang Rui wrote:
> diff --git a/drivers/usb/dwc3/core.h b/drivers/usb/dwc3/core.h
> index 8b94ad5..b08a2f9 100644
> --- a/drivers/usb/dwc3/core.h
> +++ b/drivers/usb/dwc3/core.h
> @@ -699,6 +699,7 @@ struct dwc3_scratchpad_array {
>   * @rx_detect_poll_quirk: set if we enable rx_detect to polling lfps qui=
rk
>   * @dis_u3_susphy_quirk: set if we disable usb3 suspend phy
>   * @dis_u2_susphy_quirk: set if we disable usb2 suspend phy
> + * @amd_nl_plat: set if we use AMD NL platform

however, as I mentioned before, the core shouldn't have to know that
it's running on an AMD platform. We already support several different
platforms (OMAP5, AM437x, DRA7xx, Exynos5, Exynos7, Qcom, Merrifield,
Baytrail, Braswell, HAPS PCIe, and STiH407) and none of them get their
$my_awesome_platform flag in dwc3, why should AMD be any different ?

This is the only part of $subject that I cannot accept because it would
mean we would be giving AMD a special treatment when there shouldn't be
any, for anybody.

--=20
balbi

--MfFXiAuoTsnnDAfZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUT5xwAAoJEIaOsuA1yqREZfYQAI5U9ijR0KTKUttzUJljLti/
t+E23iLt9B0HSP1nw8XzI3KSTL/Gny1c0qXijxLGJLcmVr61XSINUao0nx6Y1J+r
EnSHsJTqjVqPnaDcA7uuOg608x14ii4qJZIbKTOIh9TYsg1PtOMl3dpdkGrCFmgL
Ma/H9tPUEyfuzTa9ZraWJKioHnXIfgedQPUNZKHCnZ3woi6D4k4WTbmNsHR+P/ot
1Jf91tcd/jMorBPcWnOM6hX0rde6mNQoITUzljYD2OW4Qc9osvtsIBMIt4oANwv7
4d1ng4a/uUtQAdxYac2B2eJchhEtqzptwxYqMOsmFDNlWqQ5F6KMSKNJPNwKt6Sf
QkaBFUPzWOmCJ9n2YG6rMpGK5IEXJvrYGU8CiUCYmKNsl/sx6Rb2deqR2/7zPkGq
yLQVuOXOJ0dEK6xIiXrXjl7vkwBPZrzTUVxcoIDZwzamre5ZUxftpROului8XxIT
UGXw9v6pXDZc4eOE2BicRrq5ckCeUQfwKCsDIZO7ozV87AfPskjf2L6JiWIAQbpa
7VFuA2jz6DZATWpK6pPJTVk+VeECW8xv/PJvl+Bj2vWmN2NI9x++964/SyJyEZoN
I2j+S341vLnjft/pL3ybLZcHr0KvirNrfBPL6xRUspvFBjA2zdlvssnjR27w5+i/
Ih/YI5YAVG93gWyShM7z
=MYrO
-----END PGP SIGNATURE-----

--MfFXiAuoTsnnDAfZ--
