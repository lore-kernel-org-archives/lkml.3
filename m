Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760374AbaJaNv0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 09:51:26 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:56901 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759964AbaJaNvY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 09:51:24 -0400
Date: Fri, 31 Oct 2014 08:48:31 -0500
From: Felipe Balbi <balbi@ti.com>
To: Kever Yang <kever.yang@rock-chips.com>
CC: <dinguyen@opensource.altera.com>, <paulz@synopsys.com>, <balbi@ti.com>,
        <dinh.linux@gmail.com>, <swarren@wwwdotorg.org>,
        <b.zolnierkie@samsung.com>, <matthijs@stdin.nl>,
        <r.baldyga@samsung.com>, <jg1.han@samsung.com>,
        <sachin.kamat@linaro.org>, <ben-linux@fluff.org>,
        <dianders@chromium.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv6 1/8] usb: dwc2: Update the gadget driver to use common
 dwc2_hsotg structure
Message-ID: <20141031134831.GF1273@saruman>
Reply-To: <balbi@ti.com>
References: <1414538749-14735-1-git-send-email-dinguyen@opensource.altera.com>
 <1414538749-14735-2-git-send-email-dinguyen@opensource.altera.com>
 <5452F834.90303@rock-chips.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="uTRFFR9qmiCqR05s"
Content-Disposition: inline
In-Reply-To: <5452F834.90303@rock-chips.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--uTRFFR9qmiCqR05s
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 31, 2014 at 10:47:16AM +0800, Kever Yang wrote:
> Hi Dinh
> On 10/29/2014 07:25 AM, dinguyen@opensource.altera.com wrote:
> >From: Dinh Nguyen <dinguyen@opensource.altera.com>
> >
> >Adds the gadget data structure and appropriate data structure pointers
> >to the common dwc2_hsotg data structure. To keep the driver data
> >dereference code looking clean, the gadget variable declares are only av=
ailable
> >for peripheral and dual-role mode. This is needed so that the dwc2_hsotg=
 data
> >structure can be used by the hcd and gadget drivers.
> >
> >Updates gadget.c to use the dwc2_hsotg data structure and gadget pointers
> >that have been moved into the common dwc2_hsotg structure.
> Are we still need so much s3c prefix? Can we replace all the s3c into dwc=
2?

separate patch, one which you can send if it bothers you so much.

--=20
balbi

--uTRFFR9qmiCqR05s
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUU5MvAAoJEIaOsuA1yqRE6hsP/jlPh1a27VEQJODTM6E3ocFL
pC3nA/8IVxwihcy5Ons6EpNzFXSvykxs2jx0hTTBRp3Oc9WzhkTnQ7z8cz1fNk1A
TtkD+hT/lXwusUail4mpRIKkk3X5s2MUbWzeiZ2oVkh54bJsgncPkAg8jj1bpxN9
incPfRFAf64MCYwCjSPMA00cH5/7DlAJEGVqiGyxwazFXRww8uzlT2HwWa4lVsPw
C6WtuzKw/0h4pYppKW2gXtxX4nCAAGOQakpKk1LBtsY9q/Rr9J7Aja5FSiTtF6ad
HES4KwGMWejoeBJMlBDavxeZ9Ry5OUFkFIjlrOPGmJOw9HMmT40P2hcpVTUbXNDo
lGNcj96gSzxc087isY/QzCuBqHdEfLEd1FQF/xiLNeVvhmROoJ/r7if2TFT2P4ui
9QW3MiqUTtxx58QF6a5HE5ulKodKipJe/L9RYFFEdD0iHk9QHdN4jKiMd3XR3n3M
ba8/zEvnm3tsPGL8Ln+mSP0UX0iIGMp/VJbZNubELUcxP11rX2KnB//5lxTQaoFY
kn5r+I7A/YDE18TylGYQYQnE+ibLqiWnjulsVDZuYYac/PLlfWpNW1g56OOOtw9I
0kKJ5/w80vQxvCoMwRcS4Iu+IC+HgXmNJaZFwbZkifIwti5PdJYNdckTI05Pem9F
lSXOovSPW8HUBopuEhzA
=3+DZ
-----END PGP SIGNATURE-----

--uTRFFR9qmiCqR05s--
