Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751553Ab3HAHE0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 03:04:26 -0400
Received: from mail-ea0-f178.google.com ([209.85.215.178]:40958 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756Ab3HAHEZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 03:04:25 -0400
Date: Thu, 1 Aug 2013 09:04:21 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Rik van Riel <riel@redhat.com>, Paul Turner <pjt@google.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        jmario@redhat.com, Peter Anvin <hpa@zytor.com>, dzickus@redhat.com,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH -v2] sched,x86: optimize switch_mm for multi-threaded
 workloads
Message-ID: <20130801070421.GA22998@gmail.com>
References: <CA+55aFx3ZHZrgP3yQwb=ttYUeH1zFVQtUA5dFW1h8FPhjfKgUA@mail.gmail.com>
 <51F98CAB.80100@redhat.com>
 <CA+55aFwj+6P4y8MgGTGbiK_EtfY7LJ_bL_7k9zFYLx4S8F0rJQ@mail.gmail.com>
 <51F99218.4060104@redhat.com>
 <CA+55aFxKSEHSkdsCkTvjwwo4MnEpN0TwJrek2jd1QJCyUTb-=Q@mail.gmail.com>
 <51F999DE.7080200@redhat.com>
 <CAPM31R+BiTiLbNrD+33q31z8Ww7dpm7t1vcLak-hZ-z5L2PY-g@mail.gmail.com>
 <CA+55aFwTNQFFJbeP4bYuMBREq=n6GU2vV71ftr_7OnE6SK5OSw@mail.gmail.com>
 <20130731221421.616d3d20@annuminas.surriel.com>
 <CA+55aFzsUhBU2S_GmwYicttnf5MM1Z723xZ9UgYCi5kr8psYEQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzsUhBU2S_GmwYicttnf5MM1Z723xZ9UgYCi5kr8psYEQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Wed, Jul 31, 2013 at 7:14 PM, Rik van Riel <riel@redhat.com> wrote:
> >
> > Is this better?  Not that I really care which version gets applied :)
> 
> I'm ok with this.
> 
> That said, I'm assuming this goes in through Ingo, since it is both
> x86 and scheduler-related. I can take it directly, but see no real
> reason to. Ingo?

Yeah, I'm picking it up.

Thanks,

	Ingo
