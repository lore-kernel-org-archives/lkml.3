Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932781AbaLBQ6s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 11:58:48 -0500
Received: from mail-qa0-f53.google.com ([209.85.216.53]:60923 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932303AbaLBQ6p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 11:58:45 -0500
Message-ID: <547defc3.28568c0a.73eb.1a1e@mx.google.com>
Date: Tue, 2 Dec 2014 14:58:38 -0200
From: =?UTF-8?B?RMOibmllbA==?= Fraga <fragabr@gmail.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: frequent lockups in 3.18rc4
In-Reply-To: <547D7B05.6080403@cn.fujitsu.com>
References: <CA+55aFy9c2FY2gDw14VU537QJoLHAbf+q_75VUwU33_HLz+F0w@mail.gmail.com>
	<20141126024032.GA13246@redhat.com>
	<20141126225745.GA30346@redhat.com>
	<CA+55aFz-JUX6CU-aO+cwLHYtH7BA+dgyUnEGoy8T4S62gEDFpA@mail.gmail.com>
	<20141127225637.GA24019@redhat.com>
	<m5dart$co$1@ger.gmane.org>
	<CA+55aFwm4hpyDjJ=GzrahOe2QtuO7im71sPky7U6Rh+18A0X0w@mail.gmail.com>
	<547b8a45.6e608c0a.20f9.1002@mx.google.com>
	<CA+55aFzQ0QZxL-PRnv4Db=wo1pDmBR45P-vpGxyeJnt1DFnSfA@mail.gmail.com>
	<547bbe36.48548c0a.105c.779c@mx.google.com>
	<20141201191431.GA17385@linux.vnet.ibm.com>
	<547D7B05.6080403@cn.fujitsu.com>
Organization: http://www.youtube.com/DanielFragaBR
X-Mailer: Claws Mail 3.11.1-9-g1f531c (GTK+ 2.24.25; x86_64-unknown-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Dec 2014 16:40:37 +0800
Lai Jiangshan <laijs@cn.fujitsu.com> wrote:

> It is needed at lest for testing.
> 
> CONFIG_TREE_PREEMPT_RCU=y with CONFIG_PREEMPT=n is needed for testing too.
> 
> Please enable them (or enable them under CONFIG_RCU_TRACE=y)

	Lai, sorry but I didn't understand. Do you mean both of them
enabled? Because how can CONFIG_TREE_PREEMPT_RCU be enabled without
CONFIG_PREEMPT ?

	If you mean both enabled, I already reported a call trace with
both enabled:

https://bugzilla.kernel.org/show_bug.cgi?id=85941

	Please see my previous answer to Linus and Paul too.

	Regarding CONFIG_RCU_TRACE, do you mean
"CONFIG_TREE_RCU_TRACE"? I couldn't find CONFIG_RCU_TRACE.

	Thanks.

-- 
Linux 3.17.0-dirty: Shuffling Zombie Juror
http://www.youtube.com/DanielFragaBR
http://exchangewar.info
Bitcoin: 12H6661yoLDUZaYPdah6urZS5WiXwTAUgL
