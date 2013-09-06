Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751087Ab3IFSlt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 14:41:49 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34848 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750Ab3IFSlr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 14:41:47 -0400
Date: Fri, 6 Sep 2013 11:41:46 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Sudeep Dutt <sudeep.dutt@intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>, Rob Landley <rob@landley.net>,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, linux-doc@vger.kernel.org,
        Asias He <asias@redhat.com>, Nikhil Rao <nikhil.rao@intel.com>,
        Ashutosh Dixit <ashutosh.dixit@intel.com>,
        Caz Yokoyama <Caz.Yokoyama@intel.com>,
        Dasaratharaman Chandramouli 
	<dasaratharaman.chandramouli@intel.com>,
        Harshavardhan R Kharche <harshavardhan.r.kharche@intel.com>,
        "Yaozu (Eddie) Dong" <eddie.dong@intel.com>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>
Subject: Re: [PATCH RESEND v3 3/7] Intel MIC Host Driver, card OS state
 management.
Message-ID: <20130906184146.GA4743@kroah.com>
References: <cover.1378423596.git.sudeep.dutt@intel.com>
 <669a3a3bbfff577c73d05fb568a810cbbc3d5333.1378423596.git.sudeep.dutt@intel.com>
 <20130906045858.GD28806@kroah.com>
 <1378492157.107744.54.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1378492157.107744.54.camel@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 06, 2013 at 11:29:17AM -0700, Sudeep Dutt wrote:
> On Thu, 2013-09-05 at 21:58 -0700, Greg Kroah-Hartman wrote:
> > Again, very minor fixups for later (I can even do them...)
> > 
> > > +static DEVICE_ATTR(state, S_IRUGO|S_IWUSR, mic_show_state, mic_store_state);
> > 
> > DEVICE_ATTR_RW() please.
> > 
> > Same for the other attributes you create in this patch.
> > 
> 
> Sure, we will incorporate these changes along with your other feedback
> in patch 1 and post the next revision of this patch series.

There's no need to repost just yet.  I can take these as-is after the
merge window closes, and you can send follow-on patches for these minor
issues, keeping you from having to do a respin, and me trying to
remember what parts I reviewed and didn't review.

So give me some time (i.e. wait for after 3.12-rc1 is out) and if I have
further problems with the patches, I'll let you know, otherwise you'll
get an automated email from my patch collection system saying the
patches are applied.

thanks,

greg k-h
