Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759989Ab3BMQWQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 11:22:16 -0500
Received: from mail-da0-f42.google.com ([209.85.210.42]:34512 "EHLO
	mail-da0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759944Ab3BMQWO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 11:22:14 -0500
Date: Wed, 13 Feb 2013 08:22:11 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: KY Srinivasan <kys@microsoft.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "JBeulich@suse.com" <JBeulich@suse.com>, "bp@alien8.de" <bp@alien8.de>
Subject: Re: [PATCH 1/1] Drivers: hv: vmbus: Use the new infrastructure for
 delivering VMBUS interrupts
Message-ID: <20130213162211.GA21253@kroah.com>
References: <1360164359-12273-1-git-send-email-kys@microsoft.com>
 <20130206191313.GA1470@kroah.com>
 <511ADEB7.6080909@zytor.com>
 <ae14ef66af2d4206baf4ccb382fc4205@SN2PR03MB061.namprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ae14ef66af2d4206baf4ccb382fc4205@SN2PR03MB061.namprd03.prod.outlook.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2013 at 02:07:52PM +0000, KY Srinivasan wrote:
> 
> 
> > -----Original Message-----
> > From: H. Peter Anvin [mailto:hpa@zytor.com]
> > Sent: Tuesday, February 12, 2013 7:31 PM
> > To: Greg KH
> > Cc: KY Srinivasan; x86@kernel.org; linux-kernel@vger.kernel.org;
> > devel@linuxdriverproject.org; olaf@aepfle.de; apw@canonical.com;
> > jasowang@redhat.com; tglx@linutronix.de; JBeulich@suse.com; bp@alien8.de
> > Subject: Re: [PATCH 1/1] Drivers: hv: vmbus: Use the new infrastructure for
> > delivering VMBUS interrupts
> > 
> > On 02/06/2013 11:13 AM, Greg KH wrote:
> > > On Wed, Feb 06, 2013 at 07:25:59AM -0800, K. Y. Srinivasan wrote:
> > >> Use the infrastructure for delivering VMBUS interrupts using a
> > >> special vector. With this patch, we can now properly handle
> > >> the VMBUS interrupts that can be delivered on any CPU. Also,
> > >> turn on interrupt load balancing as well.
> > >>
> > >> This patch requires the infrastructure that was implemented in the patch:
> > >> X86: Handle Hyper-V vmbus interrupts as special hypervisor interrupts
> > >>
> > >
> > > Because of the dependancy, this should go through the x86 tree as well:
> > > 	Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > >
> > 
> > This does not apply to v3.8-rc7 + the set of three vmbus patches for
> > x86.  I take it there are additional dependencies -- K.Y., what do I
> > need here?
> 
> Greg,
> 
> Peter has checked in the infrastructural patches into v3.8-rc7. This version
> does not have the patches that upgraded the VMBUS protocol version to the
> win8 levels.

What is "this version"?

> How will the infrastructural patches get moved forward to the version
> where you have checked-in all the vmbus protocol updates:
> [PATCH 00/28] Drivers: hv: Update the Vmbus protocol.

Those are in the char-misc git tree and will to go Linus for 3.9-rc1.

> Now that Peter has checked in the needed patches, could you take this
> patch through your tree.

What again is "this"?

> Let me know, if you need, I can re-send this patch to you.

Will it cause build problems if I take this patch in my tree, without
the changes in the -tip tree?

thanks,

greg k-h
