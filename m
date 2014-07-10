Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753113AbaGJJzb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 05:55:31 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:44473 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751420AbaGJJz3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 05:55:29 -0400
Date: Thu, 10 Jul 2014 11:55:26 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
        linux-kernel@vger.kernel.org, Michal Marek <mmarek@suse.cz>,
        linux-kbuild@vger.kernel.org
Subject: Re: [RFC] dma-buf: Implement test module
Message-ID: <20140710095524.GB21583@ulmo>
References: <1386858989-1487-1-git-send-email-treding@nvidia.com>
 <20131212144210.GA1527@ulmo.nvidia.com>
 <20131213020258.GC13333@kroah.com>
 <20140325161722.GA23842@ulmo>
 <20140325180110.GA3532@ravnborg.org>
 <20140326083247.GA9512@ulmo>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Pd0ReVV5GZGQvF3a"
Content-Disposition: inline
In-Reply-To: <20140326083247.GA9512@ulmo>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Pd0ReVV5GZGQvF3a
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 26, 2014 at 09:32:47AM +0100, Thierry Reding wrote:
> On Tue, Mar 25, 2014 at 07:01:10PM +0100, Sam Ravnborg wrote:
> > >=20
> > > There are two things that don't work too well with this. First this
> > > causes the build to break if the build machine doesn't have the new
> > > public header (include/uapi/linux/dma-buf.h) installed yet. So the on=
ly
> > > way to make this work would be by building the kernel once with SAMPL=
ES
> > > disabled, install the headers and then build again with SAMPLES enabl=
ed.
> > > Which really isn't very nice.
> > >=20
> > > One other option that I've tried is to modify the include path so that
> > > the test program would get the in-tree copy of the public header file,
> > > but that didn't build properly either because the header files aren't
> > > properly sanitized and therefore the compiler complains about it
> > > (include/uapi/linux/types.h).
> > >=20
> > > One other disadvantage of carrying the sample program in the tree is
> > > that there's only infrastructure to build programs natively on the bu=
ild
> > > machine. That's somewhat unfortunate because if you want to run the t=
est
> > > program on a different architecture you have to either compile the
> > > kernel natively on that architecture (which isn't very practical on m=
any
> > > embedded devices) or cross-compile manually.
> > >=20
> > > I think a much nicer solution would be to add infrastructure to cross-
> > > compile these test programs, so that they end up being built for the
> > > same architecture as the kernel image (i.e. using CROSS_COMPILE).
> > >=20
> > > Adding Michal and the linux-kbuild mailing list, perhaps this has been
> > > discussed before, or maybe somebody has a better idea on how to solve
> > > this.
> > I actually looked into this some time ago.
> > May try to dust off the patch.
> > IIRC the kernel provided headers were used for building - not the one i=
nstalled on the machine.
> > And crosscompile were supported.
>=20
> That sounds exactly like what I'd want for this. If you need any help,
> please let me know.

Did you have any time to look into dusting off the patch? If not I'll
gladly take whatever you have and dust it off myself.

Thierry

--Pd0ReVV5GZGQvF3a
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTvmMMAAoJEN0jrNd/PrOhWWYP/jkfcqw8FhB4vzkrHasCVQHZ
W/A7reVGrIH+PqF1IpDwN7RPqAWj3VfVFiyIImID2qLP5V0G5DbCdXgmnOXf/TQp
n7Vj5eqn0t6TyxjviMpaMeUHAb7p7jV0HDh+hk+Qw1tipNNai+1IxR7K48WnL9Gs
Oo6u3cUACj/AImsEa56d/FHK7ehQ0JkgpsAi3CY+6BGiVGbUDtrRQ01wHeAOupSu
9ngpVR+BFOpRBzCPHkgtTuvVBLG7gl9jHZeTZR94szqVBTc2omFdnKJYKww9YNB+
fbSDCq/m2fNgdzDw0BL9uKuNEA7mg5kIegAIYtaAYFp4Ar3YneBLc7Cjij8JYpG3
teZP8IL21CVIqzM54RYJi33Ccdh3yDP0FitkvjyiXhTWMDOqxzLpBdd2IJZcOErT
CddiAJA8sXyRleZu8dFFUE+a0bzw0/hlyJo59uoad3rpfHD57re33dcJdXo5csEM
HhNGATpT6+1Gml/alqcP/0J6T1vawMSGeS0VExCOXbaW2Uqsgg+CpgGEkzRgNDba
IfmoZC+58BKx6i+I8cC3voro8JyRoBNa6o2HjXd4PQphi97J3Sqg3z56QMhdyuW3
kee9GlV+4T9HMyELeGgIbhR0liAFk73SDUQtBq964mdKe0ietbEVvZFRVDGUtyXC
EJCNC81PQjgsOdC9MitX
=JPmc
-----END PGP SIGNATURE-----

--Pd0ReVV5GZGQvF3a--
