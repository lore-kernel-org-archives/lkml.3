Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753083Ab3HBApI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 20:45:08 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59591 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484Ab3HBApD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 20:45:03 -0400
Date: Fri, 2 Aug 2013 08:46:18 +0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Sudeep Dutt <sudeep.dutt@intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>, Rob Landley <rob@landley.net>,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, linux-doc@vger.kernel.org,
        Nikhil Rao <nikhil.rao@intel.com>,
        Ashutosh Dixit <ashutosh.dixit@intel.com>,
        Caz Yokoyama <Caz.Yokoyama@intel.com>,
        Dasaratharaman Chandramouli 
	<dasaratharaman.chandramouli@intel.com>,
        Harshavardhan R Kharche <harshavardhan.r.kharche@intel.com>,
        "Yaozu (Eddie) Dong" <eddie.dong@intel.com>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>
Subject: Re: [PATCH 1/5] Intel MIC Host Driver for X100 family.
Message-ID: <20130802004618.GA12473@kroah.com>
References: <cover.1374717252.git.sudeep.dutt@intel.com>
 <be8c714ed743143c427058fc0b75722f2eeeee1c.1374717252.git.sudeep.dutt@intel.com>
 <20130801015106.GE6941@kroah.com>
 <1375403794.61060.70.camel@blbiskey-desk1.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375403794.61060.70.camel@blbiskey-desk1.amr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 01, 2013 at 05:36:34PM -0700, Sudeep Dutt wrote:
> On Wed, 2013-07-31 at 18:51 -0700, Greg Kroah-Hartman wrote: 
> > On Wed, Jul 24, 2013 at 08:31:32PM -0700, Sudeep Dutt wrote:
> > > --- /dev/null
> > > +++ b/drivers/misc/mic/common/mic_device.h
> > > @@ -0,0 +1,81 @@
> > > +/*
> > > + * Intel MIC Platform Software Stack (MPSS)
> > > + *
> > > + * Copyright(c) 2013 Intel Corporation.
> > > + *
> > > + * This program is free software; you can redistribute it and/or modify
> > > + * it under the terms of the GNU General Public License, version 2, as
> > > + * published by the Free Software Foundation.
> > > + *
> > > + * This program is distributed in the hope that it will be useful, but
> > > + * WITHOUT ANY WARRANTY; without even the implied warranty of
> > > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
> > > + * General Public License for more details.
> > > + *
> > > + * You should have received a copy of the GNU General Public License
> > > + * along with this program; if not, write to the Free Software
> > > + * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301
> > > + * USA.
> > 
> > Ok, it's now your task as an Intel employee to get this paragraph
> > stricken from the "default template" that GPL code in the kernel,
> > written by Intel developers, has.  It's pointless, and unless you want
> > to be personally responsible for tracking the address changes of the FSF
> > for the next 40+ years, not something I'm going to ever accept.
> > 
> > I know you aren't responsible for this, but I'm getting really tired of
> > pointing this out each-and-every-time I see a file from an Intel
> > developer.
> > 
> > So please work to fix this.
> > 
> 
> I brought up this issue today, with the team which reviews licenses for
> open source projects at Intel. The recommendation from them is to
> include the following wording instead of the FSF street address in the
> standard template.
> 
> <snip>
> You should have received a copy of the GNU General Public License along
> with this program. If not, see <http://www.gnu.org/licenses/>.
> <snip>

That's better, but, this is the kernel, and of course they got a copy of
the license with it, it's part of the whole body of code.  So that
paragraph is not needed either.

thanks,

greg k-h
