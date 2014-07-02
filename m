Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753517AbaGBWBb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 18:01:31 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:54945 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752780AbaGBWBa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 18:01:30 -0400
Date: Thu, 3 Jul 2014 00:01:21 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Borislav Petkov <bp@alien8.de>
Cc: Prarit Bhargava <prarit@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: RFC: /proc/cpuinfo confusion with AMD processors
Message-ID: <20140702220121.GA17963@xo-6d-61-c0.localdomain>
References: <53B15D27.9010306@redhat.com>
 <20140630131309.GA5199@pd.tnic>
 <53B16621.50505@redhat.com>
 <20140630133803.GE4766@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140630133803.GE4766@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2014-06-30 15:38:03, Borislav Petkov wrote:
> On Mon, Jun 30, 2014 at 09:29:05AM -0400, Prarit Bhargava wrote:
> > Yes, I get that. But this doesn't uniquely identify *which* processor
> > it is.
> 
> What do you mean, which processor it is? You want to know which
> processor on the motherboard, physically? When you look at the mobo and
> if all is enumerated regularly and you have a, say, two socket system
> with the processors above, to be able to say that processor 31 is the
> 16th core on the second node on the motherboard? Something like that?

I'd say so. Some machines support physical cpu hotplug, and it would
be useful to know which cpu you are plugging out...

(For example if you want to pull out / replace the cpu that has problems...
Or maybe more realistically you want to offline a CPU so that you
can replace a noisy CPU fan.)
								Pavel	
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
