Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752947Ab3KNJUr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 04:20:47 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39926 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751437Ab3KNJUl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 04:20:41 -0500
Date: Thu, 14 Nov 2013 10:20:10 +0100
From: Borislav Petkov <bp@suse.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: Doug Thompson <dougthompson@xmission.com>,
        Johannes Thumshirn <johannes.thumshirn@men.de>,
        Borislav Petkov <bp@suse.de>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Robert Richter <rric@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-edac@vger.kernel.org
Subject: Re: [GIT PULL] mpc85xx_edac changes for 3.13
Message-ID: <20131114092009.GA4960@pd.tnic>
References: <20131112161901.GA15637@jtlinux>
 <CA+55aFzJhyo8bKBchYq0Q=rwPv_-v-xWgOKWxKBcSBycMZcmTg@mail.gmail.com>
 <20131114054750.GA27791@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20131114054750.GA27791@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 14, 2013 at 02:47:50PM +0900, Greg Kroah-Hartman wrote:
> On Thu, Nov 14, 2013 at 02:41:24PM +0900, Linus Torvalds wrote:
> > On Wed, Nov 13, 2013 at 1:19 AM, Johannes Thumshirn
> > <johannes.thumshirn@men.de> wrote:
> > >
> > >   git://github.com/morbidrsa/linux.git tags/mpc85xx-edac-for-3.13
> > 
> > Ok, it's a signed tag, but I haven't pulled from you before (all the
> > commits I see seem to have gone through Greg), and I don't recognize
> > any of the signatures on your tag.
> > 
> > That, together with not really knowing the whole edac area, makes me
> > not wonderfully happy about pulling directly. I a.lso see another edac
> > pull request in my mailbox, making me suspect that there are
> > maintainership problems (historically I've been getting the code
> > either though Greg, Borislav or Mauro). So I'd also like to make sure
> > that I at least _know_ about any disputes going on in this area?
> > 
> > So before I pull this, I'd quickly like to validate the gpg key, and
> > am cc'ing more people to see if I'm stepping into some political
> > nightmare. I can be ok with that, but I want to do so knowingly, not
> > blindly..
> 
> I thought Doug was the maintainer of EDAC (now added to the to:), and
> Mauro has been doing a bunch of work there, while he was at Red Hat.  I
> haven't taken any EDAC patches in a while since Mauro started cleaning
> up the area, so I don't know anything about this, sorry.

Ok, let me try to explain the deal as I see it:

The original EDAC maintainer was/is Doug. I say is, because he told me
recently, he wants to get involved and collect stuff again.

Now, what we have been doing so far in the interim couple of years while
Doug was away is both Mauro and me have been sending the patches for
those EDAC drivers each of us maintains directly to Linus. I have also
been trying to collect stuff for other EDAC drivers and I know Mauro has
been doing that too, but, at least in my case, I was paying attention
*not* to step into the role of maintainer for the whole EDAC subsystem.

Here are my reasons why: Those drivers are for all kinds of arches for
which I certainly don't have the hardware to test patches on, and, in
some cases, even the people who wrote them disappear/go do something
else and thus it is really hard to get someone with the hardware to
atleast test the patch before I collect it.

So what I told Robert Richter (he sent you the pull request for
Calxeda Highbank) and Johannes Thumshirn (who volunteered to maintain
mpc85xx_edac.* because he has the hardware and needs it for work) was to
send pull requests straight to Linus.

In Robert's case, you have him in the chain of trust from previous
work and since he works for Calxeda now, you basically have the vendor
maintaining its own driver.

Johannes I told that he needs to get his key signed by a couple of
kernel devs but he hasn't had the time to go meet them and do that yet.

I know what you're gonna say now, you probably would like to pull from
only 1 or 2 EDAC maintainers tops and not from every driver maintainer.

I guess we can work with this temporary solution until Doug takes over
or, if he doesn't, come up with one maintainer who simply funnels stuff
to you. For example, I could do that but only with the drivers where I
have people with the hardware who can test and fix bugs - I don't want
any half-baked patches which fix hearsay bugs or brown-paper bags. I
certainly don't have the volume to review more involved patches for
other drivers so if we do this, I'll have to have people who ack them
and fix them when there's trouble.

You let me know what you would prefer and we will work something out.

Thanks!

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
