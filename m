Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751622AbaG1Suf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 14:50:35 -0400
Received: from casper.infradead.org ([85.118.1.10]:60557 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750883AbaG1Sue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 14:50:34 -0400
Date: Mon, 28 Jul 2014 20:50:23 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Jason Low <jason.low2@hp.com>
Cc: Davidlohr Bueso <davidlohr@hp.com>, mingo@kernel.org, aswin@hp.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -tip/master 3/7] locking/mcs: Remove obsolete comment
Message-ID: <20140728185023.GX19379@twins.programming.kicks-ass.net>
References: <1406524724-17946-1-git-send-email-davidlohr@hp.com>
 <1406524724-17946-3-git-send-email-davidlohr@hp.com>
 <1406566175.2411.13.camel@j-VirtualBox>
 <20140728165426.GT19379@twins.programming.kicks-ass.net>
 <1406569775.2411.48.camel@j-VirtualBox>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2KzDJJXmwzGxkqkN"
Content-Disposition: inline
In-Reply-To: <1406569775.2411.48.camel@j-VirtualBox>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2KzDJJXmwzGxkqkN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jul 28, 2014 at 10:49:35AM -0700, Jason Low wrote:

> So if the function is inlined, perf report would show the contention
> occurring in the calling function rather than the inlined function. As
> an example, if we were to convert osq_lock() and mutex_spin_on_owner()
> to inline, perf would report all the contention from both of those
> functions occurring in just "__mutex_lock_slowpath()".

But that's easily fixed on the tool side, right? Dwarf info (as present
in vmlinux when build with CONFIG_DEBUG_INFO) has all that.

--2KzDJJXmwzGxkqkN
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT1ptvAAoJEHZH4aRLwOS62zcP/Rp64QWyYiE8KvoGITWdWIMv
JyuuPf6iuVP4VsmzBL/2kxfc3PkumlHPbj4wMYjNUTw3TXx01681ka0akH8II91l
mGi1wdme+nSrot/tenl3fCCraq7e16AkYkMAF36Q0b9UwGCTyFyVF05JQsaiCGsj
bL4lOIVmPkAXpDaZMSWjGjORwJYFA+aQ44hiWb/R5og6lKsDa9zdMirRjJtVFbi3
X2Bc4vwAsmOl5JfjynvWpjtrWvC8L3B/8exeijzml4CKbXOpkVKrsqPZFhdW9u0K
G5BINXQ1cKg6OvMIOBqgzNYZ3Qs4HkXCOUqD2uUMESXA0VAQR7gpwLSAiXlb6liJ
3i7cI+9uhN2zR6uH4L98KT/ZULNRJYwqozkPAg3UGvjd7m3tdqnT3pQv04PTfNzV
SZH8U8IALVX0COsi8XWWhql2Hd+Zg1+8Uyw7PBtQjtNMRcU94Es0QmNZOiQrX0Tz
ANKtsafK17zjoBNyCaU7rc8Gd1zYD7KFouzrpm5YAD19+7tG/78Vk2ZQQ+lvu7ui
F6gK7gJQAL+1XYRMZlNERanOdwfPILR6kYV1CsPXJ5nWlVDeCRoMIeApZ9YXHETm
pQeXWPwetEAhmhgPfbANTTfjWrR1J7qC0iAKA6Um78gC4OLe4A+KR8PF0wRsVWKg
bFsWsrQLiZPPbH46BgAZ
=RMFU
-----END PGP SIGNATURE-----

--2KzDJJXmwzGxkqkN--
