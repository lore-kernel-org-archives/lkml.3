Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754310AbaLBRJA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 12:09:00 -0500
Received: from mail-qa0-f42.google.com ([209.85.216.42]:63234 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754063AbaLBRI7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 12:08:59 -0500
MIME-Version: 1.0
In-Reply-To: <547dec29.c71f8c0a.33d1.11d9@mx.google.com>
References: <20141126225745.GA30346@redhat.com>
	<CA+55aFz-JUX6CU-aO+cwLHYtH7BA+dgyUnEGoy8T4S62gEDFpA@mail.gmail.com>
	<20141127225637.GA24019@redhat.com>
	<m5dart$co$1@ger.gmane.org>
	<CA+55aFwm4hpyDjJ=GzrahOe2QtuO7im71sPky7U6Rh+18A0X0w@mail.gmail.com>
	<547b8a45.6e608c0a.20f9.1002@mx.google.com>
	<CA+55aFzQ0QZxL-PRnv4Db=wo1pDmBR45P-vpGxyeJnt1DFnSfA@mail.gmail.com>
	<547bbe36.48548c0a.105c.779c@mx.google.com>
	<20141201191431.GA17385@linux.vnet.ibm.com>
	<547ccf74.a5198c0a.25de.26d9@mx.google.com>
	<20141201230813.GE25340@linux.vnet.ibm.com>
	<547dec29.c71f8c0a.33d1.11d9@mx.google.com>
Date: Tue, 2 Dec 2014 09:08:53 -0800
X-Google-Sender-Auth: v5m-KQZ6kV0OVNT8nK1iPsDQPvE
Message-ID: <CA+55aFyju-xwqQpVTA+yNPdfjgYLWdCxMLNwVywLN+W5hj_Bsg@mail.gmail.com>
Subject: Re: frequent lockups in 3.18rc4
From: Linus Torvalds <torvalds@linux-foundation.org>
To: =?UTF-8?Q?D=C3=A2niel_Fraga?= <fragabr@gmail.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 2, 2014 at 8:43 AM, Dâniel Fraga <fragabr@gmail.com> wrote:
>
>         Linus, Paul and others, I finally got a call trace with
> only CONFIG_TREE_PREEMPT_RCU *disabled* using Paul's patch (to trigger
> it I compiled PHP with make -j8).

So just to verify:

Without CONFIG_PREEMPT, things work well for you?

But with CONFIG_PREEMPT, you are able to create the rcu_sched stalls
both with and without CONFIG_TREE_PREEMPT_RCU?

Correct?

> Dec  2 14:25:54 tux kernel: [ 8550.791697] INFO: rcu_sched detected stalls on CPUs/tasks: { 4} (detected by 0, t=60002 jiffies, g=112854, c=112853, q=0)

Paul?

                    Linus
