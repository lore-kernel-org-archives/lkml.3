Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933455AbaEGPEe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 11:04:34 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:47341 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932083AbaEGPEb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 11:04:31 -0400
Date: Wed, 7 May 2014 17:04:24 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH v4 1/2] perf record: Propagate exit status of a command
 line workload
Message-ID: <20140507150424.GP30445@twins.programming.kicks-ass.net>
References: <1399425205-11503-1-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ik0NlRzMGhMnxrMX"
Content-Disposition: inline
In-Reply-To: <1399425205-11503-1-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ik0NlRzMGhMnxrMX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, May 07, 2014 at 10:13:24AM +0900, Namhyung Kim wrote:
> -	on_exit(record__sig_exit, rec);

NAK!

--ik0NlRzMGhMnxrMX
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTakt4AAoJEHZH4aRLwOS6eo8P/2KdHukmVvQ2Anxfx/lI+Xov
ItjBkzj18xWLCnXdZuoIYnj/0U9pKFAVYfAdEwPrNIyRMhzeOR8Q9R/eG+SI+zfZ
WqpSupfiUmbWA3JEhuwvyLbcw2sBTIn0rX+O+BG7cv7iKepWFf3aM2wYVC+AN0Hg
3jZWW3MOjD3720HoTN/1AyKKJSQBoji9DX3hnEAwjlAp7YLzvsJy0lFWFsR/HcnQ
IM7AiMNtcgBTbTzCb8cKqtgLJGULKO3U5tpk7VaNLR8wk8Zj9Wrjaee94sPYwPdJ
i0dfzcTFMMhZ6+Ypg7VazRkUhri/+AwwS8di54Fs/U8YqMq9I3GtKOSaCIfHvL2b
qOxWjhiz2bERMK6oID36fHp0ppcXHCTgGpdOHH2Ox7ijQ6tWvoMP+IUsdTNHJ6et
wdEvLvA2FFovWxL45PjCclRvksjBul3Sii0K3TS760uVACdgdQqMs7Swn96yX7kj
frYTZ/CvtwJKwDYA04mwJ3HXV3RZX9LMpxgFtJrtIK7r2TE24SEFaCQv6PEq9fje
pFWxyXOXtRnKMUADOPNseJTbnYKeDNv+jmogzCWckTdUhqjGv1mWnoIygb8CWimx
/N65OIM7IN4aJOpc3FfIN9AFSVcUhyMldGBJyUjDS1qON7ZPLYhdoo32KZEKmGje
vAYbNpZmD0nlomB45pa0
=XDlT
-----END PGP SIGNATURE-----

--ik0NlRzMGhMnxrMX--
