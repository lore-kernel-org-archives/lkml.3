Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751178AbaHBE1Q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2014 00:27:16 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:41365 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750729AbaHBE1P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2014 00:27:15 -0400
Date: Sat, 2 Aug 2014 06:26:43 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Jirka Hladky <jhladky@redhat.com>
Cc: Davidlohr Bueso <davidlohr@hp.com>, Rik van Riel <riel@redhat.com>,
        Aaron Lu <aaron.lu@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        lkp@01.org
Subject: Re: [LKP] [sched/numa] a43455a1d57: +94.1%
 proc-vmstat.numa_hint_faults_local
Message-ID: <20140802042643.GM19379@twins.programming.kicks-ass.net>
References: <53d70ee6.JsUEmW5dWsv8dev+%fengguang.wu@intel.com>
 <53D72FF5.90908@intel.com>
 <20140729023940.37b6aebc@annuminas.surriel.com>
 <20140731104241.GA9918@twins.programming.kicks-ass.net>
 <20140731155723.GY3588@twins.programming.kicks-ass.net>
 <53DA6BDA.8080000@redhat.com>
 <1406926000.16021.6.camel@buesod1.americas.hpqcorp.net>
 <53DC06FA.8030104@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PYzCmycsK/SIf2mL"
Content-Disposition: inline
In-Reply-To: <53DC06FA.8030104@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--PYzCmycsK/SIf2mL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Aug 01, 2014 at 11:30:34PM +0200, Jirka Hladky wrote:
> I see the regression only on this box. It has 4 "Ivy Bridge-EX" Xeon E7-4890
> v2 CPUs.

That's the exact CPU I've got in the 4 node machine I did the tests on.


--PYzCmycsK/SIf2mL
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT3Gh+AAoJEHZH4aRLwOS6JdgP/1srbisKDyBRF3OWjQ3I0Lb/
aAfOIKgCbA4BST8s7F/9K/hOwGHikTe/okpiCqtLqQhN8BTnHvnV9cpDAn1lDSlT
FLPZYHRXMj9pDu/aKR4q2h+SOPVe49xS9gyZOzd/QZoFE5DlqSfgTb5SHRsd9F2d
62cjvyZRNFr5UeGZnwYqAPeV+lm1BbMXVrJnVnGiSA8vlF5z2e4011ZWj5EfaPJ/
qZ72YGO4iaI3b/0GaG9ihxDOJGzXTzv1ZqQMsX3UYod8MrnmbbcuFSNKKCwqh/XF
dGNOsIPCxvmCgePm9lOEgLdgfK9XMsniiyflpF/kPzChEZ0r9l4uVp87BeYKPS+/
ytUStl81bQrQrjYQGNHY661m6UKwbhP2PYQPRnomNliTtj41FpJ421hknyx3ppPu
PXdIL8vBOB5t4t3jNsHTx0IitkWaut01BClGaieKhfPc/rRvFEheflOndOHpXDxP
8ZUMstOyRlwII2LAsEmnyl/lUy8V4Cn1Y1+DvPQPFxqdq2SGfDNgrWV1a9/o9iHL
6mJXN5yJSe+tsvYDvt2jHVuYt6zWU4SpOHQ90ufrzmxSlbquSybSZ+djwf+38ui4
P+gFfjfZD+J5gDthKkpIStCE/ojEaL9wCgON+u+jDgYqzOq+3TlKlWZ9roxo0pVS
AscPJ/EKhDsZ0sTStr4o
=jIsy
-----END PGP SIGNATURE-----

--PYzCmycsK/SIf2mL--
