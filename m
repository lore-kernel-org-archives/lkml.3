Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751821Ab3BQSZF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 13:25:05 -0500
Received: from mail-da0-f41.google.com ([209.85.210.41]:33434 "EHLO
	mail-da0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751463Ab3BQSZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 13:25:03 -0500
Date: Sun, 17 Feb 2013 10:25:19 -0800
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
Message-ID: <20130217182519.GB8687@kroah.com>
References: <20130206191313.GA1470@kroah.com>
 <511ADEB7.6080909@zytor.com>
 <ae14ef66af2d4206baf4ccb382fc4205@SN2PR03MB061.namprd03.prod.outlook.com>
 <20130213162211.GA21253@kroah.com>
 <c31482583b394bfcaa16b76a63c413fe@SN2PR03MB061.namprd03.prod.outlook.com>
 <511BD923.7000500@zytor.com>
 <20130213182349.GA4959@kroah.com>
 <511BDD2A.8020002@zytor.com>
 <20130213185239.GB16645@kroah.com>
 <bc26219c6d0e4a498912a8411c11f81c@SN2PR03MB061.namprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bc26219c6d0e4a498912a8411c11f81c@SN2PR03MB061.namprd03.prod.outlook.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 17, 2013 at 06:13:49PM +0000, KY Srinivasan wrote:
> 
> 
> > -----Original Message-----
> > From: Greg KH [mailto:gregkh@linuxfoundation.org]
> > Sent: Wednesday, February 13, 2013 1:53 PM
> > To: H. Peter Anvin
> > Cc: KY Srinivasan; x86@kernel.org; linux-kernel@vger.kernel.org;
> > devel@linuxdriverproject.org; olaf@aepfle.de; apw@canonical.com;
> > jasowang@redhat.com; tglx@linutronix.de; JBeulich@suse.com; bp@alien8.de
> > Subject: Re: [PATCH 1/1] Drivers: hv: vmbus: Use the new infrastructure for
> > delivering VMBUS interrupts
> > 
> > On Wed, Feb 13, 2013 at 10:36:26AM -0800, H. Peter Anvin wrote:
> > > On 02/13/2013 10:23 AM, Greg KH wrote:
> > > > On Wed, Feb 13, 2013 at 10:19:15AM -0800, H. Peter Anvin wrote:
> > > >> Sounds like we have the joy of a cross-tree dependency...
> > > >
> > > > Yeah, a mess.
> > > >
> > > > KY, how about I just wait until all of this gets merged with Linus for
> > > > 3.9-rc1, and then you resend me the patches you have to take advantage
> > > > of these new bits?  That makes it easy for everyone involved.
> > > >
> > >
> > > The other option is you can pull tip:x86/hyperv from me... it has *only*
> > > these changes.  I can then let you push them to Linus or I can push them
> > > to Linus before you push your tree.
> > 
> > Nah, I'll just wait, it's not that big of a deal here, it will all make
> > it into 3.9-final eventually.
> 
> Peter's check-ins are now in Linux-next. Should I send you the vmbus
> patch that uses this infrastructure.

No one can base their tree on linux-next, so no.  Please wait for them
to get into Linus's tree.

Or send them to me now, with the instructions to apply them after
3.9-rc1, and I will save them for that point in time.

thanks,

greg k-h
