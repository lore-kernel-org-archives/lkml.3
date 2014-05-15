Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755192AbaEORGU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 13:06:20 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53397 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754549AbaEORGP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 13:06:15 -0400
Date: Thu, 15 May 2014 19:06:11 +0200
From: chrubis@suse.cz
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        Darren Hart <dvhart@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Jakub Jelinek <jakub@redhat.com>,
        "linux-man@vger.kernel.org" <linux-man@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Arnd Bergmann <arnd@arndb.de>, Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Linux API <linux-api@vger.kernel.org>,
        "Carlos O'Donell" <carlos@redhat.com>
Subject: Re: futex(2) man page update help request
Message-ID: <20140515170611.GA8428@rei.Home>
References: <CF98E3EF.90564%dvhart@linux.intel.com>
 <537407ED.8050606@zytor.com>
 <CF999CD6.90A93%dvhart@linux.intel.com>
 <5374C54B.7040408@gmail.com>
 <20140515154246.GC6926@rei.Home>
 <5374E2A4.2070408@zytor.com>
 <20140515160152.GA7529@rei.Home>
 <5374E653.2080309@zytor.com>
 <20140515161753.GA7959@rei.Home>
 <5374F1B3.9080006@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5374F1B3.9080006@zytor.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!
> > That is not the main concern here. If I extract the code I would have to
> > watch for any changes manually. If it was in a library or a separate
> > repository all that would be needed is to add it as dependency/git
> > submodule and I would get all updates automatically.
> > 
> 
> Yes, and for that to happen someone needs to do the work to extract it.
>  I don't have the cycles myself at the moment.

If that is the only problem, I should be able to allocate some time in
order to have a look at it.

-- 
Cyril Hrubis
chrubis@suse.cz
