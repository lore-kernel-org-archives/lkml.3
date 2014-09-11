Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752948AbaIKRPt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 13:15:49 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:58232 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750835AbaIKRPq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 13:15:46 -0400
Date: Thu, 11 Sep 2014 12:14:39 -0500
From: Felipe Balbi <balbi@ti.com>
To: Dmitry Lifshitz <lifshitz@compulab.co.il>
CC: <balbi@ti.com>, Roger Quadros <rogerq@ti.com>,
        Kishon Vijay Abraham I <kishon@ti.com>, <bcousson@baylibre.com>,
        <tony@atomide.com>, <rob.herring@calxeda.com>, <pawel.moll@arm.com>,
        <mark.rutland@arm.com>, <swarren@wwwdotorg.org>,
        <ijc+devicetree@hellion.org.uk>, <linux@arm.linux.org.uk>,
        <linux-omap@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        George Cherian <george.cherian@ti.com>
Subject: Re: [PATCH 2/2] ARM: dts: omap5: Add dr_mode for dwc3
Message-ID: <20140911171439.GG1840@saruman.home>
Reply-To: <balbi@ti.com>
References: <1381402195-29257-1-git-send-email-kishon@ti.com>
 <1381402195-29257-2-git-send-email-kishon@ti.com>
 <52580F34.8030809@ti.com>
 <20140416161619.GH28035@saruman.home>
 <540D9449.3090008@compulab.co.il>
 <20140908132403.GA22409@saruman.home>
 <54103E15.3090406@compulab.co.il>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3ecMC0kzqsE2ddMN"
Content-Disposition: inline
In-Reply-To: <54103E15.3090406@compulab.co.il>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--3ecMC0kzqsE2ddMN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 10, 2014 at 03:03:33PM +0300, Dmitry Lifshitz wrote:
> Hi,
>=20
> On 09/08/2014 04:24 PM, Felipe Balbi wrote:
> >Hi,
> >
> >On Mon, Sep 08, 2014 at 02:34:33PM +0300, Dmitry Lifshitz wrote:
> >>Hi Felipe, Roger
> >>
> >>On 04/16/2014 07:16 PM, Felipe Balbi wrote:
> >>>On Fri, Oct 11, 2013 at 05:46:12PM +0300, Roger Quadros wrote:
> >>>>Hi,
> >>>>
> >>>>On 10/10/2013 01:49 PM, Kishon Vijay Abraham I wrote:
> >>>>>From: George Cherian <george.cherian@ti.com>
> >>>>>
> >>>>>Added dr_mode property in dwc3 and set its default mode to device.
> >>>>
> >>>>If there is a specific reason why this is not set to "otg", we need
> >>>>to explain it here.
> >>>>
> >>>>AFAIK the port is meant to be used as OTG port.
> >>>
> >>>we still don't have the workaround for dual role ports, I've been
> >>>working on it but still need to retest and make sure it's working fine
> >>>before merging upstream.
> >>>
> >>
> >>
> >>Does the OTG port suppose to work with OMAP5? I mean role switching
> >>mechanism?
> >>
> >>I'm testing kernel v3.16 with OMAP5 based board (CM-T54).
> >>
> >>If I set CONFIG_USB_DWC3_DUAL_ROLE, than nothing is going on when I plug
> >>some device/host cable into micro USB3.0 port (VBUS/ID detection with e=
xtcon
> >>events works fine).
> >
> >Dual role does not work. We allow the driver to the built with both Host
> >and Peripheral support because some platforms have more than one port
> >and building the driver with dual role allows us to make one port host
> >and one peripheral.
> >
>=20
> Please, can you provide some detail about platforms with several ports.
> How do that ports are connected to DWC3?

you have several dwc3 instances.

--=20
balbi

--3ecMC0kzqsE2ddMN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUEdh/AAoJEIaOsuA1yqREQu8P/RQfq8OkOmKPlgsQZWQmintm
kKmh52dCZgzzDjCKyoj3ADsth+W3lTpYOTFadgBFy3dSKx4vQqHYjwpfosUDO3+O
Z9E4SZpgOUHuik8B9H3Y6K8j4Aj/KQw0TqP9fNqGOO/RR4DRyqnRJWLryDp3LJau
HkJWuMnjLQ5sIwLeQnMvPAvtBTH/45o2CI48d1X7evN4cyNpi+BO6kK38/ceu0kv
CCxpKQaZw+MsEaqOgIIjNFkeCebkOhN+aKVkRtn4Asq2uw7uJDlLjMMerB7sd949
ViiNopJ9ntJC+OsSRW31Q0Zuj9P4D7md+JmmUMc8y/bY5equ19hZfegplToiX+10
O6gsehDD/Ghtg53BP8fApn65G/yHlXB8SkVILuw/ef/ISNZqZ4traNUkucZ8EjL5
MpB3rTIwZkDlwmcXgzMf15zZenSh6c5vIsl7CEhVAxCJnxSO8invothcmFbAyD4s
YoQeUDfPqIAg8steS88klM4qhmOvQwcxry+0lTY8Nj6VOpRV3cn0CRYzXWdgK0x8
dhrtsqBFgj0yL9CRkcSFPmhP6MOhhheEdL4LNkl++156KeeMkREiYaGm8yYLgPWc
yWeLbj8peHgedb6smvFJGdu80Gsml3o00eCh2hnX3k5Hu2NmyPf66VeBEjklpuVr
E9JKLdHD0o+Pz2CmRJVR
=Ch2r
-----END PGP SIGNATURE-----

--3ecMC0kzqsE2ddMN--
