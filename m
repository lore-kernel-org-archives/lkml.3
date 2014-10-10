Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754636AbaJJN6c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 09:58:32 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:49549 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753670AbaJJN62 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 09:58:28 -0400
Date: Fri, 10 Oct 2014 08:57:43 -0500
From: Felipe Balbi <balbi@ti.com>
To: Felipe Balbi <balbi@ti.com>
CC: Rabin Vincent <rabin@rab.in>, Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sasha.levin@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>, <josh@joshtriplett.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Rik van Riel <riel@redhat.com>
Subject: Re: RCU bug with v3.17-rc3 ?
Message-ID: <20141010135743.GB31348@saruman>
Reply-To: <balbi@ti.com>
References: <20140904200403.GL13421@saruman.home>
 <20140905213216.GD5001@linux.vnet.ibm.com>
 <20141008171322.GH22688@saruman>
 <20141008175707.GI22688@saruman>
 <20141008212938.GP22688@saruman>
 <20141009160138.GA2396@cmpxchg.org>
 <20141009162656.GE16002@saruman>
 <20141009204101.GA25955@debian>
 <20141009204637.GE25729@saruman>
 <20141009210715.GH25729@saruman>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FkmkrVfFsRoUs1wW"
Content-Disposition: inline
In-Reply-To: <20141009210715.GH25729@saruman>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--FkmkrVfFsRoUs1wW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 09, 2014 at 04:07:15PM -0500, Felipe Balbi wrote:
> Hi,
>=20
> On Thu, Oct 09, 2014 at 03:46:37PM -0500, Felipe Balbi wrote:
> > On Thu, Oct 09, 2014 at 10:41:01PM +0200, Rabin Vincent wrote:
> > > On Thu, Oct 09, 2014 at 11:26:56AM -0500, Felipe Balbi wrote:
> > > > alright, it's pretty deterministic however. Always on the same test=
, no
> > > > matter which USB controller, no matter if backing store is RAM or M=
MC.
> > > >=20
> > > > Those two undefined instructions on the disassembly caught my atten=
tion,
> > > > perhaps I'm facing a GCC bug ?
> > >=20
> > > The undefined instructions are just ARM's BUG() implementation.
> > >=20
> > > But did you see the question I asked you yesterday in your other thre=
ad?
> > > http://www.spinics.net/lists/arm-kernel/msg368634.html
> >=20
> > hmm, completely missed that, sorry. I'm using 4.8.2, will try something
> > else.
>=20
> seems to be working fine now, thanks. I'll leave test running overnight
> just in case.

yup, ran over night without any problems.

--=20
balbi

--FkmkrVfFsRoUs1wW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUN+XXAAoJEIaOsuA1yqRE8nUP/1WMUbeYR11CKMMcrmk8gYlc
PVwnY756J3cOkcNdOvZT2aS2kiGlvjg1ex42xPq1pvLQ38AIIvdwHRjuaNvrMTmf
+iLmJJxsVuTVkF7k7PkJpB9PVkaFhV73EygGiRK2Lu9LTul3ad0QdpOojGgPe53/
pY+pESPp4PHHqBUZeRLTfv8CubKq/SVkzfDMbM7kuWXC1awRMvehVapIJYg759ri
O4GBFools8jCho74YBT87oNIcMV+kc1d4826EMJwqJjB9zvFTsRaIDqWiZe9eWxF
F/LcLkgAdFDBrBP5hY8lpBAWG7X4oyxcq6AHfchDD5kfPY7gQZlnyQ0g8ZoO9gz9
AzvefzoaLD32QdWACoX8zIgcjPLn3MyHM/8ByJT0edksLmzeE3lFawyOhbIipUBw
ob8G1r2veElp81XTOowO6+1Q0OQtNybCodTqzRoAShF6Wsvf/gdpoH+SKSuWr8id
EFRw1Og5w5dJqs18ViF5q+dVWrepydHt5C7CJS+I14qgtxKra7AWlxxyySgXD131
Uxd9ktFCG/lpMJUB3y9aVkEHx68G2N/S46ZMe3zjkrWCka+CryswFvp9U6f0FwHE
0vveoL5JFCOSisHg5mUVwY0+7msddL0I8BT7OaAGUlglrOTHmmnVCc1Ur7L6mC8j
Kd2qBCk2YDvb5eskYkXD
=3efB
-----END PGP SIGNATURE-----

--FkmkrVfFsRoUs1wW--
