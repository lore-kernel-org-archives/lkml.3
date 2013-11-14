Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753581Ab3KNLSx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 06:18:53 -0500
Received: from mailout3.w2.samsung.com ([211.189.100.13]:46523 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753195Ab3KNLSv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 06:18:51 -0500
X-AuditID: cbfec372-b7fcc6d0000068fc-ab-5284b19946a2
Date: Thu, 14 Nov 2013 09:18:43 -0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Borislav Petkov <bp@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Doug Thompson <dougthompson@xmission.com>,
        Johannes Thumshirn <johannes.thumshirn@men.de>,
        Robert Richter <rric@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-edac@vger.kernel.org,
        Aristeu Rozanski Filho <arozansk@redhat.com>
Subject: Re: [GIT PULL] mpc85xx_edac changes for 3.13
Message-id: <20131114091843.4bb72afc@samsung.com>
In-reply-to: <20131114092009.GA4960@pd.tnic>
References: <20131112161901.GA15637@jtlinux>
 <CA+55aFzJhyo8bKBchYq0Q=rwPv_-v-xWgOKWxKBcSBycMZcmTg@mail.gmail.com>
 <20131114054750.GA27791@kroah.com> <20131114092009.GA4960@pd.tnic>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-redhat-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKLMWRmVeSWpSXmKPExsVy+t/hQN2ZG1uCDDYs1bVoO/GbzWJiv6bF
	1WVnmSyaF69ns5i8/xKbxYVTDUwWl3fNYbM4uGojk8WjvrfsDpwem1Z1snmcmPGbxWP/3DXs
	Hrv2vGXxeL/vKpvH5tPVHp83yXlMOdTOEsARxWWTkpqTWZZapG+XwJVx8u51toLfehXr/v1g
	bGD8ptLFyMEhIWAi0dAb1cXICWSKSVy4t56ti5GLQ0hgCaPEjzVPGCGcbiaJS49Os4JUsQio
	SnSd62UEsdkEjCReNbaAxUWA7M8vrrCCNDAL3GOS2HD6JztIQljAVOLQtevMIDavgKHE5suX
	weKcAjoSHy82MUNs2MEo0dW8hAniJCeJ3QekIOoFJX5MvscCYjMLaEls3tbECmHLS2xe85Z5
	AqPALCRls5CUzUJStoCReRWjaGlxckFxUnquoV5xYm5xaV66XnJ+7iZGSFQU7WB8tsHqEKMA
	B6MSD2/BzuYgIdbEsuLK3EOMEhzMSiK8rWtbgoR4UxIrq1KL8uOLSnNSiw8xMnFwSjUwJndo
	pLvpnzs40/1yt7QB0+aVf8+yX58ttKw0JOxN0aWj1rvkvMWD/IV2SS45ynT26JnEDy+7b1ex
	vjSap7jnV0j7A+areguvKcU1Tcw6mnb+t1LTNQFPp+1p9fUM295mdNzmF/jCuN4ofOavA5cD
	F5tP09zrxb5V/cwq+YxPtdL6Jh5d/s2SSizFGYmGWsxFxYkAimKA7mgCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, 14 Nov 2013 10:20:10 +0100
Borislav Petkov <bp@suse.de> escreveu:

> On Thu, Nov 14, 2013 at 02:47:50PM +0900, Greg Kroah-Hartman wrote:
> > On Thu, Nov 14, 2013 at 02:41:24PM +0900, Linus Torvalds wrote:
> > > On Wed, Nov 13, 2013 at 1:19 AM, Johannes Thumshirn
> > > <johannes.thumshirn@men.de> wrote:
> > > >
> > > >   git://github.com/morbidrsa/linux.git tags/mpc85xx-edac-for-3.13
> > > 
> > > Ok, it's a signed tag, but I haven't pulled from you before (all the
> > > commits I see seem to have gone through Greg), and I don't recognize
> > > any of the signatures on your tag.
> > > 
> > > That, together with not really knowing the whole edac area, makes me
> > > not wonderfully happy about pulling directly. I a.lso see another edac
> > > pull request in my mailbox, making me suspect that there are
> > > maintainership problems (historically I've been getting the code
> > > either though Greg, Borislav or Mauro). So I'd also like to make sure
> > > that I at least _know_ about any disputes going on in this area?
> > > 
> > > So before I pull this, I'd quickly like to validate the gpg key, and
> > > am cc'ing more people to see if I'm stepping into some political
> > > nightmare. I can be ok with that, but I want to do so knowingly, not
> > > blindly..
> > 
> > I thought Doug was the maintainer of EDAC (now added to the to:), and
> > Mauro has been doing a bunch of work there, while he was at Red Hat.  I
> > haven't taken any EDAC patches in a while since Mauro started cleaning
> > up the area, so I don't know anything about this, sorry.
> 
> Ok, let me try to explain the deal as I see it:
> 
> The original EDAC maintainer was/is Doug. I say is, because he told me
> recently, he wants to get involved and collect stuff again.
> 
> Now, what we have been doing so far in the interim couple of years while
> Doug was away is both Mauro and me have been sending the patches for
> those EDAC drivers each of us maintains directly to Linus. I have also
> been trying to collect stuff for other EDAC drivers and I know Mauro has
> been doing that too, but, at least in my case, I was paying attention
> *not* to step into the role of maintainer for the whole EDAC subsystem.
> 
> Here are my reasons why: Those drivers are for all kinds of arches for
> which I certainly don't have the hardware to test patches on, and, in
> some cases, even the people who wrote them disappear/go do something
> else and thus it is really hard to get someone with the hardware to
> atleast test the patch before I collect it.
> 
> So what I told Robert Richter (he sent you the pull request for
> Calxeda Highbank) and Johannes Thumshirn (who volunteered to maintain
> mpc85xx_edac.* because he has the hardware and needs it for work) was to
> send pull requests straight to Linus.
> 
> In Robert's case, you have him in the chain of trust from previous
> work and since he works for Calxeda now, you basically have the vendor
> maintaining its own driver.
> 
> Johannes I told that he needs to get his key signed by a couple of
> kernel devs but he hasn't had the time to go meet them and do that yet.
> 
> I know what you're gonna say now, you probably would like to pull from
> only 1 or 2 EDAC maintainers tops and not from every driver maintainer.
> 
> I guess we can work with this temporary solution until Doug takes over
> or, if he doesn't, come up with one maintainer who simply funnels stuff
> to you. For example, I could do that but only with the drivers where I
> have people with the hardware who can test and fix bugs - I don't want
> any half-baked patches which fix hearsay bugs or brown-paper bags. I
> certainly don't have the volume to review more involved patches for
> other drivers so if we do this, I'll have to have people who ack them
> and fix them when there's trouble.
> 
> You let me know what you would prefer and we will work something out.

As Boris said, the official maintainer is Doug, but he is not being
active over the last couple years or so.

As I was actively writing new EDAC drivers and needed to rewrite
the core part of the subsystem, in order for it to properly work with
Intel modern memory controllers/CPUs, I was submitting the patches
to you directly. In the beginning, I was waiting for Doug's ack before
doing that. After he stopped answering emails, I kept him c/c for at 
least a couple Kernel versions. After that, I started to just c/c the
Mailing lists.

I also took the care to not step on Boris, with actively maintains the
amd64_edac driver. So, I only applied on my tree patches from the
AMD64 EDAC driver with his ack.

So, in practice, Borislav was working as a maintainer for amd64 EDAC
patches, and I working mainly as Intel EDAC maintainer. The (few) other
arm EDAC patches were either coming via my tree or via Boris tree,
depending on who got them first.

That's said, while working at Red Hat, I had access to a large number of
different hardware. So, I was capable of testing the changes on most x86
hardware supported. I also wrote some testing procedures while there, in
order to use Red Hat lab to test EDAC on all hardware that supports EDAC
we found there. Several bugs were corrected on those drivers due to that.

Nowadays, I'm still actively maintaining an userspace counterpart of the
EDAC subsystem[1], but I have access to just one hardware (a Sandy Bridge
Xeon machine). Currently, I'm not working on any new EDAC driver, although
I expect to have some new EDAC projects for the next year.

[1] https://git.fedorahosted.org/git/rasdaemon.git

Also, Aristeu asked me this week to merge some Ivy Bridge EDAC patches he
submitted in the past to the EDAC ML on my tree and forward them to you.

So, if you want, I can review the pending EDAC patches, apply them on
my tree and sending you a pull request, working as a maintainer, while
we don't have some full time maintainer for it.

Regards,
Mauro
