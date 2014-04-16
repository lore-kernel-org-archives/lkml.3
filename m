Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751104AbaDPCAT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 22:00:19 -0400
Received: from mga09.intel.com ([134.134.136.24]:31200 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750918AbaDPCAR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 22:00:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,868,1389772800"; 
   d="asc'?scan'208";a="521724082"
Date: Tue, 15 Apr 2014 21:34:59 -0400
From: "Chen, Gong" <gong.chen@linux.intel.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: hpa@zytor.com, tony.luck@intel.com, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, linux-tip-commits@vger.kernel.org
Subject: Re: [PATCH] x86, MCE: Clean get_cpu_xxx with this_cpu_xxx
Message-ID: <20140416013459.GA4399@gchen.bj.intel.com>
References: <1397546035-6384-1-git-send-email-gong.chen@linux.intel.com>
 <20140415090347.GA31409@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bg08WKrSYDhXBjb5"
Content-Disposition: inline
In-Reply-To: <20140415090347.GA31409@gmail.com>
X-PGP-Key-ID: A43922C7
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--bg08WKrSYDhXBjb5
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 15, 2014 at 11:03:48AM +0200, Ingo Molnar wrote:
> Date: Tue, 15 Apr 2014 11:03:48 +0200
> From: Ingo Molnar <mingo@kernel.org>
> To: "Chen, Gong" <gong.chen@linux.intel.com>
> Cc: hpa@zytor.com, tony.luck@intel.com, tglx@linutronix.de,
>  linux-kernel@vger.kernel.org, linux-tip-commits@vger.kernel.org
> Subject: Re: [PATCH] x86, MCE: Clean get_cpu_xxx with this_cpu_xxx
> User-Agent: Mutt/1.5.21 (2010-09-15)
>=20
>=20
> * Chen, Gong <gong.chen@linux.intel.com> wrote:
>=20
> > This is a cleanup patch suggested by Peter. Use new
> > this_cpu_xxx to improve operation speed. Meanwhile,
> > it fixes an issue introduced in commit 27f6c573e0. I
> > forget to execute put_cpu_var operation after get_cpu_var.
>=20
> What 'issue'? Is it a bug? If yes, what are the symptoms to the user?
I forget put_cpu_var after get_cpu_var.

>=20
> Also, fixes must be separate from cleanups.
OK, I will.

--bg08WKrSYDhXBjb5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTTd5DAAoJEI01n1+kOSLHrdwQALbf4P7rVq3zKRYS8OIgV9Y5
hiKJas5+U5K8kRWSDQFOp3u+PrRidyBH71YfgFtu/wRBckvc02UNYhRKO7Ni/z3g
REWaDA645lTE5CaRNKi9Qe7om7Icp+aBrAT264ZyVCTuV+JdXeXDU6sn/2WFSUx/
rM0Tc5a9UDuFCwpxO/G1yqkX2V2wTzaEFSPqIyoWgJJUkWQDfhszVpZOXFibZwj1
cohGsdwTXfnKhB0fpuYD/EWRw+WUB3R/kVTr33ypk5TOgYv8yXjNCkJsNKr5YwqD
fYJdw5YmNPy4aXbcBfH4V/e8Z2GAcu7oOU/jymncGdRfzOZ+MO8fdeZ7nRYbWt/x
cp2LloaOs/8NO35F7pX1flDqpk0vRd7AU5Qg7tqK8XdvlFdY8EfamJOWR6vOB4kl
wCN3RBQnaQwpxnhhK2E/5aTGLKOQKw/cE+KqyueCI8uq86coWFbCDjQfLCqqZ96e
c/a0uI/IdxNxNAk87K6PupQ3NbHDCrYLrK5oew9Tq2fDCaXCKT+yvCjmJvlo86NM
YeTHZc3HnuxEtCawhYdBPKpvrzj1oZketn9Dox6yJzH8gFvhXhAibMVUJRJ+xeJE
lMdtftKrLBtuaP8yzwlvVTtb18CJPifl85I6V2TDWq1BfYMBsxl8oqulMV/wYh8I
fd2ruImh6DcwcfBwjaQJ
=3kW4
-----END PGP SIGNATURE-----

--bg08WKrSYDhXBjb5--
