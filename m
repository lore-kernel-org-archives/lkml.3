Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755938AbaFXRUD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 13:20:03 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:52211 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751598AbaFXRT7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 13:19:59 -0400
Date: Tue, 24 Jun 2014 19:19:43 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Robert Richter <rric@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>
Subject: Re: [RFC v2 2/7] perf: add AUX area to ring buffer for raw data
 streams
Message-ID: <20140624171943.GR3213@twins.programming.kicks-ass.net>
References: <1402501310-31940-1-git-send-email-alexander.shishkin@linux.intel.com>
 <1402501310-31940-3-git-send-email-alexander.shishkin@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4CyH/NlNBqvsUTYP"
Content-Disposition: inline
In-Reply-To: <1402501310-31940-3-git-send-email-alexander.shishkin@linux.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--4CyH/NlNBqvsUTYP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jun 11, 2014 at 06:41:45PM +0300, Alexander Shishkin wrote:
> +	/*
> +	 * Set up pmu-private data structures for an AUX area
> +	 */
> +	void *(*setup_aux)		(int cpu, void **pages,
> +					 int nr_pages, bool overwrite);
> +					/* optional */
> +
> +	/*
> +	 * Free pmu-private AUX data structures
> +	 */
> +	void (*free_aux)		(void *aux); /* optional */

I was hoping you could replace those with a PERF_CAP_AUX or something
and then have one generic allocation routine like you provide in the
subsequent patches.

--4CyH/NlNBqvsUTYP
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTqbMvAAoJEHZH4aRLwOS6Sw8P/j8F4bVdFOAJOSJ/mVHCddBf
XWz73xViCNs932HHLTuM4Durkpd5fxExzw9Qb+jeEh0jAgOBNtjU32ONnlgFSWn3
JFrkdVSKjby1ubUC6E8/FIHUo1BvmLqAL/HKr/JfaGqv2RndF8McXfuAYeiPwcfC
ccCF0eNG9ForoTk0cfvM6XiJJHJfI0q17tPrrL54bD1EeG3CdKn4d2fEAcUuEF9f
SUQF7qRNZQB9FHn1LhOOAZ05Qu3ckCgGuz7uEhqxRNLzWvPIjtRMIt7cc1rmNwbq
7H4nRveDQhn/QW+5BIsFdh5agHKg5wYUdt7+JLsj/d1zyc1FQku9DoD4PIsi2td2
QeNjCNydAdEZ+w6XE6cpWaE2pOI3eC+c6nE81B0aS8mn/ZgL+zYIaHvRbYcyHC0O
Z/3ujt4W7yFHPKDDrEGTgRj5liMpHKB1UfZUTmq7w0cvWQcf0piH24ehQ19Cv4gJ
os+aEddDaYE4IZtRG5sjiVJCGAaMrB0E/XFKgdHGBVaza6Pt3pWvoDX4VKZiYL3a
fqwAb8+W2+kv/r4gsEz+T2jcDcnG5pxmv/44k2vnJMbFGHjbkdViJvRiq6S2G6H0
MqEW67UJObRBgNgMoW0IpYYhcykx6Pk6kKp9UfA84RHYhoCxNYQRW3DSZ65vdW3K
AZ+kdS2DYdqpb8NTHmA4
=ENjU
-----END PGP SIGNATURE-----

--4CyH/NlNBqvsUTYP--
