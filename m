Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756016AbaCLSPh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 14:15:37 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33057 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755039AbaCLSPg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 14:15:36 -0400
Message-ID: <1394648128.23624.32.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH RT 2/5] a few open coded completions
From: Ben Hutchings <ben@decadent.org.uk>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>, Corey Minyard <cminyard@mvista.com>
Date: Wed, 12 Mar 2014 18:15:28 +0000
In-Reply-To: <20140311115420.4904b7ed@gandalf.local.home>
References: <20131211003732.351606520@goodmis.org>
	 <20131211003801.836995968@goodmis.org>
	 <20131211144946.27d82a78@gandalf.local.home>
	 <1394324841.2861.56.camel@deadeye.wl.decadent.org.uk>
	 <20140310102928.7b2a2cfa@gandalf.local.home>
	 <1394473962.23624.3.camel@deadeye.wl.decadent.org.uk>
	 <20140310141449.6b99c7eb@gandalf.local.home>
	 <1394503606.23624.27.camel@deadeye.wl.decadent.org.uk>
	 <20140310225623.0cad071a@gandalf.local.home>
	 <20140311115420.4904b7ed@gandalf.local.home>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-I9qrTkOvawiw6v9VoVqw"
X-Mailer: Evolution 3.8.5-2+b3 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.245
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-I9qrTkOvawiw6v9VoVqw
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2014-03-11 at 11:54 -0400, Steven Rostedt wrote:
> On Mon, 10 Mar 2014 22:56:23 -0400
> Steven Rostedt <rostedt@goodmis.org> wrote:
>=20
>=20
> > Thanks, I ran an allmodconfig, and you're right, the orinoco driver
> > failed to compile on v3.2-rt. I ran allmodconfig on 3.10-rt and it
> > passed fine. Seems that one of the headers there pulls in swait.
> >=20
> > Looking deeper, 3.10-rt has completion as a simple-wait, and
> > completion.h pulls in wait-simple.h, which is why it works there. 3.2
> > does not have completions there. I wonder if I should pull in the patch
> > that converts completions into swaits, and that may fix other locations
> > as well.
>=20
> The swait code for 3.2 can't even handle the changes that were made.
> That is, the patch used swait functions not created in 3.2-rt.
>=20
> I'll just revert those from 3.2-rt and be done with it.
>=20
> Thanks for the report.

OK.  Sorry for the 'WTF'; now I understand that this was a build fix for
the later branches.

Ben.

--=20
Ben Hutchings
Any sufficiently advanced bug is indistinguishable from a feature.

--=-I9qrTkOvawiw6v9VoVqw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUAUyCkQOe/yOyVhhEJAQpdVBAAjJ5mdtXXb3cB6HbCjuBnZe9G3V2BT96z
rchOwwTcdEFPEZzFrrGZjKUD+J0csVBYpakc5NqqU8euiD0hKQsttcUDPALMHl7T
8qLZ3Pno29za2ctiwmuLC51M17m8YbhF935MVqlnTI7c0mU/FDerjT1aMFIt3a/B
q8bppI8uUxfRqII8dKnRdm69BCo1hi4T/3MQBLdX0CQJXNQ/oTjSRriU11cAzc/0
Ga+K2F7oLdsL4SA47hyvLV/zLwMMNxYK5Qv0/0iH8WVmUk6jqKID+GpR1c6NURT6
hPhyP/IZmT/Fx99Jdjuf3zf7x2yVr9htDjQY8ayssoUWkhXrULW9Vr7IxVbq6TRQ
ngiD4DFNo+bldEds1SaNP+6MHZGbgrFyJfEiJjtLtGECfUTgi5LLzA3ecs7KYdKN
BCAe1F8DYLTnVa/PP4MxP6t/6UxWWJ0ITjXpffzYb9BfYU6lVvfqwFladHChfN2v
OeW5PUXGEn0pAheNXVFuh2ABjN/Uj/G5nPCHgyn13vPqTcpX9sSZ+nprr3XTcbsm
i/j9nvg7jWzQoInpJi3K9mW0LgywpO6hfx40AdZlUIRTsA7m1Y8D4fTs8qIsLtzJ
tyC+AKu9ZJfrseqNUFn5ddRrPom8QcuEL7WgtgY6DZUFIa70QNAeL7uADAgmuise
UwrYgZQBKfs=
=ENYl
-----END PGP SIGNATURE-----

--=-I9qrTkOvawiw6v9VoVqw--
