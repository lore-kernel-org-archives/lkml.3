Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753259AbaHKKUJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 06:20:09 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36076 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752710AbaHKKUH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 06:20:07 -0400
Date: Mon, 11 Aug 2014 12:19:16 +0200
From: chrubis@suse.cz
To: Darren Hart <dvhart@linux.intel.com>
Cc: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
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
Message-ID: <20140811101916.GA17310@rei.suse.cz>
References: <537346E5.4050407@gmail.com>
 <CF98E3EF.90564%dvhart@linux.intel.com>
 <20140515152834.GA6926@rei.Home>
 <CF9A3521.90ECC%dvhart@linux.intel.com>
 <20140515163004.GB7959@rei.Home>
 <CF9A3A75.90F40%dvhart@linux.intel.com>
 <20140515190529.GA8887@rei.Home>
 <CF9A658E.91322%dvhart@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CF9A658E.91322%dvhart@linux.intel.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!
> >> How much LTP harness type code needs to be used?
> >
> >Not much.
> >
> >For this complexity of tests you would just need to call the tst_resm()
> >interface to report success/failure and, at the end of the test,
> >tst_exit() to return the stored overall test status.
> >
> >And ideally call the standard option parsing code and call the test in
> >standard loop so that the test can take advantage of standard options as
> >number of iterations to run, etc.
> >
> >Have a look at:
> >
> >https://github.com/linux-test-project/ltp/wiki/Test-Writing-Guidelines
> >
> >there is simple test example as well as description of the interfaces.
> 
> 
> Thanks Cyril,
> 
> I'll follow up with you in a couple weeks most likely. I have some urgent
> things that will be taking all my time and then some until then. Feel free
> to poke me though if I lose track of it :-)

Ping :)

-- 
Cyril Hrubis
chrubis@suse.cz
