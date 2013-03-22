Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422971Ab3CVU2U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 16:28:20 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49012 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422915Ab3CVU2Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 16:28:16 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <20130322200941.GB6189@phenom.dumpdata.com>
References: <5afe14ac-bc17-4fd1-9680-8f2566322437@default> <20130321000845.GC15821@hansolo.jdub.homelinux.org> <20130322200941.GB6189@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] mm/x86: Patch out arch_flush_lazy_mmu_mode() when running on bare metal
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Fri, 22 Mar 2013 13:25:21 -0700
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Josh Boyer <jwboyer@redhat.com>
CC: Boris Ostrovsky <boris.ostrovsky@oracle.com>, mingo@redhat.com,
        tglx@linutronix.de, rostedt@goodmis.org, kraman@redhat.com,
        gregkh@linuxfoundation.org, stable@vger.kernel.org, bp@alien8.de,
        samu.kallio@aberdeencloud.com, xen-devel@lists.xen.org,
        linux-kernel@vger.kernel.org
Message-ID: <9a798a0e-bc39-40db-be7f-b5e6fcc382d9@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sure.

Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:

>On Wed, Mar 20, 2013 at 08:08:45PM -0400, Josh Boyer wrote:
>> On Wed, Mar 20, 2013 at 06:53:55AM -0700, Boris Ostrovsky wrote:
>> > 
>> > ----- jwboyer@redhat.com wrote:
>> > 
>> > > On Wed, Mar 13, 2013 at 09:25:44AM -0400, Boris Ostrovsky wrote:
>> > > > On 03/01/2013 07:14 AM, Josh Boyer wrote:
>> > > > >On Thu, Feb 28, 2013 at 04:52:20PM -0800, H. Peter Anvin
>wrote:
>> > > > >>On 02/28/2013 04:42 PM, Josh Boyer wrote:
>> > > > >>>On Fri, Mar 01, 2013 at 01:36:29AM +0100, Borislav Petkov
>wrote:
>> > > > >>>>On Thu, Feb 28, 2013 at 04:15:45PM -0800, H. Peter Anvin
>wrote:
>> > > > >>>>>>I'll try to get someone to test this tomorrow.
>> > > > >>>>Btw, you'd need to apply that other patch too
>> > > > >>>>
>> > > > >>>>http://marc.info/?l=xen-devel&m=136206183814547&w=2
>> > > > >>>>
>> > > > >>>>so that arch_flush_lazy_mmu_mode() has at least one caller
>on
>> > > x86_64.
>> > > > >>>Yeah, we already have that applied.  It stops crashes in xen
>> > > > >>>environments so we pulled it in as a bugfix.  Thanks though!
>> > > > >>>
>> > > > >>Who are "we"?
>> > > > >Sorry, Fedora.  That patch has a link to a bug in it.  We
>applied
>> > > the
>> > > > >patch for that bug.  I'll apply Boris' patch on top and get
>the
>> > > same
>> > > > >people to test it.
>> > > > 
>> > > > Josh, have you had a chance to test this?
>> > > 
>> > > I've tested it on bare metal for a while now.  No problems
>noticed at
>> > > all.  I've not heard back from Krishna who was testing it in the
>Xen
>> > > environment.  Krishna?
>> > 
>> > 
>> > Any updates?
>> 
>> No.  I've still not heard from Krishna.
>> 
>> At this point I've tested it on bare metal quite a bit, and Konrad
>has
>> tested it on both bare metal and Xen.  That should already cover the
>> case Krishna was going to test anyway.  I suggest we move forward and
>> take the patch.
>
>Peter?
>
>Would you like me or Boris to clean up the two patches with the
>appropiate Acks and send them to you? 
>> 
>> josh

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
