Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933353AbaLBUa7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 15:30:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60793 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932844AbaLBUa5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 15:30:57 -0500
Date: Tue, 2 Dec 2014 15:30:44 -0500
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: =?iso-8859-1?Q?D=E2niel?= Fraga <fragabr@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: frequent lockups in 3.18rc4
Message-ID: <20141202203044.GA26482@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	=?iso-8859-1?Q?D=E2niel?= Fraga <fragabr@gmail.com>,
	Sasha Levin <sasha.levin@oracle.com>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+55aFx0K=T8yvfRCYeaJG_5YO+Qm8EEQfA9Xp59xedbzj=f2A@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 01, 2014 at 12:36:34PM -0800, Linus Torvalds wrote:
 > On Mon, Dec 1, 2014 at 12:28 PM, Dâniel Fraga <fragabr@gmail.com> wrote:
 > >
 > >         Hi Paul. Please, I'd like the patch, because without
 > > preemption, I'm unable to trigger this bug.
 > 
 > Ok, that's already interesting information. And yes, it would probably
 > be interesting to see if CONFIG_PREEMPT=y but !CONFIG_TREE_PREEMPT_RCU
 > then solves it too, to narrow it down to one but not the other..

That combination doesn't seem possible. TREE_PREEMPT_RCU is the only
possible choice if PREEMPT=y

	Dave
