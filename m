Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932919AbaLDRr4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 12:47:56 -0500
Received: from mail-qc0-f174.google.com ([209.85.216.174]:56505 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932343AbaLDRry convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 12:47:54 -0500
MIME-Version: 1.0
In-Reply-To: <5480991f.c42ee00a.3e08.ffff8ddd@mx.google.com>
References: <547e11fa.8778e00a.3439.ffffa88c@mx.google.com>
	<20141202205636.GQ25340@linux.vnet.ibm.com>
	<547e36d1.c54ae00a.2571.fffffd13@mx.google.com>
	<CA+55aFxdZjJprk8t9NxcZmewAAQ5Gf1XQWV=5i+Vfc5uTSfWFg@mail.gmail.com>
	<547e81ce.a1628c0a.4985.ffffb12a@mx.google.com>
	<CA+55aFxumSXif01LigHBgZeXFTWT-7knX=a8LJZeaZZDPoHCBg@mail.gmail.com>
	<CAEUsAPYthwHxopuiBcGg4_nnBDDsS2jrTw4pDFiov38awsFodA@mail.gmail.com>
	<CA+55aFyBgyRS0zeE+LuHAvc=54v0de2KX=hRnr3imXwFFbftXw@mail.gmail.com>
	<54801ea9.0ca5e00a.3c72.08ce@mx.google.com>
	<CA+55aFzJ2uOxHC8y25oTzkURPcXo9r=5cvcCzSxgOSKnET5voQ@mail.gmail.com>
	<20141204165203.GA3916@lerouge>
	<5480991f.c42ee00a.3e08.ffff8ddd@mx.google.com>
Date: Thu, 4 Dec 2014 09:47:53 -0800
X-Google-Sender-Auth: snEBsPffR7M3Qxa-POjfEh0_OWQ
Message-ID: <CA+55aFzVqveEeVc9v58nVhCbbxh3ekV+sBjffSXLak6S9y9WCw@mail.gmail.com>
Subject: Re: frequent lockups in 3.18rc4
From: Linus Torvalds <torvalds@linux-foundation.org>
To: =?UTF-8?Q?D=C3=A2niel_Fraga?= <fragabr@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Dave Jones <davej@redhat.com>,
        Chris Rorvick <chris@rorvick.com>, Tejun Heo <tj@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 4, 2014 at 9:25 AM, Dâniel Fraga <fragabr@gmail.com> wrote:
>
>         Sorry about that Linus. Well, so I'm using 3.18.0-rc7 and
> everything is working perfect here. :)

Ok. Can you make sure to really beat on that kernel, just to make sure
there's nothing else hiding?

                  Linus
