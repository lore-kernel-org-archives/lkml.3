Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933448Ab3CUOIi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 10:08:38 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:29534 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758357Ab3CUOIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 10:08:36 -0400
Date: Thu, 21 Mar 2013 10:07:57 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Josh Boyer <jwboyer@redhat.com>, stefan.bader@canonical.com
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        mingo@redhat.com, tglx@linutronix.de, rostedt@goodmis.org,
        gregkh@linuxfoundation.org, samu.kallio@aberdeencloud.com,
        kraman@redhat.com, xen-devel@lists.xen.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] mm/x86: Patch out arch_flush_lazy_mmu_mode() when
 running on bare metal
Message-ID: <20130321140757.GC28648@phenom.dumpdata.com>
References: <1362092149-32381-1-git-send-email-boris.ostrovsky@oracle.com>
 <20130228233720.GB17468@pd.tnic>
 <20130301000539.GA31649@hansolo.jdub.homelinux.org>
 <512FF331.5050008@zytor.com>
 <20130301003629.GG9767@pd.tnic>
 <20130301004211.GB31649@hansolo.jdub.homelinux.org>
 <512FFBC4.4070400@zytor.com>
 <20130301121444.GC31649@hansolo.jdub.homelinux.org>
 <51407E58.8020200@oracle.com>
 <20130313134442.GE7718@hansolo.jdub.homelinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130313134442.GE7718@hansolo.jdub.homelinux.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 13, 2013 at 09:44:43AM -0400, Josh Boyer wrote:
> On Wed, Mar 13, 2013 at 09:25:44AM -0400, Boris Ostrovsky wrote:
> > On 03/01/2013 07:14 AM, Josh Boyer wrote:
> > >On Thu, Feb 28, 2013 at 04:52:20PM -0800, H. Peter Anvin wrote:
> > >>On 02/28/2013 04:42 PM, Josh Boyer wrote:
> > >>>On Fri, Mar 01, 2013 at 01:36:29AM +0100, Borislav Petkov wrote:
> > >>>>On Thu, Feb 28, 2013 at 04:15:45PM -0800, H. Peter Anvin wrote:
> > >>>>>>I'll try to get someone to test this tomorrow.
> > >>>>Btw, you'd need to apply that other patch too
> > >>>>
> > >>>>http://marc.info/?l=xen-devel&m=136206183814547&w=2
> > >>>>
> > >>>>so that arch_flush_lazy_mmu_mode() has at least one caller on x86_64.
> > >>>Yeah, we already have that applied.  It stops crashes in xen
> > >>>environments so we pulled it in as a bugfix.  Thanks though!
> > >>>
> > >>Who are "we"?
> > >Sorry, Fedora.  That patch has a link to a bug in it.  We applied the
> > >patch for that bug.  I'll apply Boris' patch on top and get the same
> > >people to test it.
> > 
> > Josh, have you had a chance to test this?
> 
> I've tested it on bare metal for a while now.  No problems noticed at
> all.  I've not heard back from Krishna who was testing it in the Xen
> environment.  Krishna?

Roping in Stephan from Canonical as they are seeing it on a regular basis
and is affecting their distro.

Stephan - there are two patches for it - the paravirt of lazy_mmu mode
and then the other one.

This thread should provide the right URLs (I hope). Could you (if it is possible)
try them out and see if they fix the issue?

> 
> josh
