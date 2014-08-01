Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752452AbaHAH30 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 03:29:26 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:33417 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750844AbaHAH3Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 03:29:25 -0400
Date: Fri, 1 Aug 2014 09:29:11 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Aaron Lu <aaron.lu@intel.com>
Cc: Rik van Riel <riel@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        lkp@01.org, jhladky@redhat.com, Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: [LKP] [sched/numa] a43455a1d57: +94.1%
 proc-vmstat.numa_hint_faults_local
Message-ID: <20140801072911.GE19379@twins.programming.kicks-ass.net>
References: <53d70ee6.JsUEmW5dWsv8dev+%fengguang.wu@intel.com>
 <53D72FF5.90908@intel.com>
 <20140729023940.37b6aebc@annuminas.surriel.com>
 <20140731104241.GA9918@twins.programming.kicks-ass.net>
 <20140801020330.GA30211@aaronlu.sh.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="W85UVRsRRZs47q06"
Content-Disposition: inline
In-Reply-To: <20140801020330.GA30211@aaronlu.sh.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--W85UVRsRRZs47q06
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 01, 2014 at 10:03:30AM +0800, Aaron Lu wrote:
> > > > ebe06187bf2aec1  a43455a1d572daf7b730fe12e =20
> > > > ---------------  ------------------------- =20
> > > >      94500 ~ 3%    +115.6%     203711 ~ 6%  ivb42/hackbench/50%-thr=
eads-pipe
> > > >      67745 ~ 4%     +64.1%     111174 ~ 5%  lkp-snb01/hackbench/50%=
-threads-socket
> > > >     162245 ~ 3%     +94.1%     314885 ~ 6%  TOTAL proc-vmstat.numa_=
hint_faults_local

> It means, for commit ebe06187bf2aec1, the number for
> num_hint_local_faults is 94500 for ivb42 machine and 67745 for lkp-snb01
> machine. The 3%, 4% following that number means the deviation of the
> different runs to their average(we usually run it multiple times to
> phase out possible sharp values). We should probably remove that
> percentage, as they cause confusion if no detailed explanation and may
> not mean much to the commit author and others(if the deviation is big
> enough, we should simply drop that result).

Nah, variance is good, but the typical symbol would be +- or the fancy
=B1.

~ when used as a unary op means 'approx' or 'about' or 'same order'
~ when used as a binary op means equivalence, a weaker equal, often in
the vein of the unary op meaning.

Also see: http://en.wikipedia.org/wiki/Tilde#Mathematics

So while I think having a measure of variance is good, I think you
picked entirely the wrong symbol.

--W85UVRsRRZs47q06
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT20HHAAoJEHZH4aRLwOS6hKMP/2oFFmie5jDztW4KL36hsS7x
KMz06Hxf70McAhTOtmfbX2O41J/A56h/A6r1H1GQTMdPq0IKIrYwDjMPcWSvn0Wb
p+0dqq7VFmOD2dqb5br4QxSYYS11Ckd1kzmUsCGFglEnil6lPhtLxjzqxBzmYRC2
8wHjfUajQR5/SSmMTrOJtwWebY596zxI5SpKjyJNVWJ1ryfJcH2QXvurzVbxUoqL
rBMBUgK3OYxdQADtVXxXUnzhZ+WVemQlteMu6rLLkkPQ3t7dItI48B9qLob+dAzc
/yPCbSOffxW69q963Ilr5L3niusveYPBxBfKYiAXwUeW7iUICLftbi/2sXWHq0fJ
L45pnphjTWiN9d44J8JMOJPKcoZhl2Jr+Y6v9Gar9sQDHvCfIwn/E+FOY0zDBRzo
jRX0P3ekSmCkhHHwfrGYj0KT5E60PTWrc3nX1GJTIK3xjNMS9/ycMSkjFuQ6hVRT
aD25H5WCFnmXWzzOTVSz3vkHeaZ/f+q5JR5TxFb3Tmodh9C1M/FcZU5NBS6lUlwm
n+etuYVY+bT5b/HqVa9CsHq93+e/eQDG9iEkxSUSAD9E5bQZjWIVRFBwdUN0mRCf
zyElluJ/6c54acIhkhHQR/YEfguqS1yrXzBVF1jsgunMzydBQFZ3Zm5WiZkUDIlT
pcSmVq0VdLH0MBEOgdtS
=5ku1
-----END PGP SIGNATURE-----

--W85UVRsRRZs47q06--
