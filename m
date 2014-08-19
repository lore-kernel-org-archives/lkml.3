Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751830AbaHSXoE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 19:44:04 -0400
Received: from one.firstfloor.org ([193.170.194.197]:48364 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478AbaHSXoC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 19:44:02 -0400
Date: Wed, 20 Aug 2014 01:43:59 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Andi Kleen <andi@firstfloor.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-kbuild@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>,
        Artem Bityutskiy <dedekind1@gmail.com>
Subject: Re: Overriding -Werror
Message-ID: <20140819234359.GJ4120@two.firstfloor.org>
References: <20140814222119.GD18411@ld-irv-0074>
 <87ppfwmxic.fsf@tassilo.jf.intel.com>
 <20140819201129.GA24217@ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140819201129.GA24217@ravnborg.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 19, 2014 at 10:11:30PM +0200, Sam Ravnborg wrote:
> On Tue, Aug 19, 2014 at 06:15:07AM -0700, Andi Kleen wrote:
> > Brian Norris <computersforpeace@gmail.com> writes:
> > >
> > > 4. better ideas?
> > 
> > Just send patches to remove -Werror in all architectures
> > as a tree sweep (and anywhere else where someone misguided add it)
> In arch/sparc/ we have -Werror and this has never troubled us.
> In fact more than once people had tried to provide sloppy code that
> failed due to -Werror so it got fixed up front.

It's a major mistake to not support future gccs for released source.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
