Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754197Ab3F0Spx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 14:45:53 -0400
Received: from mail-yh0-f44.google.com ([209.85.213.44]:55675 "EHLO
	mail-yh0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751535Ab3F0Spt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 14:45:49 -0400
Date: Thu, 27 Jun 2013 11:45:41 -0700
From: Tejun Heo <tj@kernel.org>
To: Serge Hallyn <serge.hallyn@ubuntu.com>
Cc: Mike Galbraith <bitbucket@online.de>, Tim Hockin <thockin@hockin.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Containers <containers@lists.linux-foundation.org>,
        Kay Sievers <kay.sievers@vrfy.org>, lpoetter <lpoetter@redhat.com>,
        workman-devel <workman-devel@redhat.com>,
        jpoimboe <jpoimboe@redhat.com>,
        "dhaval.giani" <dhaval.giani@gmail.com>,
        Cgroups <cgroups@vger.kernel.org>
Subject: Re: cgroup: status-quo and userland efforts
Message-ID: <20130627184541.GA6400@mtj.dyndns.org>
References: <20130422214159.GG12543@htj.dyndns.org>
 <CAAAKZwuXJwwyj7KSqb7rZ+nrTwBWEaUCWfa7kWecTBnHL8koGw@mail.gmail.com>
 <CAAAKZwvP_7wBBYMmtFuiE2hZt=ByaLrnTyiR83CZr3OMip63Gg@mail.gmail.com>
 <20130625000118.GT1918@mtj.dyndns.org>
 <CAAAKZwt09k-qUwLCnMpAQeYJ-S0XtkjXe4=bJ-G_fcrkAqEzoA@mail.gmail.com>
 <20130626212047.GB4536@htj.dyndns.org>
 <1372311907.5871.78.camel@marge.simpson.net>
 <20130627132206.GE4003@sergelap>
 <20130627174850.GC5599@mtj.dyndns.org>
 <20130627181457.GB26334@sergelap>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130627181457.GB26334@sergelap>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Serge.

On Thu, Jun 27, 2013 at 01:14:57PM -0500, Serge Hallyn wrote:
> I should find a good, up-to-date summary of the current behaviors of
> each controller so I can talk more intelligently about it.  (I'll
> start by looking at the kernel Documentation/cgroups, but don't
> feel too confident that they'll be uptodate :)

Heh, it's hopelessly outdated.  Sorry about that.  I'll get around to
updating it eventually.  Right now everything is in flux.

> Right,  I'm not attached to my toy implementation at all - except for
> the ability, in some fashion, to have nested agents which don't have
> cgroupfs access but talk to another agent to get the job done.

I think it probably would be better to allow organization and RO
access to knobs and stat files inside containers, for lower overhead,
if nothing else, and have comm channel for operations which need
supervision at a wider level.

Thanks.

-- 
tejun
