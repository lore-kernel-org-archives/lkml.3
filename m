Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754515AbaCKCG5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 22:06:57 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55648 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753866AbaCKCGz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 22:06:55 -0400
Message-ID: <1394503606.23624.27.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH RT 2/5] a few open coded completions
From: Ben Hutchings <ben@decadent.org.uk>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>, Corey Minyard <cminyard@mvista.com>
Date: Tue, 11 Mar 2014 02:06:46 +0000
In-Reply-To: <20140310141449.6b99c7eb@gandalf.local.home>
References: <20131211003732.351606520@goodmis.org>
	 <20131211003801.836995968@goodmis.org>
	 <20131211144946.27d82a78@gandalf.local.home>
	 <1394324841.2861.56.camel@deadeye.wl.decadent.org.uk>
	 <20140310102928.7b2a2cfa@gandalf.local.home>
	 <1394473962.23624.3.camel@deadeye.wl.decadent.org.uk>
	 <20140310141449.6b99c7eb@gandalf.local.home>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-qAxO4yMzbQGQC0nOiSyi"
X-Mailer: Evolution 3.8.5-2+b3 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.245
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-qAxO4yMzbQGQC0nOiSyi
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2014-03-10 at 14:14 -0400, Steven Rostedt wrote:
> On Mon, 10 Mar 2014 17:52:42 +0000
> Ben Hutchings <ben@decadent.org.uk> wrote:
>=20
> > On Mon, 2014-03-10 at 10:29 -0400, Steven Rostedt wrote:
> > > On Sun, 09 Mar 2014 00:27:21 +0000
> > > Ben Hutchings <ben@decadent.org.uk> wrote:
> > >=20
> > > > On Wed, 2013-12-11 at 14:49 -0500, Steven Rostedt wrote:
> > > > > Here's the new patch:
> > > >=20
> > > > Doesn't add #includes and doesn't change any types, so of course it
> > > > doesn't compile.  WTF?
> > > >=20
> > >=20
> > > Hi Ben,
> > >=20
> > > This is an old thread. Which kernel did you apply it to. Before I sen=
d
> > > any patch set out, I run a small test (heavy stress test, and also
> > > compile several different configs). This patch was against 3.10-rt, a=
nd
> > > may have already had the includes needed. I know the original patch
> > > compiled, but I may not have tested the second patch.
> > >=20
> > > Do you need this patch? Or did I miss something for 3.2-rt?
> >=20
> > You applied it to 3.2-rt:
> >=20
> > commit 916c8d2de3c4759f57426fa3cfee63b491e88939
> > Author: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> > Date:   Mon Oct 28 11:50:06 2013 +0100
> >=20
> >     swait: Add a few more users
> >=20
> > and 3.4-rt, 3.8-rt, 3.10-rt.  So far as I can see, it is broken on all
> > of those branches, though I only actually tried building 3.2-rt.
> >=20
>=20
> Can you send me your config. I may just not be hitting it. I've booted
> and ran all these kernels I've posted.
>=20
> I don't run a make allmodconfig as I do on my upstream work. Maybe I'll
> have to add that to the mix.

You can enable all the affected code with:

CONFIG_HERMES=3Dm
CONFIG_ORINOCO_USB=3Dm
CONFIG_USB_GADGET=3Dm
CONFIG_USB_FUNCTIONFS=3Dm
CONFIG_USB_GADGETFS=3Dm

Ben.

--=20
Ben Hutchings
Any sufficiently advanced bug is indistinguishable from a feature.

--=-qAxO4yMzbQGQC0nOiSyi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUAUx5vtue/yOyVhhEJAQrz4g//cd44WW8LACz+61YRSQtDH8ZE7tUNppNz
rWJlt5c0I7lKu8bMN9AtJUsFvaVDsXQZcIrQ7DQGMkfksPB2mRnoIUqqdZcedx29
glUneiwTyT3dd8HUxRt2xHz18qtmseGpAgAyaBcET9Pv9Bng8+ZlTVPVB2mZKJDt
/r69rhPBzdmFAggpR+suUE+Oa/+1noAecl3+tPwWVBujNnqlz1r3twNuiJc46OTS
CtezTMMlfjUw6o+lNX8bmj4TMsWvzmuqWymqfLunW8u9AIB8kCdeZIqJv5xc2AKc
8q4mrebzLcmz7PUkaJisNpBR+rPQcKbnhSyArhpwcoJKBuV8N6Z+3AIWpBkvRl/Z
5Ir3HgQDKph9gNnB2vYUNxD5aONHxFOUMqr4X1Fv0/r5CwFQJnSl4t2Qzn4buwct
v+vE9/qkE43J/cLqQUg+52kCA+nHcBlNsxYSkKnxg/9X0MiAlXDtQFCmmwSgWDSm
L45imRGZzFDtaJefqF1gn4lTs6xy/Mou9FCzk9tjGRSyK6foFGYmYD3yYwCZ6RRG
pTw3C//1cIvMoj+OwyJFm3GQFf9/i8WMLP3aj0s1e1hFc3hYRb+jMIcgmvENtn0o
gXC1Ub38VvF8J2apK0FJud+SElxu7vhxpMyYi8AAqW/Fuce+xAlh4auc5Rc//1x+
lUMsGEKf8Hc=
=Oizc
-----END PGP SIGNATURE-----

--=-qAxO4yMzbQGQC0nOiSyi--
