Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752886Ab3HBAkb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 20:40:31 -0400
Received: from mga14.intel.com ([143.182.124.37]:35783 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751022Ab3HBAka (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 20:40:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,797,1367996400"; 
   d="scan'208";a="340417246"
Subject: Re: [PATCH 1/5] Intel MIC Host Driver for X100 family.
From: Sudeep Dutt <sudeep.dutt@intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
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
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        Sudeep Dutt <sudeep.dutt@intel.com>
In-Reply-To: <20130801015106.GE6941@kroah.com>
References: <cover.1374717252.git.sudeep.dutt@intel.com>
	 <be8c714ed743143c427058fc0b75722f2eeeee1c.1374717252.git.sudeep.dutt@intel.com>
	 <20130801015106.GE6941@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 01 Aug 2013 17:36:34 -0700
Message-ID: <1375403794.61060.70.camel@blbiskey-desk1.amr.corp.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-30.el6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-07-31 at 18:51 -0700, Greg Kroah-Hartman wrote: 
> On Wed, Jul 24, 2013 at 08:31:32PM -0700, Sudeep Dutt wrote:
> > --- /dev/null
> > +++ b/drivers/misc/mic/common/mic_device.h
> > @@ -0,0 +1,81 @@
> > +/*
> > + * Intel MIC Platform Software Stack (MPSS)
> > + *
> > + * Copyright(c) 2013 Intel Corporation.
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License, version 2, as
> > + * published by the Free Software Foundation.
> > + *
> > + * This program is distributed in the hope that it will be useful, but
> > + * WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
> > + * General Public License for more details.
> > + *
> > + * You should have received a copy of the GNU General Public License
> > + * along with this program; if not, write to the Free Software
> > + * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301
> > + * USA.
> 
> Ok, it's now your task as an Intel employee to get this paragraph
> stricken from the "default template" that GPL code in the kernel,
> written by Intel developers, has.  It's pointless, and unless you want
> to be personally responsible for tracking the address changes of the FSF
> for the next 40+ years, not something I'm going to ever accept.
> 
> I know you aren't responsible for this, but I'm getting really tired of
> pointing this out each-and-every-time I see a file from an Intel
> developer.
> 
> So please work to fix this.
> 

I brought up this issue today, with the team which reviews licenses for
open source projects at Intel. The recommendation from them is to
include the following wording instead of the FSF street address in the
standard template.

<snip>
You should have received a copy of the GNU General Public License along
with this program. If not, see <http://www.gnu.org/licenses/>.
<snip>

Do you think this is an acceptable long term solution?
Thanks,
Sudeep Dutt

> thanks,
> 
> greg k-h







