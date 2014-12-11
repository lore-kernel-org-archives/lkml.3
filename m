Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759174AbaLKWgo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 17:36:44 -0500
Received: from mail-qa0-f42.google.com ([209.85.216.42]:47212 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758933AbaLKWgm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 17:36:42 -0500
MIME-Version: 1.0
In-Reply-To: <548A122C.8000906@oracle.com>
References: <20141201230339.GA20487@ret.masoncoding.com>
	<1417529606.3924.26.camel@maggy.simpson.net>
	<CA+55aFw8smHBw9HiCiYL_ohkULLeunWo6qfayM19zhF1hKAxXg@mail.gmail.com>
	<1417540493.21136.3@mail.thefacebook.com>
	<20141203184111.GA32005@redhat.com>
	<CA+55aFzLprvtdLGDXgRr=k3QqO824uQSzbxT-b4vu_4pryMtSA@mail.gmail.com>
	<20141205171501.GA1320@redhat.com>
	<CA+55aFxVeti8pU=Y_w54oGb8syGduOySAp-ag+KsCom-c12e-Q@mail.gmail.com>
	<1417806247.4845.1@mail.thefacebook.com>
	<CA+55aFz3iUyV9=_rVUdO0WPoOyOKOYkcHCxb3p=2fgSHtCTNgw@mail.gmail.com>
	<20141211145408.GB16800@redhat.com>
	<CA+55aFy1_w1NrkeopMXsxGftO5F03JzKgn-8uTQRnEAXuoiXgg@mail.gmail.com>
	<548A122C.8000906@oracle.com>
Date: Thu, 11 Dec 2014 14:36:41 -0800
X-Google-Sender-Auth: sKh6GUzDphjG1YKvsLI78IeqmEc
Message-ID: <CA+55aFw68nC+5s=iX2R4SLsgG3nBvURmDXYvX5pFJgHBnQoHMA@mail.gmail.com>
Subject: Re: frequent lockups in 3.18rc4
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Dave Jones <davej@redhat.com>, Chris Mason <clm@fb.com>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        =?UTF-8?Q?D=C3=A2niel_Fraga?= <fragabr@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 11, 2014 at 1:52 PM, Sasha Levin <sasha.levin@oracle.com> wrote:
>
> Is it possible that Dave and myself were seeing the same problem after
> all?

Could be. You do have commonalities, even if the actual symptoms then
differ. And while it looked different when you could trigger it with
3.16 but DaveJ couldn't, that's up in the air now that I doubt that
3.16 really is ok for DaveJ after all..

And you might have a better luck bisecting it, since you seem to be
able to trigger your RCU lockup much more quickly (and apparently
reliably? Correct?)

                     Linus
