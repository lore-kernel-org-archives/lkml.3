Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753238AbaG2JcB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 05:32:01 -0400
Received: from mga01.intel.com ([192.55.52.88]:53421 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753134AbaG2Jb7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 05:31:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,756,1400050800"; 
   d="asc'?scan'208";a="577015703"
Date: Tue, 29 Jul 2014 05:00:16 -0400
From: "Chen, Gong" <gong.chen@linux.intel.com>
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, tglx@linutronix.de,
        paulus@samba.org, benh@kernel.crashing.org, tony.luck@intel.com,
        hpa@zytor.com, jkosina@suse.cz, rafael.j.wysocki@intel.com,
        linux@arm.linux.org.uk, ralf@linux-mips.org, schwidefsky@de.ibm.com,
        davem@davemloft.net, viro@zeniv.linux.org.uk, fweisbec@gmail.com,
        cl@linux.com, akpm@linux-foundation.org, axboe@kernel.dk,
        JBottomley@parallels.com, neilb@suse.de, christoffer.dall@linaro.org,
        rostedt@goodmis.org, rric@kernel.org, gregkh@linuxfoundation.org,
        mhocko@suse.cz, david@fromorbit.com
Subject: Re: [RFC PATCH v1 13/70] x86, x2apic_cluster: _FROZEN Cleanup
Message-ID: <20140729090015.GA29266@gchen.bj.intel.com>
References: <1406080786-3938-1-git-send-email-gong.chen@linux.intel.com>
 <1406080786-3938-14-git-send-email-gong.chen@linux.intel.com>
 <20140723203628.GJ21707@pd.tnic>
 <20140728060455.GB23092@gchen.bj.intel.com>
 <20140729084433.GB11179@pd.tnic>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7AUc2qLy4jB3hD7Z"
Content-Disposition: inline
In-Reply-To: <20140729084433.GB11179@pd.tnic>
X-PGP-Key-ID: A43922C7
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7AUc2qLy4jB3hD7Z
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 29, 2014 at 10:44:33AM +0200, Borislav Petkov wrote:
> >  	switch (action) {
> >  	case CPU_UP_PREPARE:
> >  		if (!zalloc_cpumask_var(&per_cpu(cpus_in_cluster, this_cpu),
> > -					GFP_KERNEL)) {
> > +					GFP_KERNEL))
> >  			err =3D -ENOMEM;
> > -		} else if (!zalloc_cpumask_var(&per_cpu(ipi_mask, this_cpu),
> > -					       GFP_KERNEL)) {
> > +		else if (!zalloc_cpumask_var(&per_cpu(ipi_mask, this_cpu),
> > +					     GFP_KERNEL)) {
> >  			free_cpumask_var(per_cpu(cpus_in_cluster, this_cpu));
> >  			err =3D -ENOMEM;
>=20
> You need to start restraining yourself and doing clean patches. Those
> changes here are unrelated, please drop them.
>=20
> Go and reread Documentation/SubmittingPatches, section 3 in particular.
>=20
Copy that.

> > +	if (test_and_clear_bit(CPU_TASKS_FROZEN, &action) &&
>=20
> What.. why?
>=20
Sorry for that.

--7AUc2qLy4jB3hD7Z
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJT12KfAAoJEI01n1+kOSLHvqIQAIIsXD2ILXPl2cVNOvVjVSlW
0BD+ojvuGQNT91gmGENGAkLzf9wXV3Ep+OI/axtH2yid3dWahumDX/jn90s0GYE1
T6dzS5lWklVmMsBCIpIL2AlbLy5j9rUOxNn3/eB8c74CHIgQopVlWu3teQ0juWT5
fxMcuTCCvy7Y9hzYYnYikEvZaIkLCi55tjncF98ckakdLEHKVHw08EK0yEmFiKjF
UgL8p6XhUIK+EuT2lxDIUiV04z4t5MauF9DhO65xG/NQ465G8sS1KN7IUx2HpgJl
JFXT7xMsxOdLBfkKsRlvs/BjLmwaKdOU0PLcwDVPN3q4epmpEKkmTFh8NBMdDpvb
rLePx8w7KVN9I/X2scWF3rUwsmMGWx7dahSL3OG8kLaa0nYSAreHgFa/80OoAmWt
BvWBHRBpZUTtGvIu8WKSwGkIeRg7J/HLsqYHVWJ2w1djrGO+75mnTt7s7QmzP70T
QUDHYEdTR7wsF+DqaasbPJCIYnQ5ZC7SIH+WuPrPFztqOi9dDWtIR5wL0c6Xlq35
VwLeuQns7KSVVEtlb23LyLEUPMsagjt2DkIeSS4y+qWnxMYNsMWXhfyQTRk+Hx0M
50uurv78SgnQHV0MvbAco5THNnLHvqg5/XqV0vXdJh81P6NGVCRpUxvvUsf3r5cb
EKJjg5wgYdWdhZCdWvxv
=Cf6n
-----END PGP SIGNATURE-----

--7AUc2qLy4jB3hD7Z--
