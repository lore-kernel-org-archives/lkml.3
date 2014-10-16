Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751666AbaJPO6F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 10:58:05 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:52915 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751273AbaJPO6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 10:58:04 -0400
Date: Thu, 16 Oct 2014 09:57:52 -0500
From: Felipe Balbi <balbi@ti.com>
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
CC: Felipe Balbi <balbi@ti.com>, Paul Zimmerman <paulz@synopsys.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 2/2] usb: dwc2: gadget: sparse warning of context
 imbalance
Message-ID: <20141016145752.GA5868@saruman>
Reply-To: <balbi@ti.com>
References: <1413445270-27672-1-git-send-email-sudipm.mukherjee@gmail.com>
 <1413445270-27672-2-git-send-email-sudipm.mukherjee@gmail.com>
 <20141016132155.GC3480@saruman>
 <20141016145208.GA8358@sudip-PC>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qDbXVdCdHGoSgWSk"
Content-Disposition: inline
In-Reply-To: <20141016145208.GA8358@sudip-PC>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--qDbXVdCdHGoSgWSk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 16, 2014 at 08:22:08PM +0530, Sudip Mukherjee wrote:
> On Thu, Oct 16, 2014 at 08:21:55AM -0500, Felipe Balbi wrote:
> > HI,
> >=20
> > On Thu, Oct 16, 2014 at 01:11:10PM +0530, Sudip Mukherjee wrote:
> > > sparse was giving the following warning:
> > >         warning: context imbalance in 's3c_hsotg_ep_enable'
> > > 	        - different lock contexts for basic block
> > >=20
> > > we were returning ENOMEM while still holding the spinlock.
> > > The sparse warning was fixed by releasing the spinlock before return.
> > >=20
> > > This patch depends on the previous patch of the series.
> > >=20
> > > Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
> >=20
> > this should be patch one so it can be backported to stable kernels.
> >=20
> my v1 patch fixed only this , while reviewing that one Paul Zimmerman
> suggested to rewrite the return statements.
> so this v2 series had the rewrite and the spinlock error fix.
> now if this is to be made the patch one then it will be a duplicate of
> my v1 followed by another patch for return statements.=20
> should i do that ?

Paul has the final word on this driver, if he already asked you to
change, I withdraw my comment ;-)

cheers

--=20
balbi

--qDbXVdCdHGoSgWSk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUP9zwAAoJEIaOsuA1yqREAz0P/2TKwyioiGqRHmQljDI3m/mM
Gpt7GZHoiUef4qqVO5iHK/kY+nr5clbD0kcb+YdoEdh26wVqv7RJ5MCeqIRGIjCV
+6mvcIUjN9ivcbXt3pX4sFT60GuDiUf7d2LrNGNA0RZt045Yzr84sPMP2hKt0RIt
eNZnUwtN6yK+P8aAI2h1KCl/8PO/fOCx60XzvIP8hSsVyNlVpg9jgHhtZ1POubPF
jU/L5C/r2NxtYvmEEY9xJewiCxmUj/ZEyaKaalAXaecBin7oeKGKowMsqUCK+RJV
DZLX/MIlSX0PPOwB7VmwKKsdtQjXaorM+9hNbcFWG1sUkxvfpQkFV8/lEP1qQGpU
si/4hjQ15o+e4nSe60tV2jH7od4No7iTPmbQhJB9J8QpndvPq9C9qbnCLtS9cuk3
zitS1orobziRuvuh03juQG7qnM8nDCgbYMsRH8TbQ4i/nJ+Qtod9lLqUJ6LWvAk4
bcNyAJlrNeJCJ73kcxwDSLkDkaq4yQS/pEyQ83DFtyOD3gago17R2cH13SGI75SG
T0qvLcKTf+/IGgK6QjneKQvpBSbwh04Nc9gKr2SHrIZ1kzwzCj3tb/RCLcyn8cUp
2xWREUI3ygcp5U2MKYYCfH76Y/UmGNLpttvAA8yZmUne3xpowkE3v8doKLQB0WUu
LCLkIuBCp5u42Zd/EbZn
=f8ZI
-----END PGP SIGNATURE-----

--qDbXVdCdHGoSgWSk--
