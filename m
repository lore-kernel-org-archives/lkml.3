Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932329AbaGaIdo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 04:33:44 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:53264 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932116AbaGaIdn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 04:33:43 -0400
Date: Thu, 31 Jul 2014 10:33:30 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Aaron Lu <aaron.lu@intel.com>
Cc: Rik van Riel <riel@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        lkp@01.org, jhladky@redhat.com
Subject: Re: [LKP] [sched/numa] a43455a1d57: +94.1%
 proc-vmstat.numa_hint_faults_local
Message-ID: <20140731083330.GO19379@twins.programming.kicks-ass.net>
References: <53d70ee6.JsUEmW5dWsv8dev+%fengguang.wu@intel.com>
 <53D72FF5.90908@intel.com>
 <20140729023940.37b6aebc@annuminas.surriel.com>
 <20140729081712.GS20603@laptop.programming.kicks-ass.net>
 <20140729160437.4561742f@annuminas.surriel.com>
 <20140730021425.GA25023@aaronlu.sh.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="anI1hHIxHfSFT67c"
Content-Disposition: inline
In-Reply-To: <20140730021425.GA25023@aaronlu.sh.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--anI1hHIxHfSFT67c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jul 30, 2014 at 10:14:25AM +0800, Aaron Lu wrote:
> 118881 ~ 0%            +1.2%    120325 ~ 0% ivb42/hackbench/50%-threads-pipe

What kind of IVB is that EP or EX (or rather, how many sockets)? Also
what arguments to hackbench do you use?


--anI1hHIxHfSFT67c
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT2f9aAAoJEHZH4aRLwOS6cY4P/0qgpgYFU6bRJsqQwV5Kt/Fy
i1flx4LQ4sfqvBHJVuTcEThvrfL9c/YOldYZF1mi+6ppmRp/+WLucTp61Ejl8d8j
zaeLrUX2rZ3Q6sJ74e92o+Nl95MJNQ4hzePcPNPYc6U4kB15AlUl5/+SU/3uLpGs
MwYWU3Hrt5MytgmdoKtQYK45Msq7GJBljqhGTnH4ok7xkQUf22rNoRLMH486HzSH
jGpkAR87RkwK/QGorhX+NoMeLD+TDFVqrTJ0vzQ3LC91DFgiaKMeYUsljuRiwwTz
quA0QCqoHcxmJwWnDTvy2VpBFJhNMRAmWCaeLUXI25u1bfukUiq3tripX9DnSGyj
Im/VR7g9OE4xIwdIjd+uLaKpD7zhb0ju3j+izZMNjqnula/OiTsp+kE2h9MfuKM+
ptOqQ99z8e+3v3fXX6Dx2OGiaIWCNFcXfg7BCANMOaQWma7jZNpzq1B9g/M4TFOt
4vH64IHkJGbE1aF7vvJCstal21IVFYXLyskv/410GWxbHO1dTNClmuZ7Y4OMyfNk
OxAF+P8mvwNB7eVu7YBx8W3WRMjNrU7Aoj/a/2qM/TAR5LXttIP+43PKyZCjj0mU
eu4dS5burf0FgZ1pAqlrt/c17tM0tebLwyLv5y2FXclKsZM+cOvGnIa0JW4m6aVY
+q54XTvQ36Ub/k0e6LJv
=Le7b
-----END PGP SIGNATURE-----

--anI1hHIxHfSFT67c--
