Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752464Ab3CAMQQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 07:16:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:23642 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752180Ab3CAMQP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 07:16:15 -0500
Date: Fri, 1 Mar 2013 07:14:44 -0500
From: Josh Boyer <jwboyer@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Borislav Petkov <bp@alien8.de>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>, mingo@redhat.com,
        tglx@linutronix.de, konrad.wilk@oracle.com, rostedt@goodmis.org,
        gregkh@linuxfoundation.org, samu.kallio@aberdeencloud.com,
        kraman@redhat.com, xen-devel@lists.xen.org,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH] mm/x86: Patch out arch_flush_lazy_mmu_mode() when
 running on bare metal
Message-ID: <20130301121444.GC31649@hansolo.jdub.homelinux.org>
References: <1362092149-32381-1-git-send-email-boris.ostrovsky@oracle.com>
 <20130228233720.GB17468@pd.tnic>
 <20130301000539.GA31649@hansolo.jdub.homelinux.org>
 <512FF331.5050008@zytor.com>
 <20130301003629.GG9767@pd.tnic>
 <20130301004211.GB31649@hansolo.jdub.homelinux.org>
 <512FFBC4.4070400@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <512FFBC4.4070400@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 28, 2013 at 04:52:20PM -0800, H. Peter Anvin wrote:
> On 02/28/2013 04:42 PM, Josh Boyer wrote:
> > On Fri, Mar 01, 2013 at 01:36:29AM +0100, Borislav Petkov wrote:
> >> On Thu, Feb 28, 2013 at 04:15:45PM -0800, H. Peter Anvin wrote:
> >>>> I'll try to get someone to test this tomorrow.
> >>
> >> Btw, you'd need to apply that other patch too
> >>
> >> http://marc.info/?l=xen-devel&m=136206183814547&w=2
> >>
> >> so that arch_flush_lazy_mmu_mode() has at least one caller on x86_64.
> > 
> > Yeah, we already have that applied.  It stops crashes in xen
> > environments so we pulled it in as a bugfix.  Thanks though!
> > 
> 
> Who are "we"?

Sorry, Fedora.  That patch has a link to a bug in it.  We applied the
patch for that bug.  I'll apply Boris' patch on top and get the same
people to test it.

josh
