Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754231Ab3HBPuo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 11:50:44 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:59764 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754003Ab3HBPum (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 11:50:42 -0400
Date: Fri, 2 Aug 2013 10:50:26 -0500
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
To: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nathan Fontenot <nfont@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Nivedita Singhvi <niv@us.ibm.com>, Michael J Wolf <mjwolf@us.ibm.com>,
        linux-kernel@vger.kernel.org, Linux-MM <linux-mm@kvack.org>
Subject: Re: [PATCH] drivers: base: new memory config sysfs driver for large
 memory systems
Message-ID: <20130802155026.GA4550@variantweb.net>
References: <1374786680-26197-1-git-send-email-sjenning@linux.vnet.ibm.com>
 <20130725234007.GB18349@kroah.com>
 <20130726144251.GB4379@variantweb.net>
 <20130801205724.GA13585@kroah.com>
 <51FADD6F.3040804@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51FADD6F.3040804@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13080215-1618-0000-0000-00000463E5EE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 01, 2013 at 03:13:03PM -0700, Dave Hansen wrote:
> On 08/01/2013 01:57 PM, Greg Kroah-Hartman wrote:
> >> > "memory" is the name used by the current sysfs memory layout code in
> >> > drivers/base/memory.c. So it can't be the same unless we are going to
> >> > create a toggle a boot time to select between the models, which is
> >> > something I am looking to add if this code/design is acceptable to
> >> > people.
> > I know it can't be the same, but this is like "memory_v2" or something,
> > right?  I suggest you make it an either/or option, given that you feel
> > the existing layout just will not work properly for you.
> 
> If there are existing tools or applications that look for memory hotplug
> events, how does this interact with those?  I know you guys have control
> over the ppc software that actually performs the probe/online
> operations, but what about other apps?

After taking a closer look, I've decided to rework this to preserve more
of the existing layout.  Should be posting it next Monday.

> 
> I also don't seem to see the original post to LKML.  Did you send
> privately to Greg, then he cc'd LKML on his reply?

Yeah :-/  My mail relay settings were messed up and my system tried to
deliver the mail directly to recipients; some of which worked and some
failed (spam/firewall filters, etc).  Sigh...

Seth

