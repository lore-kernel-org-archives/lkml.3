Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757748Ab3BKP66 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 10:58:58 -0500
Received: from mga01.intel.com ([192.55.52.88]:63286 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757029Ab3BKP65 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 10:58:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,643,1355126400"; 
   d="scan'208";a="289662496"
Date: Mon, 11 Feb 2013 16:58:54 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Tomas Winkler <tomas.winkler@intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [char-misc-next 01/11 V2] mei: bus: Initial MEI bus type
 implementation
Message-ID: <20130211155854.GV20996@sortiz-mobl>
References: <1360326504-17041-1-git-send-email-tomas.winkler@intel.com>
 <20130208235341.GA24127@kroah.com>
 <20130210032555.GG20996@sortiz-mobl>
 <201302111150.26785.arnd@arndb.de>
 <20130211134612.GO20996@sortiz-mobl>
 <20130211143051.GA1017@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130211143051.GA1017@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 11, 2013 at 06:30:51AM -0800, Greg KH wrote:
> On Mon, Feb 11, 2013 at 02:46:12PM +0100, Samuel Ortiz wrote:
> > > You already have a 'struct mei_device', which refers to the PCI device
> > > that owns the bus, and has clients attached to it. While it may be
> > > a little confusing to people that already worked with the current
> > > mei code, I think it would help to rename the existing 'mei_device'
> > > to 'mei_host' or something else that feels appropriate, and introduce
> > > the new structure as 'mei_device' derived from 'struct device', again
> > > matching what most other subsystems do.
> > I understand, and I agree it would make sense. As we're aiming at having this
> > patchset merged during the next merge window, would it be ok to have this
> > renaming phase as a follow up patch ?
> 
> Do you mean for 3.9?  
That's what I meant, yes.

> Sorry, my trees are now closed for new stuff like this for 3.9, 
Out of curiosity, when do you close your trees for new stuff ? Is there a
fixed timeframe ?

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
