Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752746AbaBKQ2Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 11:28:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:65040 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751585AbaBKQ2V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 11:28:21 -0500
Date: Tue, 11 Feb 2014 17:27:21 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: poma <pomidorabelisima@gmail.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-pm@vger.kernel.org, Olaf Hering <olaf@aepfle.de>,
        Dave Jones <davej@redhat.com>, "Justin M. Forbes" <jforbes@redhat.com>,
        Josh Boyer <jwboyer@redhat.com>,
        Mailing-List fedora-kernel <kernel@lists.fedoraproject.org>
Subject: Re: WARNING: CPU: 1 PID: 0 at kernel/time/tick-broadcast.c:668
 tick_broadcast_oneshot_control+0x17d/0x190()
Message-ID: <20140211162720.GA3729@redhat.com>
References: <52F84A9B.5020008@gmail.com>
 <alpine.DEB.2.02.1402101056260.21991@ionos.tec.linutronix.de>
 <52F9219B.5020003@gmail.com>
 <20140211082306.GA1528@redhat.com>
 <alpine.DEB.2.02.1402111702090.21991@ionos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1402111702090.21991@ionos.tec.linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > I came with a below patch, which also clear pending mask, but perhaps
> 
> Fun. I came up with the exact same solution independent of you and I
> tested it on real C1E contaminated hardware.
> 
> > oneshot_mask should not be cleared on tick_broadcast_setup_oneshot(),
> > or should be cleared only conditionally, or some other solution is
> 
> We can do it unconditionally. It creates consistent state in all
> corner cases.
> 
> There are other solutions to the problem, but that needs a major
> rework of the broadcast code. I so wish that this mess would have
> never been necessary at all ...

Thomas, please post/apply patch, which you think is the most
appropriate.

Thanks
Stanislaw
