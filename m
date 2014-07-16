Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751720AbaGPTvr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 15:51:47 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:50425 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027AbaGPTvn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 15:51:43 -0400
Date: Wed, 16 Jul 2014 21:51:37 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Mikko Perttunen <mperttunen@nvidia.com>, swarren@wwwdotorg.org,
        tj@kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        linux-ide@vger.kernel.org
Subject: Re: [PATCH v4 1/8] of: Add NVIDIA Tegra SATA controller binding
Message-ID: <20140716195136.GB5212@mithrandir>
References: <1405500863-19696-2-git-send-email-mperttunen@nvidia.com>
 <1405510814-31928-1-git-send-email-mperttunen@nvidia.com>
 <53C666E5.6030009@redhat.com>
 <20140716131306.GB23384@ulmo>
 <53C6908A.2050200@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0eh6TmSyL6TZE2Uz"
Content-Disposition: inline
In-Reply-To: <53C6908A.2050200@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0eh6TmSyL6TZE2Uz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 16, 2014 at 04:47:38PM +0200, Hans de Goede wrote:
> Hi,
>=20
> On 07/16/2014 03:13 PM, Thierry Reding wrote:
> > On Wed, Jul 16, 2014 at 01:49:57PM +0200, Hans de Goede wrote:
> >> Hi,
> >>
> >> On 07/16/2014 01:40 PM, Mikko Perttunen wrote:
> >>> This patch adds device tree binding documentation for the SATA
> >>> controller found on NVIDIA Tegra SoCs.
> >>>
> >>> Signed-off-by: Mikko Perttunen <mperttunen@nvidia.com>
> >>> ---
> >>> v4: clarify mandatory clock order
> >>
> >> Thanks this and the new v4 of "ata: Add support for the Tegra124 SATA =
controller"
> >> both look good to me. So these 2 + v3 for the rest of the series are:
> >>
> >> Acked-by: Hans de Goede <hdegoede@redhat.com>
> >=20
> > Like I said in my reply to PATCH v3 7/8, I think this mandatory clock
> > order is a mistake.
>=20
> We've plenty of other dt bindings where things need to be specified in
> a certain order, e.g. registers. So I don't really see what the problem
> is here.

Like I said, the clock-names exists so that drivers can request a clock
by name. Therefore the order in which they are listed doesn't matter.
The only thing that matters is that the entries in clocks and
clock-names match up.

With the libahci_platform code we completely annul that convention.

Thierry

--0eh6TmSyL6TZE2Uz
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTxtfIAAoJEN0jrNd/PrOhF1kP/Rzi45dJZvTP1NBQPs6mF0V5
3hWJKPi+Y4Ic8WzB8ioWjn9gcnHE4w/zq9xOZ2iz7T8ZV8fVQOen3NuJ9g8/L8Kz
mgPoUKh6XkKZJdeCp37aQlZcySS03YfNoDmF0sjI/i36wSPLY3d50n3k2pEDYXI0
Tz5B2u3Rqi/eveW2nECt99xJz05RdOzYpHRcjLZEct9tfrMdMDblNY3C6u19F0TQ
fXAsNeufsaZdpAVziA00ApaLDxYuHrXy5NK6wlYcxRN3eKgil3m/tWzGLYEZ4cmD
Dy4QUaAR0WMlpYpOJUripRDqv1deR34SKo0X4QOXakHWppFeNkupqOhzNdeLDRH1
F1Nqa3benhMB0CNa55xNwWN17PT6/nsMubGbWiQXRPEiztN5bOnDLXJWikKY8J3s
J19G/vbRY9HLF5R3HStgXe0wNDPrV+GCUmqg84r3yF1IeG2e1fIAeNA+8rzjEPty
Uc94klZj5Ms43jRoV73tYawzuivtJF8kGYgrEAcO0IYbJDo6UomIROQfAAI3s0q7
pLAeW5R8s0kcZw9rJv+8uIOtS+xFCRlO+P2Ew1gUG1yp+w5dlD2DmI2N9CdwbWE5
UvfRQCfqSYlICZIRnfMlZGCAP/tIkbDeEhqseIofX+cONTPHl0cR2ov+agPI0Cr2
HM645M54rwwz56Bt6UAW
=ud7N
-----END PGP SIGNATURE-----

--0eh6TmSyL6TZE2Uz--
