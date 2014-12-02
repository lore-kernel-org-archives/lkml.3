Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933035AbaLBVRq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 16:17:46 -0500
Received: from mail-qg0-f49.google.com ([209.85.192.49]:47358 "EHLO
	mail-qg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932692AbaLBVRo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 16:17:44 -0500
MIME-Version: 1.0
In-Reply-To: <20141202193159.GA17595@redhat.com>
References: <CA+55aFz-JUX6CU-aO+cwLHYtH7BA+dgyUnEGoy8T4S62gEDFpA@mail.gmail.com>
	<20141127225637.GA24019@redhat.com>
	<m5dart$co$1@ger.gmane.org>
	<CA+55aFwm4hpyDjJ=GzrahOe2QtuO7im71sPky7U6Rh+18A0X0w@mail.gmail.com>
	<547b8a45.6e608c0a.20f9.1002@mx.google.com>
	<CA+55aFzQ0QZxL-PRnv4Db=wo1pDmBR45P-vpGxyeJnt1DFnSfA@mail.gmail.com>
	<547bbe36.48548c0a.105c.779c@mx.google.com>
	<20141201191431.GA17385@linux.vnet.ibm.com>
	<547ccf74.a5198c0a.25de.26d9@mx.google.com>
	<CA+55aFx0K=T8yvfRCYeaJG_5YO+Qm8EEQfA9Xp59xedbzj=f2A@mail.gmail.com>
	<20141202193159.GA17595@redhat.com>
Date: Tue, 2 Dec 2014 13:17:43 -0800
X-Google-Sender-Auth: mRTf4Y8L-gZe754A3G1mPY2hBqM
Message-ID: <CA+55aFy2pCUvRwJNCpsUUA7pUQWWtx5_ir369TTHPJVhLZ5k-g@mail.gmail.com>
Subject: Re: frequent lockups in 3.18rc4
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        =?UTF-8?Q?D=C3=A2niel_Fraga?= <fragabr@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 2, 2014 at 11:31 AM, Dave Jones <davej@redhat.com> wrote:
>
> I'm in the process of bisecting 3.16 -> 3.17 (currently on -rc1)
> Thanksgiving kind of screwed up my flow, but 3.16 got a real
> pounding for over 3 days with no problems.
> I can give a !PREEMPT_RCU build a try, in case that turns out to
> point to something quicker than a bisect is going to.

No,. go on with the bisect. I think at this point we'll all be happier
narrowing down the range of commits than anything else. The behavior
Dâniel sees may be entirely unrelated anyway.

                   Linus
