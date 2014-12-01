Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752319AbaLABCu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 20:02:50 -0500
Received: from mail-qa0-f47.google.com ([209.85.216.47]:52572 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752126AbaLABCt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 20:02:49 -0500
Message-ID: <547bbe36.48548c0a.105c.779c@mx.google.com>
Date: Sun, 30 Nov 2014 23:02:43 -0200
From: =?UTF-8?B?RMOibmllbA==?= Fraga <fragabr@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: frequent lockups in 3.18rc4
In-Reply-To: <CA+55aFzQ0QZxL-PRnv4Db=wo1pDmBR45P-vpGxyeJnt1DFnSfA@mail.gmail.com>
References: <20141114213124.GB3344@redhat.com>
	<CA+55aFx16ks_azU0eAcx+qZ5-o8Xo0zzP6aNjrskai8rqp+eMg@mail.gmail.com>
	<20141115213405.GA31971@redhat.com>
	<20141116014006.GA5016@redhat.com>
	<CA+55aFwLH6zGf7O=o2+H0Z8=8nW4zwUbw3Q4bJGttHACv9g+FQ@mail.gmail.com>
	<20141126002501.GA11752@redhat.com>
	<CA+55aFy9c2FY2gDw14VU537QJoLHAbf+q_75VUwU33_HLz+F0w@mail.gmail.com>
	<20141126024032.GA13246@redhat.com>
	<20141126225745.GA30346@redhat.com>
	<CA+55aFz-JUX6CU-aO+cwLHYtH7BA+dgyUnEGoy8T4S62gEDFpA@mail.gmail.com>
	<20141127225637.GA24019@redhat.com>
	<m5dart$co$1@ger.gmane.org>
	<CA+55aFwm4hpyDjJ=GzrahOe2QtuO7im71sPky7U6Rh+18A0X0w@mail.gmail.com>
	<547b8a45.6e608c0a.20f9.1002@mx.google.com>
	<CA+55aFzQ0QZxL-PRnv4Db=wo1pDmBR45P-vpGxyeJnt1DFnSfA@mail.gmail.com>
Organization: http://www.youtube.com/DanielFragaBR
X-Mailer: Claws Mail 3.11.1-9-g1f531c (GTK+ 2.24.25; x86_64-unknown-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 30 Nov 2014 16:21:19 -0800
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> Maybe you'll have to turn off RCU_CPU_STALL_VERBOSE first.
> 
> Although I think you should be able to just edit the .config file,
> delete the like that says
> 
>     CONFIG_TREE_PREEMPT_RCU=y
> 
> and then just do a "make oldconfig", and then verify that
> TREE_PREEMPT_RCU hasn't been re-enabled by some dependency. But it
> shouldn't have, and that "make oldconfig" should get rid of anything
> that depends on TREE_PREEMPT_RCU.
	
	Ok, I did exactly that, but CONFIG_TREE_PREEMPT_RCU is
re-enabled. I talked with Pranith Kumar and he suggested I could just
disable preemption (No Forced Preemption (Server)) and that's the only
way to disable CONFIG_TREE_PREEMPT_RCU.

	Now I'll try to make the system freeze, then I'll send
you the Call trace.

	Thanks.

-- 
Linux 3.17.0: Shuffling Zombie Juror
http://www.youtube.com/DanielFragaBR
http://exchangewar.info
Bitcoin: 12H6661yoLDUZaYPdah6urZS5WiXwTAUgL
