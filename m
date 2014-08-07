Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932204AbaHGLT0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 07:19:26 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:49811 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753416AbaHGLTZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 07:19:25 -0400
Date: Thu, 7 Aug 2014 13:19:19 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Alan Cox <alan@linux.intel.com>,
        Chew Chiau Ee <chiau.ee.chew@intel.com>, linux-pwm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pwm: lpss: remove dependency on clk framework
Message-ID: <20140807111917.GB31751@ulmo.nvidia.com>
References: <1399624521-26175-1-git-send-email-heikki.krogerus@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="E39vaYmALEf/7YXx"
Content-Disposition: inline
In-Reply-To: <1399624521-26175-1-git-send-email-heikki.krogerus@linux.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--E39vaYmALEf/7YXx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 09, 2014 at 11:35:21AM +0300, Heikki Krogerus wrote:
> Unlike other Intel LPSS devices, the PWM does not have the
> clock dividers or the gate. All we get from the clock is the
> rate. Since PCI case uses the driver data to get the rate,
> we can drop the clk and use the same data also in case of
> ACPI. The frequency is the same.
>=20
> Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
> ---
>  drivers/pwm/pwm-lpss.c | 32 ++++++++++----------------------
>  1 file changed, 10 insertions(+), 22 deletions(-)

Sorry for the long delay. Applied now.

Thierry

--E39vaYmALEf/7YXx
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT42C1AAoJEN0jrNd/PrOhicUP/1VEBEGxfkpfuJgt4a9XCyyI
oWZ1bdZuRsk59BosAE8jAhYis8d2ZXXIvSC3tdJ0heHHPukby1ycnrno87XCliAM
Ja18w5Hp3qyBFlMU7oGaFJ69votxsaG4WL1AkUmpRNUaRivVJn4tw5pPyPBCcYsf
3xQowF6QOkO6Vj7IXOX7IlQvxALUk4Paagj1OeRTTHp62YVE7+Cbd/ojR95wO/n7
RtT5SV0OycxKX837j/5/qA96rWYsdV6sPXadkS3uIfrbm93+A3D/vXYBtbBzKm9q
668JDCCzaA49C/mpIwR8pNQ236dV3KLwLm4FVnvNlFLhpj5CHYPd6bXgzUtbPcqS
GHdRKIkJMWphDrf7R5lObL24oVVpgbxppiXKuxnPqCNuu/ZeR+xo/CM1Fi/86w8a
GG/FNKh6S+Pogsje6KTjnxQFivd1BN+nTvIGwJqMIfJoqneebKzrTgGHuaHEbxmT
eaJ0OkOr+voP7xxEyx/8ZQWEzifAZoRW9e3Ma+TyUO1OJACoYaG61kw1sVM63Jlc
UONv9aumHL+sHDPstfG70Iq/8hvQTx7v+Ka+YVfnRZgdzA9k+65Xr7MsFCz82eHd
ZbsbnvHDnEMQwdzYJvFiqXDLOzZx0a92g/78PN9KYCqgB15k3y3q9d/DkVjXSxyd
Pup6DU2sy+AokzKzE5AH
=LI7F
-----END PGP SIGNATURE-----

--E39vaYmALEf/7YXx--
