Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756375Ab3EJAP4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 20:15:56 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:53074 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755018Ab3EJAPz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 20:15:55 -0400
Date: Fri, 10 May 2013 10:15:48 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Helge Deller <deller@gmx.de>
Cc: Linux Kernel Development <linux-kernel@vger.kernel.org>,
        linux-parisc@vger.kernel.org,
        James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [GIT PULL] parisc updates for v3.10
Message-Id: <20130510101548.d0a86e3587b6625c00dab7a5@canb.auug.org.au>
In-Reply-To: <518C0788.8060200@gmx.de>
References: <20130507221102.GA5338@p100.box>
	<20130508113704.5ac23906e0e513b4a76d5b55@canb.auug.org.au>
	<518C0788.8060200@gmx.de>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.17; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__10_May_2013_10_15_48_+1000_OTTyeGl_Nk04ggtG"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__10_May_2013_10_15_48_+1000_OTTyeGl_Nk04ggtG
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Helge,

On Thu, 09 May 2013 22:31:04 +0200 Helge Deller <deller@gmx.de> wrote:
>
> On 05/08/2013 03:37 AM, Stephen Rothwell wrote:
> > On Wed, 8 May 2013 00:11:02 +0200 Helge Deller <deller@gmx.de> wrote:
> >>
> >> please pull the parisc architecture updates for v3.10 from:
> >>
> >>   git://git.kernel.org/pub/scm/linux/kernel/git/deller/parisc-linux.gi=
t parisc-for-3.10
> >=20
> > Does this mean that the parisc tree I have in linux-next
> > (git://git.kernel.org/pub/scm/linux/kernel/git/jejb/parisc-2.6.git#for-=
next)
> > is defunct?
>=20
> Not sure. It will be either James or me who will send pull requests...
> Of course we will agree who of us will do that and from which tree.
>=20
> So, would it hurt if you add a second parisc tree for linux-next?
> I've just created a "for-next" branch in my git repository:=20
> git://git.kernel.org/pub/scm/linux/kernel/git/deller/parisc-linux.git#for=
-next

I have no problem having both trees in linux-next (as long as you don't
tread on each other's toes and cause merge problem too often :-)).

I have added your tree from today (noting that it is empty).  I have set
you and the parisc mailing list as contacts.

Thanks for adding your subsystem tree as a participant of linux-next.  As
you may know, this is not a judgment of your code.  The purpose of
linux-next is for integration testing and to lower the impact of
conflicts between subsystems in the next merge window.=20

You will need to ensure that the patches/commits in your tree/series have
been:
     * submitted under GPL v2 (or later) and include the Contributor's
	Signed-off-by,
     * posted to the relevant mailing list,
     * reviewed by you (or another maintainer of your subsystem tree),
     * successfully unit tested, and=20
     * destined for the current or next Linux merge window.

Basically, this should be just what you would send to Linus (or ask him
to fetch).  It is allowed to be rebased if you deem it necessary.

--=20
Cheers,
Stephen Rothwell=20
sfr@canb.auug.org.au

Legal Stuff:
By participating in linux-next, your subsystem tree contributions are
public and will be included in the linux-next trees.  You may be sent
e-mail messages indicating errors or other issues when the
patches/commits from your subsystem tree are merged and tested in
linux-next.  These messages may also be cross-posted to the linux-next
mailing list, the linux-kernel mailing list, etc.  The linux-next tree
project and IBM (my employer) make no warranties regarding the linux-next
project, the testing procedures, the results, the e-mails, etc.  If you
don't agree to these ground rules, let me know and I'll remove your tree
from participation in linux-next.

--Signature=_Fri__10_May_2013_10_15_48_+1000_OTTyeGl_Nk04ggtG
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRjDw0AAoJEECxmPOUX5FE7GYQAJ9uhRtL/H2p9LanhevjS9jU
dx7UIq3fAeBcpOw/YI0ydnkiIzEaatCAcBFfRH1nZY6Pq8kaNr6FohT+wpqVDK4D
Yfa0DriDgjhGqZ+qfxZ9kBMeQMeSdE0FlpzsPpaLsPDYLLfJ1h3Sa+TWlnDV2j3n
YlXAN+AgZIzPU+3Dqy7s5JwRS4K80NqFl0ZnD3Mj4E0rwmIpPM+d703fnjYLzcqY
3XRepwp+h0FzS4++JALr1NC1p+ZW66oE0LatjICIUIGA9ghaWJQz5Dw0GjQJczV7
RpWzAEUCgPEVKXMEpQXeZZPS18Uyr1GThyUSv5AofcpYmyKWBqR2Lm74xtbSh1ms
YNo8yd+locCvI4J89HAc8BucFreMlWfQFVuwdxs54x5mSsMjLtmBpmSV1b0ILxkN
bXq48gauc+xQupTC3a7QRNPxzUJb55OfUsM6h6Pr4tBTLKD2kSAd9tkXiA84XhZL
WIR+xq0S6JmMJ6cEEWzG7a1Al9TV+mA4KeZsyBzT2j5BlmMI0cLeFgIOO159JFtW
SAb5hU3LF1Sp77fhVa2jos40zAICGRsTwtry/FAYJcBAzy4nLfyFjjtEMurEA2E/
18V/SmBdspBHvNHD5oNvEBeRqi/3eCZ5tDkTFUp74V4HFu4NlFIAsRgWmeJL/KaN
FUr+P5qDHMq4O85FPBgc
=4/iM
-----END PGP SIGNATURE-----

--Signature=_Fri__10_May_2013_10_15_48_+1000_OTTyeGl_Nk04ggtG--
