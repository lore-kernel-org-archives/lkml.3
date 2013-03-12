Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755353Ab3CLMst (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 08:48:49 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:64584 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754785Ab3CLMss convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 08:48:48 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jason Cooper <jason@lakedaemon.net>
Subject: Re: linux-next: manual merge of the akpm tree with the arm-soc tree
Date: Tue, 12 Mar 2013 12:48:24 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-8-generic; KDE/4.3.2; x86_64; ; )
Cc: Olof Johansson <olof@lixom.net>, Andrew Lunn <andrew@lunn.ch>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jingoo Han <jg1.han@samsung.com>,
        linux-arm-kernel@lists.infradead.org
References: <20130312144714.39749c5b0bd1aea14c4d2ff8@canb.auug.org.au> <CAOesGMgSzn+uCVEMKZgtorcNkdzzvntmnfoej5vN-AjF43pnyQ@mail.gmail.com> <20130312115339.GF12700@titan.lakedaemon.net>
In-Reply-To: <20130312115339.GF12700@titan.lakedaemon.net>
MIME-Version: 1.0
Content-Type: Text/Plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-Id: <201303121248.24736.arnd@arndb.de>
X-Provags-ID: V02:K0:jTuTViFQzKsjlSMVDcYly/S0A/EJy/ObUAvPy0TPY46
 dwX6FgtZCM1rxhDcXm6R0XcU3FwSKbWLiR32y2sKIeIXFPgu8b
 laDVxha9ijsXkxjl5WefAmqUQ0l7odmGwMkC4YN+aHEycJ/XS1
 4zwUcMPyZf8MXKAes3dehvyJhu5OGb5Tvwmrk4ulHMJ/9LJNO+
 toLoln0eCSGT2fdf6atR0z/m+9ES94QMtReYCGQZuYGPWE213e
 GELrdIWVoYJ4GvMwGheFLrt+CCau6MacJWvGhF/iR4I9BhB+BJ
 9A0EWEV7GiLYa+++LsA0sKEWrtXmfZCuQTzYuQAH1uYcsM4Glq
 XcWszwZfjOPgvWg7UMWs=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 12 March 2013, Jason Cooper wrote:
> I chose to keep them together to maintain bisectability.  Either you
> have all of the fix (you landed on this branch), or you don't.  Was this
> the correct decision in this case, or did I miss something?

I think you don't need to worry about bisection in this case, especially
as you mentioned that 3.8 is already broken.

>From all I can tell, these are four separate fixes, and you want to have
all of them get merged, but applying just one of them will not make the
state of the kernel tree any worse than what it is before the patches.

	Arnd
