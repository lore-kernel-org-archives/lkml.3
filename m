Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754643AbaDNOOg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 10:14:36 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34347 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754332AbaDNOOe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 10:14:34 -0400
Date: Mon, 14 Apr 2014 16:14:29 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Richard Weinberger <richard@nod.at>, Alexander.Kleinsorge@gmx.de
cc: andi@firstfloor.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: new module to check constant memory for corruption
In-Reply-To: <534ABEB2.7050506@nod.at>
Message-ID: <alpine.LRH.2.00.1404141613080.3839@twin.jikos.cz>
References: <trinity-aef9715a-72d2-4824-a3d8-306d5850c633-1397352790457@3capp-gmx-bs18> <87eh12hr1t.fsf@tassilo.jf.intel.com> <trinity-516ff83e-4833-4dad-856a-dd0597993837-1397384072115@3capp-gmx-bs62>, <CAFLxGvyiVaONh61j7z1s6u15f0Uz-Yb3Js0Vk9C2WiB6OR4yKA@mail.gmail.com>
 <trinity-99a290b9-30fa-464e-b67b-b8555d48011b-1397406377024@3capp-gmx-bs45> <534ABEB2.7050506@nod.at>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 13 Apr 2014, Richard Weinberger wrote:

> > Hi Richard,
> > 
> > I updated my code and check for ftrace (cat /proc/sys/kernel/ftrace_enabled > 0).
> > http://tauruz.homeip.net/ramcheck.tgz
> > 
> > On a 24/7 server ftrace is not a common thing anyway.
> 
> I disagree with you.
> perf, systemtap and other tools are widely used on "24/7" servers.

Plus the self-modifying code is present in other parts of kernel that have 
nothing to do with tracing as well. Consider static keys for example; they 
are used heavily in networking stack, scheduler code, etc.

-- 
Jiri Kosina
SUSE Labs

