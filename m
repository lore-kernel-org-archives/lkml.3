Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754556AbaJ1Sv2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 14:51:28 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:39631 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752016AbaJ1Sv1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 14:51:27 -0400
Date: Tue, 28 Oct 2014 13:50:59 -0500
From: Felipe Balbi <balbi@ti.com>
To: Paul Zimmerman <Paul.Zimmerman@synopsys.com>
CC: Huang Rui <ray.huang@amd.com>, Felipe Balbi <balbi@ti.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Jason Chang <jason.chang@amd.com>, Vincent Wan <vincent.wan@amd.com>,
        Tony Li <tony.li@amd.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 01/19] usb: dwc3: enable hibernation if to be supported
Message-ID: <20141028185059.GE25735@saruman>
Reply-To: <balbi@ti.com>
References: <1414497280-3126-1-git-send-email-ray.huang@amd.com>
 <1414497280-3126-2-git-send-email-ray.huang@amd.com>
 <A2CA0424C0A6F04399FB9E1CD98E0304844E68B7@US01WEMBX2.internal.synopsys.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BZaMRJmqxGScZ8Mx"
Content-Disposition: inline
In-Reply-To: <A2CA0424C0A6F04399FB9E1CD98E0304844E68B7@US01WEMBX2.internal.synopsys.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--BZaMRJmqxGScZ8Mx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 28, 2014 at 06:47:08PM +0000, Paul Zimmerman wrote:
> > From: Huang Rui [mailto:ray.huang@amd.com]
> > Sent: Tuesday, October 28, 2014 4:54 AM
> >=20
> > It enables hibernation if the function is set in coreConsultant.
> >=20
> > Suggested-by: Felipe Balbi <balbi@ti.com>
> > Signed-off-by: Huang Rui <ray.huang@amd.com>
> > ---
> >  drivers/usb/dwc3/core.c | 1 +
> >  1 file changed, 1 insertion(+)
> >=20
> > diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
> > index fa396fc..bf77509 100644
> > --- a/drivers/usb/dwc3/core.c
> > +++ b/drivers/usb/dwc3/core.c
> > @@ -449,6 +449,7 @@ static int dwc3_core_init(struct dwc3 *dwc)
> >  	case DWC3_GHWPARAMS1_EN_PWROPT_HIB:
> >  		/* enable hibernation here */
> >  		dwc->nr_scratch =3D DWC3_GHWPARAMS4_HIBER_SCRATCHBUFS(hwparams4);
> > +		reg |=3D DWC3_GCTL_GBLHIBERNATIONEN;
> >  		break;
> >  	default:
> >  		dev_dbg(dwc->dev, "No power optimization available\n");
>=20
> What effect does this have when the controller is in device mode? I
> expect it will start generating DWC3_DEVICE_EVENT_HIBER_REQ interrupt
> events when this register bit is set. So the dev_WARN_ONCE in
> dwc3_gadget_interrupt() will start firing, I think.

Ok, so this *has* to wait for proper hibernation support ?

--=20
balbi

--BZaMRJmqxGScZ8Mx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUT+WTAAoJEIaOsuA1yqREKKsP/iGl2AqFXQNlRSEMWUApj2Ld
Y1R2Ev05BctX0IraFyI+KsVGJlXOFX8zvkSvYACDiD+Y+fGwAENS+qgMAIYOCx9z
dcdkB8/aMPWFQ1LT/Llxz8hcwyGFGi20NRPWuysXzu9j0KKMmo5KM7LZFWS/UdCo
B0qusCvGeGX8yHUj6id435NVImHk/ETfAwIHAZyAOWRINhpbQ0VkkOPOKATTX/Vn
c96KLu1iCMBGASqeg65jpXdAYqi4ZGOD/6kC23nDhcZDasPQ1dmQISa6PVRsATtT
dDDWthGVgaAoW0vyJZrKVnJ520b7o7D01sl5Mz8Z76y/Wdcy6NYslE2SSVmaDUcg
CpuE6hZrc0Ac2IGoTguPm2vv8RdkXPWriWDjQLKzCDMU1tQvkBzr7cK/D/hyRdI3
Q3qP1godBJLXVK4ThCzViaZEx/enRifY8L/Ym4OC7yfhhAMY/C8dtaif4ybPgOXh
KyMqx6rSVNPCCRm3Nl55fsFkKCp9+Znz48sIMp80QysROOn3W/uAoGJ1aWQd38Km
KwIi+/RNff3PHvvffbkt//XdoyarLn0SkgVmkFrmhvhF4tooh0w/jR9ox2gOKODq
j+px70i1RfspUXSSycRRG0vzpScGs8Abt7S2iIgSohUCrMhnAjXuudzCE46+i4fT
R51tPuSaJVrb3aa8g5sB
=1Fb2
-----END PGP SIGNATURE-----

--BZaMRJmqxGScZ8Mx--
