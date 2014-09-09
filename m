Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756158AbaIIJLt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 05:11:49 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:58819 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755354AbaIIJLs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 05:11:48 -0400
Date: Tue, 9 Sep 2014 11:11:38 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Robert Richter <rric@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        kan.liang@intel.com
Subject: Re: [PATCH v4 19/22] perf: Add infrastructure for using AUX data in
 perf samples
Message-ID: <20140909091138.GB19379@twins.programming.kicks-ass.net>
References: <1408538179-792-1-git-send-email-alexander.shishkin@linux.intel.com>
 <1408538179-792-20-git-send-email-alexander.shishkin@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yBpClG5lv0ksn6ne"
Content-Disposition: inline
In-Reply-To: <1408538179-792-20-git-send-email-alexander.shishkin@linux.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--yBpClG5lv0ksn6ne
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 20, 2014 at 03:36:16PM +0300, Alexander Shishkin wrote:
> AUX data can be used to annotate other perf events by including it in
> sample records when PERF_SAMPLE_AUX flag is set. In this case, a kernel
> counter is created for each such event and trace data is retrieved
> from it and stored in the perf data stream.
>=20
> To this end, new attribute fields are added:
>   * aux_sample_type: specify PMU on which the AUX data generating event
>                      is created;
>   * aux_sample_config: event config (maps to attribute's config field),
>   * aux_sample_size: size of the sample to be written.
>=20
> This kernel counter is configured similarly to its "main" event with
> regards to filtering (exclude_{hv,idle,user,kernel}) and enabled state
> (disabled, enable_on_exec) to make sure that we don't get out of context
> AUX traces.

WHY? Why would we want to do this? This doesn't tell me why I should
want this or even consider it.

Convince me I want to read the patch.

--yBpClG5lv0ksn6ne
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJUDsRKAAoJEHZH4aRLwOS6Wb0QAKmYle8UVzDO/kZvodWhjE0C
c1Bat07TPhlFLjBDoX06qiQGXEYK1Yt1w4Cs6hMQvMBaTSkX98zTEPC1qKO7TZMy
wZfQ+wL+ouY50+uj9og4zHeSf4x65auSQ3Nr521vZxK4zGXqdU/RVRN1YaXqbz86
cCOindCdAB5e7dfLIOzGjOr1zG0dCLUlS4uQ5mR1MR0GxSa2o2xMZwrdkV9uJNlI
Rk8tEdXn1G6WzBJ/wZwKolS+7+ekAN9b3QTuZta3v6qoiO03hrm6SyZDU/8+p/g9
4jlWighndTZYl7HDKuDh45kTk7eZgJ32Pf6P0OnszSaPG8eqpybj7h2M74JUsRM+
JqFmJXfFQjiU6SL8nSksRD1N6I5ub2uvwpQukWOip9j7WQDI59Ub2Ce0d8IvlhHh
ZJBGIYulBBNKh7egiB9Pp7BxIYC9FfPvyvrBw8K8uPH0MmO2STIiZoqv6Hdy54BJ
PLXnClkHzwOYbfT8Ss2R7tdEWLQ5DP63liP/gLghu5yJPFcQEp+yTMMWYa9wmeHu
893VM7wnP8fsasEXbyWjr3hzaXTLo6JfEA9H00SNsgIUh/osxFubI15oQ6/mz5tx
QdejsUf0aKiUsjxk3A7Oy69xt6l+ktI7zHAglngIa7wNkq9cZKPS68fG5O3rSyX+
YXVsTROv1OS26XjXmdzu
=h8g1
-----END PGP SIGNATURE-----

--yBpClG5lv0ksn6ne--
