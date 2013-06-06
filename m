Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757571Ab3FFD00 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 23:26:26 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:59744 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756667Ab3FFD0Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 23:26:24 -0400
Message-ID: <1370489181.24311.318.camel@edumazet-glaptop>
Subject: Re: stop_machine lockup issue in 3.9.y.
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Ben Greear <greearb@candelatech.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Joe Lawrence <joe.lawrence@stratus.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org, "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>,
        Jouni Malinen <jouni@qca.qualcomm.com>,
        Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>,
        Senthil Balasubramanian <senthilb@qca.qualcomm.com>,
        linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
Date: Wed, 05 Jun 2013 20:26:21 -0700
In-Reply-To: <20130606031444.GA12335@mtj.dyndns.org>
References: <51AE27D5.7050202@candelatech.com>
	 <87sj0xry1k.fsf@rustcorp.com.au> <20130605071539.GA3429@mtj.dyndns.org>
	 <51AF6E54.3050108@candelatech.com> <20130605184807.GD10693@mtj.dyndns.org>
	 <51AF8D4B.4090407@candelatech.com> <51AF91F5.6090801@candelatech.com>
	 <51AFA677.9010605@candelatech.com> <20130605211157.GK10693@mtj.dyndns.org>
	 <1370482492.24311.308.camel@edumazet-glaptop>
	 <20130606031444.GA12335@mtj.dyndns.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-06-05 at 20:14 -0700, Tejun Heo wrote:

> 
> Ah, so, that's why it's showing up now.  We probably have had the same
> issue all along but it used to be masked by the softirq limiting.  Do
> you care to revive the 10 iterations limit so that it's limited by
> both the count and timing?  We do wanna find out why softirq is
> spinning indefinitely tho.

Yes, no problem, I can do that.

