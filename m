Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754520Ab3HEDN3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Aug 2013 23:13:29 -0400
Received: from ozlabs.org ([203.10.76.45]:58068 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754433Ab3HEDN2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Aug 2013 23:13:28 -0400
Date: Mon, 5 Aug 2013 13:13:26 +1000
From: Michael Ellerman <michael@ellerman.id.au>
To: Nathan Fontenot <nfont@linux.vnet.ibm.com>
Cc: linux-mm <linux-mm@kvack.org>, isimatu.yasuaki@jp.fujitsu.com,
        linuxppc-dev@lists.ozlabs.org, LKML <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 3/8] Add all memory via sysfs probe interface at once
Message-ID: <20130805031326.GB5347@concordia>
References: <51F01E06.6090800@linux.vnet.ibm.com>
 <51F01EFB.6070207@linux.vnet.ibm.com>
 <20130802023259.GC1680@concordia>
 <51FC04C2.70100@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51FC04C2.70100@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 02, 2013 at 02:13:06PM -0500, Nathan Fontenot wrote:
> On 08/01/2013 09:32 PM, Michael Ellerman wrote:
> > On Wed, Jul 24, 2013 at 01:37:47PM -0500, Nathan Fontenot wrote:
> >> When doing memory hot add via the 'probe' interface in sysfs we do not
> >> need to loop through and add memory one section at a time. I think this
> >> was originally done for powerpc, but is not needed. This patch removes
> >> the loop and just calls add_memory for all of the memory to be added.
> > 
> > Looks like memory hot add is supported on ia64, x86, sh, powerpc and
> > s390. Have you tested on any?
> 
> I have tested on powerpc. I would love to say I tested on the other
> platforms... but I haven't.  I should be able to get a x86 box to test
> on but the other architectures may not be possible.

Is the rest of your series dependent on this patch? Or is it sort of
incidental?

If possible it might be worth pulling this one out and sticking it in
linux-next for a cycle to give people a chance to test it. Unless
someone who knows the code well is comfortable with it.

cheers
