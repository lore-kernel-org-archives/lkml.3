Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751560AbaBGI5F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 03:57:05 -0500
Received: from www.linutronix.de ([62.245.132.108]:41255 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077AbaBGI5D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 03:57:03 -0500
Date: Fri, 7 Feb 2014 09:57:01 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Mike Galbraith <bitbucket@online.de>
Cc: linux-rt-users <linux-rt-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, rostedt@goodmis.org,
        John Kacur <jkacur@redhat.com>
Subject: Re: [ANNOUNCE] 3.12.9-rt13
Message-ID: <20140207085701.GB23668@linutronix.de>
References: <20140203194841.GA17108@linutronix.de>
 <1391526218.5532.33.camel@marge.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1391526218.5532.33.camel@marge.simpson.net>
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Mike Galbraith | 2014-02-04 16:03:38 [+0100]:

>On Mon, 2014-02-03 at 20:48 +0100, Sebastian Andrzej Siewior wrote:
>
>> Known issues:
>
>> Mike said that it caused two of his 64 CPUs to spin for five minutes
>>         doing nothing. Therefore it is disabled in the queue. Everyone
>>         who wants test it may do so :)
>
>I put rt13 on an 8 socket Opetron (48 core) box, with patch enabled.  It
>box did NOT reproduce the hangs the 8 socket (1 node, bleh) DL980 did.
>
>Nor did it explode running hotplug stress, but then it deadlocks before
>BOOM would have happened on the DL980.  kdump isn't working properly on
>this box (not an rt issue, userspace), so..

Okay, so this is at some point good news. Thank you.

>-Mike

Sebastian
