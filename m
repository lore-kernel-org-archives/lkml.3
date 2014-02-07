Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751897AbaBGTLP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 14:11:15 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58608 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751150AbaBGTLO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 14:11:14 -0500
Date: Fri, 7 Feb 2014 11:12:23 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: KY Srinivasan <kys@microsoft.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>
Subject: Re: Drivers/hv
Message-ID: <20140207191223.GA8580@kroah.com>
References: <1391011049-10795-1-git-send-email-kys@microsoft.com>
 <20140129211532.GA9095@kroah.com>
 <dcabbfad2fe24769a3d2ade8315fa016@BY2PR03MB299.namprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dcabbfad2fe24769a3d2ade8315fa016@BY2PR03MB299.namprd03.prod.outlook.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 07, 2014 at 07:06:00PM +0000, KY Srinivasan wrote:
> 
> 
> > -----Original Message-----
> > From: Greg KH [mailto:gregkh@linuxfoundation.org]
> > Sent: Wednesday, January 29, 2014 1:16 PM
> > To: KY Srinivasan
> > Cc: linux-kernel@vger.kernel.org; devel@linuxdriverproject.org; olaf@aepfle.de;
> > apw@canonical.com; jasowang@redhat.com
> > Subject: Re: Drivers/hv
> > 
> > On Wed, Jan 29, 2014 at 07:57:29AM -0800, K. Y. Srinivasan wrote:
> > >
> > > Greg,
> > >
> > > Some time back I had sent a buch of patches for
> > > Hyper-V drivers. Are they still in the queue or should I resend
> > > them.
> > 
> > Which specific patches are you referring to?  I can't take anything
> > until after 3.14-rc1 is out, and I do see a few from you in my queue, so
> > if you want to resend, please do, but note I will not get to them until
> > sometime late next week at the earliest.
> 
> I saw that you committed two (hv) patches earlier today. There are still a few more
> patches that are not committed yet; should I resend those?

No, I am slowly going through my backlog (over 800 patches).  I applied
the ones that are needed for 3.14 at the moment, will catch with the
rest later, please give me a chance...

greg k-h
