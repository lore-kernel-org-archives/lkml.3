Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752588AbaHLFzn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 01:55:43 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:39142 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751166AbaHLFzl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 01:55:41 -0400
Date: Tue, 12 Aug 2014 07:55:27 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Pranith Kumar <bobby.prani@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>,
        "open list:SCHEDULER" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sched: Remove ACCESS_ONCE() for jiffies
Message-ID: <20140812055527.GI9918@twins.programming.kicks-ass.net>
References: <1407797503-24727-1-git-send-email-bobby.prani@gmail.com>
 <1407797503-24727-3-git-send-email-bobby.prani@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="C3X1Qu0ows97PIDn"
Content-Disposition: inline
In-Reply-To: <1407797503-24727-3-git-send-email-bobby.prani@gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--C3X1Qu0ows97PIDn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Aug 11, 2014 at 06:51:41PM -0400, Pranith Kumar wrote:
> jiffies is declared as a volatile variable. Therefore it is not neccessary to
> use ACCESS_ONCE() while reading it.

It also doesn't hurt and it documents intent, so I'm inclined to keep
it.

--C3X1Qu0ows97PIDn
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT6axPAAoJEHZH4aRLwOS6incQALC7jzLnIxo7sE1bEW3hp2kN
Zsia46J6vAdYcqMSPPyf1YFoDnfe3E1QuRp+OtBXFAvsVLqKhY5U0KQ2Wv3Q0V8F
tlbEeHrcIDmIbHCPrnzI4DRC5f8waYoGfLCYJL4GGEdBediDb9qPg4VmE5H+W1a8
UigtukAb6ZoMm2bHoxiTfnsPH4gryncAh7nNXhzeKLBbIWV5cLcHdSVJhv/1LWmQ
s7W2+SU2s7y6Yb5T+l16FZFRNFD5wctWXI3f57nM7Z/HBIDYlgrBmLtuVaCM+e2k
lNwvpdbuMjQ886qZN7LASmLF69RRcvAqoU2oppfb2NKarLRoGeV17DPUpGgH+K2O
yFpsVN+ayoNv6ljKk2leEV6Mb/m5omfdJQfuaHhQm6nqqCxRqaE0d3XxByYElVbe
u3SXirc9gGZG7XUpzZNZV8FTYttHOB7eMxwlIRnAkd4ahIE2SWhAP0a25ndizkf7
wybbTacSiNP3V74uW4NIdQEwPXjw9dcKJdtVrKQLZWyUmLEX/6FQEN5wNn+1IXS7
sNdH2KaXUNBouYPSzz/MnIwBVS6KfiJXi25wV0Q/PceZ/O2JGKARJXEn9SDHz10i
QnN/Qs2apa9uGzOusZXEaBybGRjZm5BQhTL1Uof7CfYAJKHKEztDl9uc702mnOIZ
YPDeH9MOrakZO8LG1wjf
=SmQn
-----END PGP SIGNATURE-----

--C3X1Qu0ows97PIDn--
