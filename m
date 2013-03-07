Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759218Ab3CGQHe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 11:07:34 -0500
Received: from www.linutronix.de ([62.245.132.108]:49866 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049Ab3CGQHd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 11:07:33 -0500
Date: Thu, 7 Mar 2013 17:07:25 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Tejun Heo <tj@kernel.org>
cc: Lei Wen <adrian.wenl@gmail.com>, linux-kernel@vger.kernel.org,
        leiwen@marvell.com, wwang27@marvell.com
Subject: Re: workqueue panic in 3.4 kernel
In-Reply-To: <20130307154907.GB29601@htj.dyndns.org>
Message-ID: <alpine.LFD.2.02.1303071705310.22263@ionos>
References: <CALZhoSR0+SzPLHzJafmny=o8PJ2d7MaH9N6_6s0QZ_oCQm43Xg@mail.gmail.com> <20130305163228.GA12795@htj.dyndns.org> <CALZhoSRyjRYVcKpq9cECHWgKkci6V+O_zn2CkiwqnFo57tZDfQ@mail.gmail.com> <20130306191408.GN1227@htj.dyndns.org>
 <CALZhoSTPBNjhUP4R=vX0Ot7eAA8POTAy8K5Cd3KRe_y8PzjfFA@mail.gmail.com> <CALZhoSRJ+HV93tDJo-57M-SdXi8Z6qW_bRV9FzSfGWuz8j-t8Q@mail.gmail.com> <20130307154907.GB29601@htj.dyndns.org>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Mar 2013, Tejun Heo wrote:
> I can't see how something like that would happen and still find it
> quite unlikely this would be a generic problem in either timer or
> workqueue given how widely those are used and your case is the only
> similar case that came up till now (and 3.4 is a long time ago).
> Thomas, any ideas?

debugobjects might give a hint.

Thanks,

	tglx
