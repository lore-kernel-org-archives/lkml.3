Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754878AbaHNNNV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 09:13:21 -0400
Received: from casper.infradead.org ([85.118.1.10]:49503 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754813AbaHNNNT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 09:13:19 -0400
Date: Thu, 14 Aug 2014 15:13:04 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Liu, Chuansheng" <chuansheng.liu@intel.com>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Liu, Changcheng" <changcheng.liu@intel.com>,
        "Wang, Xiaoming" <xiaoming.wang@intel.com>,
        "Chakravarty, Souvik K" <souvik.k.chakravarty@intel.com>
Subject: Re: [PATCH] cpuidle: Fix the CPU stuck at C0 for 2-3s after PM_QOS
 back to DEFAULT
Message-ID: <20140814131304.GK16043@twins.programming.kicks-ass.net>
References: <1407982309-4863-1-git-send-email-chuansheng.liu@intel.com>
 <CAKnoXLw3DrBAxCUWEkXtvCTf+E1w0xTHJSiSUY6Qd6xHXeGaoQ@mail.gmail.com>
 <20140814105336.GH16043@twins.programming.kicks-ass.net>
 <27240C0AC20F114CBF8149A2696CBE4A01E5B61C@SHSMSX101.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Qo8f1a4rgWw9S/zY"
Content-Disposition: inline
In-Reply-To: <27240C0AC20F114CBF8149A2696CBE4A01E5B61C@SHSMSX101.ccr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Qo8f1a4rgWw9S/zY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Aug 14, 2014 at 11:24:06AM +0000, Liu, Chuansheng wrote:
> If inspecting the polling flag, we can not fix the race between poll_idle and smp_callback,
> since in poll_idle(), before set polling flag, if the smp_callback come in, then no resched bit set,
> after that, poll_idle() will do the polling action, without reselection immediately, it will bring power
> regression here.

-ENOPARSE. Is there a question there?

--Qo8f1a4rgWw9S/zY
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT7LXgAAoJEHZH4aRLwOS69WEQALCrrYBMJA08zfgZYPTz5gyj
Y/SFi98WmrcbobWns+17w03XM9iu79w2nqkrkAuBqAK/d46WOsBTV99+UynvFAE2
NXTK+FKnJTfk9d4kchU53EWDqI5ruUZdlB9g+regvm9HSOwqboETA58+nvRdslVQ
bf3scfjCLxSxam6cQnWF7eajPnoRPC9aB0g34hd62WCeq6prinuyF8RXAXz/sntH
5LnHnDYCVPFUz/r+jCy9tiMVs8LsAr3gogVrb3SVjGErO9zj+RtlIBNnGG26QakF
prFJg+JjucJyE2VpEqxn87aWbEXrZZSMqxVvoxP3R7C/7j6lQwaTV6bk9D50C8fn
9WG1tQ0EhVLhqws2+wLECJmXEkyyV3jl11rL7qvR+O1beZyq0mG+AhRrawVk8B6u
QReQJM2JDU9LQ//Qhmylt+bzbn6bYP86JI6Pfv45OqOyufgV4TkPJyTd+9gXIRsd
688HsEjIOQWi2tNUUUN3EQAK78NMtZ5kSBBIMD9Sfw6QaQE/jMO9udbhQb00B4mH
tJXfNfCx05n0pksdTvyOIZwXK1JuD51bhkKRfxKwxx/zi84PNTjpcT2e3OPaBxVE
bYaGbby7DeItc+ULb9P72+GxffIMuqV/FsYen+4UTiA4ZhBvowA6gvRMWhxYYAZ0
G7rLtUOwtxht0j2CqIwJ
=oI5t
-----END PGP SIGNATURE-----

--Qo8f1a4rgWw9S/zY--
