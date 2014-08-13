Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753814AbaHMTX6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 15:23:58 -0400
Received: from casper.infradead.org ([85.118.1.10]:46080 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751923AbaHMTX5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 15:23:57 -0400
Date: Wed, 13 Aug 2014 21:23:45 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Rik van Riel <riel@redhat.com>, Mike Galbraith <umgwanakikbuti@gmail.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Frank Mayhar <fmayhar@google.com>,
        Frederic Weisbecker <fweisbec@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sanjay Rao <srao@redhat.com>, Larry Woodman <lwoodman@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] sched: don't use while_each_thread()
Message-ID: <20140813192345.GB16043@twins.programming.kicks-ass.net>
References: <20140813191938.GA19301@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wzJLGUyc3ArbnUjN"
Content-Disposition: inline
In-Reply-To: <20140813191938.GA19301@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wzJLGUyc3ArbnUjN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Aug 13, 2014 at 09:19:38PM +0200, Oleg Nesterov wrote:
> Peter, could you take these simple patches ?

Done, thanks!

--wzJLGUyc3ArbnUjN
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT67tBAAoJEHZH4aRLwOS623kQAK5AW6xY3KdO9WlmcdiNvdFr
eeNUEEkdpq5cnDiCQedIc+n41ucNDkfd3zM2iODGNxgFnfMqcupRR+C/VpilACJh
3KXVgOXCArMgyEDdJ25PUZ3Ye6rn71x7IpiE71WbOe4NwV0XwTONNLtwcD4BU+Wr
R8bN7K6DpTJnozKxYoPYqsxKAMp1pyO+EHzpx5BzSVd4Ud05ZC8e9KXfmcz1ykJH
6ZRFtDTs24qEemwVQLw8YpmewpoJYIJdiJDjcZAuuqNyF+65Bq1W1oc5dOM0juox
lEpXNBcxoeyj+L+9QNr+BjEKxRX6ZTXCDtdFpCfZg2o2DEpyppKN7y0Dzinz5TvH
fiBFUX3gpBDKeeChhVXt0ac8ujTYsY37Y+S7XtjepKN47a8A4baUvnM0h/l6O/Xk
JlPBFNvAOd/ku6RHheiOHM9c84+FIqU/ZaZFwJab1M+pSeEH1AaxpuvX1ZsCDLHX
QyLikK7VsdtimuRnyyTl/Eg4Eced6E5oz33/HidJbux414YW3Cl/SLf8fM/SKR54
n3YoaXhCmX+UKB7B1q5WKOuY704sL8iDJEDKXlCOOoJpSqZBK7fUx/n3Kq139Jky
3d1PFncpKLBJOEsFrEUSDeOYQmAg7cU+cKEjLxXwRRtmfnShuor5eCxcmxc99U9j
beHmQIqY3JRj6CTONcHN
=KPAR
-----END PGP SIGNATURE-----

--wzJLGUyc3ArbnUjN--
