Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759865AbaGYJ2N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 05:28:13 -0400
Received: from ud10.udmedia.de ([194.117.254.50]:44169 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818AbaGYJ2L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 05:28:11 -0400
X-Greylist: delayed 396 seconds by postgrey-1.27 at vger.kernel.org; Fri, 25 Jul 2014 05:28:11 EDT
Date: Fri, 25 Jul 2014 11:21:27 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Michel =?iso-8859-1?Q?D=E4nzer?= <michel@daenzer.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Jakub Jelinek <jakub@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Ingo Molnar <mingo@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Random panic in load_balance() with 3.16-rc
Message-ID: <20140725092127.GA295@x4>
References: <CA+55aFyFT9n5wUNifEHY6+t2bEcD91kL7+dqXuBMSMJvLeDDJQ@mail.gmail.com>
 <20140723184111.GG3935@laptop>
 <CA+55aFwQfwfAP6U77_nD_mSvoygj=cZ09N644hKRtzgLnEqhZQ@mail.gmail.com>
 <20140723190230.GH3935@laptop>
 <CA+55aFyM1wqTLK0m4GQJ28f=z0iZE87=xk+1z-vm+PH1_d8nKw@mail.gmail.com>
 <53D064C7.5050807@daenzer.net>
 <CA+55aFyJhqiPv0kQ+51=Ei-zaAO+0JszxtnEyx-Gbto3SE00xw@mail.gmail.com>
 <20140725064836.GE2397@laptop.redhat.com>
 <CA+55aFyrNZ1EHyjfi6VCLHtERCqqL2b=CwZ542nR_xBYouvmfw@mail.gmail.com>
 <53D21D6C.2050406@daenzer.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <53D21D6C.2050406@daenzer.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014.07.25 at 18:03 +0900, Michel Dänzer wrote:
> On 25.07.2014 17:15, Linus Torvalds wrote:
> > On Thu, Jul 24, 2014 at 11:48 PM, Jakub Jelinek <jakub@redhat.com> wrote:
> >>
> >> Can I ask anyone involved in this for preprocessed source and all gcc command
> >> line options to reproduce it, best in the form of a http://gcc.gnu.org/bugzilla/
> >> bugreport?
> > 
> > I've created bug 61904 for this:
> > 
> >   https://gcc.gnu.org/bugzilla/show_bug.cgi?id=61904
> > 
> > Note that I don't personally have a reproducer (my machine has
> > gcc-4.8.3, and I don't see the same behavior), but I included the
> > incorrect fair.s file that Michel sent me (which has all the command
> > line options in it), and a pre-processed "fair.i" source file that I
> > generated and that *should* match the configuration that was the
> > source for that result. So there might be some version/configuration
> > skew there between the two files, but I think they match.
> 
> Thank you Linus for tracking down the problem and filing the bug report!
> I would have done the latter as well, but I could only have channeled
> your analysis anyway. :)
> 
> 
> > Holler if you cannot reproduce the problem based on that.
> 
> Likewise. I can create a GCC bugzilla account and add myself to the CC
> list if that helps.
> 
> FWIW though, the fair.i file you attached is basically identical to what
> I'm getting, the only difference being a handful of file path strings.

Unfortunately I cannot reproduce the issue. Please post your complete
compiler invocation while also adding -v to the options.

-- 
Markus
