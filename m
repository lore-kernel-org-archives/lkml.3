Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755163AbaJ1NjE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 09:39:04 -0400
Received: from mail.mandriva.com.br ([177.220.134.171]:51398 "EHLO
	mail.mandriva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753266AbaJ1NjC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 09:39:02 -0400
X-Greylist: delayed 441 seconds by postgrey-1.27 at vger.kernel.org; Tue, 28 Oct 2014 09:39:02 EDT
Date: Tue, 28 Oct 2014 11:31:31 -0200
From: Marco A Benatto <marco.benatto@mandriva.com.br>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Timofey Titovets <nefelim4ag@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: UKSM: What's maintainers think about it?
Message-ID: <20141028133131.GA1445@sirus.conectiva>
References: <CAGqmi77uR2Nems6fE_XM1t3a06OwuqJP-0yOMOQh7KH13vzdzw@mail.gmail.com>
 <20141025213201.005762f9.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141025213201.005762f9.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

I'm not mantainer at all, but I've being using UKSM for a long time and remember
to port it to 3.16 family once.
UKSM seems good and stable and, at least for me, doesn't raised any errors.
AFAIK the only limitation I know (maybe I has been fixed already) it isn't able
to work together with zram stuff due to some race-conditions.

Cheers,

Marco A Benatto
Mandriva OEM Developer


On Sat, Oct 25, 2014 at 09:32:01PM -0700, Andrew Morton wrote:
> On Sat, 25 Oct 2014 22:25:56 +0300 Timofey Titovets <nefelim4ag@gmail.com> wrote:
> 
> > Good time of day, people.
> > I try to find 'mm' subsystem specific people and lists, but list
> > linux-mm looks dead and mail archive look like deprecated.
> > If i must to sent this message to another list or add CC people, let me know.
> 
> linux-mm@kvack.org is alive and well.
> 
> > If questions are already asked (i can't find activity before), feel
> > free to kick me.
> > 
> > The main questions:
> > 1. Somebody test it? I see many reviews about it.
> > I already port it to latest linux-next-git kernel and its work without issues.
> > http://pastebin.com/6FMuKagS
> > (if it matter, i can describe use cases and results, if somebody ask it)
> > 
> > 2. Developers of UKSM already tried to merge it? Somebody talked with uksm devs?
> > offtop: now i try to communicate with dev's on kerneldedup.org forum,
> > but i have problems with email verification and wait admin
> > registration approval.
> > (i already sent questions to
> > http://kerneldedup.org/forum/home.php?mod=space&username=xianai ,
> > because him looks like team leader)
> > 
> > 3. I just want collect feedbacks from linux maintainers team, if you
> > decide what UKSM not needed in kernel, all other comments (as i
> > understand) not matter.
> > 
> > Like KSM, but better.
> > UKSM - Ultra Kernel Samepage Merging
> > http://kerneldedup.org/en/projects/uksm/introduction/
> 
> It's the first I've heard of it.  No, as far as I know there has been
> no attempt to upstream UKSM.
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
