Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756509AbaIIMny (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 08:43:54 -0400
Received: from casper.infradead.org ([85.118.1.10]:44798 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753607AbaIIMnw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 08:43:52 -0400
Date: Tue, 9 Sep 2014 14:43:45 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Robert Richter <rric@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        kan.liang@intel.com
Subject: Re: [PATCH v4 09/22] perf: Support overwrite mode for AUX area
Message-ID: <20140909124345.GN16043@twins.programming.kicks-ass.net>
References: <1408538179-792-1-git-send-email-alexander.shishkin@linux.intel.com>
 <1408538179-792-10-git-send-email-alexander.shishkin@linux.intel.com>
 <20140909084436.GY19379@twins.programming.kicks-ass.net>
 <87y4ttt9m0.fsf@ashishki-desk.ger.corp.intel.com>
 <20140909105537.GJ6758@twins.programming.kicks-ass.net>
 <87sik1t3g9.fsf@ashishki-desk.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kUBUi7JBpjcBtem/"
Content-Disposition: inline
In-Reply-To: <87sik1t3g9.fsf@ashishki-desk.ger.corp.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--kUBUi7JBpjcBtem/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Sep 09, 2014 at 02:53:42PM +0300, Alexander Shishkin wrote:

> We can infer where the new data starts from the timestamps in the trace
> stream, so the decoder can take care of it (and that's how it's done at
> the moment).

So that means the data stream can be read from arbitrary locations,
right? I can imagine not all data streams are always readable like that
(for instance the perf datastream is not).

Does it make sense to have the driver provide head,tail for this mode?
In your case you can simply provide whatever, but for those where it
matters they can ensure consistent data such that the stream might be
recoverable.

--kUBUi7JBpjcBtem/
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJUDvYBAAoJEHZH4aRLwOS6ugoP/1a2XfVE2UdmUVS/FYxJW7lQ
7AY6WAZs9PXDNeJU1E0yezxh0Q+u6HzH2/KYJkqBZFfJ9CHJYOMi5ObRl0Zoh0iJ
RQjhP2AA9Ldn4txKGC4iGglO6rc18qev4NmpGGBSmSuFn2DZW61JN/7k1Tr2lsU4
YKVR+vzRiVAlYHcTprSi0qel+Z+bX9wwfoDoU8KK7aMzMMlVhXNT8qSvA7JVyYzk
iQqUj01cDwF8WizIiCHQABQbxrUto9ZjleGA1SmdlGavj2UNst5VYQNKCoq/mCSl
RF6ZF+S8L+CsJl/ZvZZbcSOSm7xekxVdQWX8IXn1PKB2Vyy6SZQpk35q5kOJXo2f
Tw0hW9MEui50ErTI3D3rNVMzsJnxQZeC4p1gAntQPk60QmW7TwjCQm84jIIIvAxu
pSGFDGbntbJVBxmuvHiViPLf8PIejUwTb5wEpLeM4PPLYlUc2rgIc7UV15QdVxNk
qxsvj+5v2ers0/hSG8eY4rftfKL+l8kcTtikEMsJEvMJUWJ0E53jv4SyMsvfVUHX
wIlP1qixeGe9WEriKCnwXdlVEPmlNoRZGCddd+h458dbOQiekMDFhehN3HQVlyNW
kRRiWZB8LPiQ8H1mI/9RCGObDRpxG9SeuE1leKqR6g2eczhWBzQTX+OZuVo3fNFI
mA476/oAxySF9bKsuVh5
=CFPM
-----END PGP SIGNATURE-----

--kUBUi7JBpjcBtem/--
