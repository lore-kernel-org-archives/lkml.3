Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751539Ab3CTNyb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 09:54:31 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:47427 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750709Ab3CTNy3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 09:54:29 -0400
MIME-Version: 1.0
Message-ID: <5afe14ac-bc17-4fd1-9680-8f2566322437@default>
Date: Wed, 20 Mar 2013 06:53:55 -0700 (PDT)
From: Boris Ostrovsky <boris.ostrovsky@oracle.com>
To: <jwboyer@redhat.com>
Cc: <mingo@redhat.com>, <konrad.wilk@oracle.com>, <tglx@linutronix.de>,
        <rostedt@goodmis.org>, <kraman@redhat.com>,
        <gregkh@linuxfoundation.org>, <stable@vger.kernel.org>, <bp@alien8.de>,
        <samu.kallio@aberdeencloud.com>, <xen-devel@lists.xen.org>,
        <linux-kernel@vger.kernel.org>, <hpa@zytor.com>
Subject: Re: [PATCH] mm/x86: Patch out arch_flush_lazy_mmu_mode() when running
 on bare metal
X-Mailer: Zimbra on Oracle Beehive
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


----- jwboyer@redhat.com wrote:

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
> > >>>>so that arch_flush_lazy_mmu_mode() has at least one caller on
> x86_64.
> > >>>Yeah, we already have that applied.  It stops crashes in xen
> > >>>environments so we pulled it in as a bugfix.  Thanks though!
> > >>>
> > >>Who are "we"?
> > >Sorry, Fedora.  That patch has a link to a bug in it.  We applied
> the
> > >patch for that bug.  I'll apply Boris' patch on top and get the
> same
> > >people to test it.
> > 
> > Josh, have you had a chance to test this?
> 
> I've tested it on bare metal for a while now.  No problems noticed at
> all.  I've not heard back from Krishna who was testing it in the Xen
> environment.  Krishna?


Any updates?

Thanks.
-boris
