Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933163AbaFCLok (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 07:44:40 -0400
Received: from casper.infradead.org ([85.118.1.10]:41110 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933141AbaFCLoh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 07:44:37 -0400
Date: Tue, 3 Jun 2014 13:44:28 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Morten Rasmussen <morten.rasmussen@arm.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, mingo@kernel.org,
        rjw@rjwysocki.net, vincent.guittot@linaro.org,
        daniel.lezcano@linaro.org, preeti@linux.vnet.ibm.com,
        dietmar.eggemann@arm.com
Subject: Re: [RFC PATCH 06/16] arm: topology: Define TC2 sched energy and
 provide it to scheduler
Message-ID: <20140603114428.GY11096@twins.programming.kicks-ass.net>
References: <1400869003-27769-1-git-send-email-morten.rasmussen@arm.com>
 <1400869003-27769-7-git-send-email-morten.rasmussen@arm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cbwY24+csKcE3jo0"
Content-Disposition: inline
In-Reply-To: <1400869003-27769-7-git-send-email-morten.rasmussen@arm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--cbwY24+csKcE3jo0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, May 23, 2014 at 07:16:33PM +0100, Morten Rasmussen wrote:
> +static struct capacity_state cap_states_cluster_a7[] = {
> +	/* Cluster only power */
> +	 { .cap =  358, .power = 2967, }, /*  350 MHz */
> +	 { .cap =  410, .power = 2792, }, /*  400 MHz */
> +	 { .cap =  512, .power = 2810, }, /*  500 MHz */
> +	 { .cap =  614, .power = 2815, }, /*  600 MHz */
> +	 { .cap =  717, .power = 2919, }, /*  700 MHz */
> +	 { .cap =  819, .power = 2847, }, /*  800 MHz */
> +	 { .cap =  922, .power = 3917, }, /*  900 MHz */
> +	 { .cap = 1024, .power = 4905, }, /* 1000 MHz */
> +	};
> +
> +static struct capacity_state cap_states_cluster_a15[] = {
> +	/* Cluster only power */
> +	 { .cap =  840, .power =  7920, }, /*  500 MHz */
> +	 { .cap = 1008, .power =  8165, }, /*  600 MHz */
> +	 { .cap = 1176, .power =  8172, }, /*  700 MHz */
> +	 { .cap = 1343, .power =  8195, }, /*  800 MHz */
> +	 { .cap = 1511, .power =  8265, }, /*  900 MHz */
> +	 { .cap = 1679, .power =  8446, }, /* 1000 MHz */
> +	 { .cap = 1847, .power = 11426, }, /* 1100 MHz */
> +	 { .cap = 2015, .power = 15200, }, /* 1200 MHz */
> +	};


So how did you obtain these numbers? Did you use numbers provided by the
hardware people, or did you run a particular benchmark and record the
power usage?

Does that benchmark do some actual work (as opposed to a while(1) loop)
to keep more silicon lit up?

If you have a setup for measuring these, should we try and publish that
too so that people can run it on their platform and provide these
numbers?


--cbwY24+csKcE3jo0
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTjbUcAAoJEHZH4aRLwOS6o90P/Ao4nAHv9AwwZYPeuQCsfh7R
vh1MRPz1OXBqkcygPpSAbnFPG52KRYKGk8rDfW/WUIg2RMy/SZsdJyGu/ZfiOYfE
U8A69S+IMGYH1tTvS9jm9uvdp+k3NGn2zzEGVw0k5LIcemPhMoF4Ss3+pQ7gxaCk
0y4tVXL3Pi0FvTIiCXZqBiydJ7QZ3bV2u/oOxzrmPM96FZACBq5cWV0QlYHV44hw
RHDHbN4NLI4P5jtPojimM2TCE76mntPMkh9yf2kmzZ3IsMChNylQ4o/EwYQkc3YM
vM8uKOLqEYgKqn7t9AdiAOmDRn457y+l7oybLuOOSYxmo8F0qUOcLSxOvaFl4FeY
GFhJRfpdC1xu0e1wgoR6ssXuoSjrEaBJAqu1nfiXdPaSgBkvEF5AxQfkVlKZWflH
Lg6Ni3NV0HbixCZ2VD2X6prMpWHgj3nzul0hWMct8+9Kz+QOfHaD92uurIOivjhC
OQ6Ckxfj58Q67ZlrkwDm0W3dKCJ78p3ZLJwtc+JMk77aYUzBTjCAwEAuBZpOiFqy
T52il0LeYCVC3uTpLDjEix6JJFSvTV4OxT6RzLL+a/1BCABoQMeDQVZGUb5Xb/4r
SAksq2pjT9WrqDCTJqSCCpppSRYSZ176PN5d2kJRhEwtlYNmy4CxeEpTdg4IgTnI
mMbp9S5j4jw3in5l3RGw
=hs4y
-----END PGP SIGNATURE-----

--cbwY24+csKcE3jo0--
