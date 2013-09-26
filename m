Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754510Ab3IZVk7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 17:40:59 -0400
Received: from mga11.intel.com ([192.55.52.93]:16335 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754032Ab3IZVkz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 17:40:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,988,1371106800"; 
   d="scan'208";a="407770764"
Subject: Re: [PATCH RESEND v3 0/7] Enable Drivers for Intel MIC X100
 Coprocessors.
From: Sudeep Dutt <sudeep.dutt@intel.com>
To: Joe Perches <joe@perches.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>, Rusty Russell <rusty@rustcorp.com.au>,
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
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        Sudeep Dutt <sudeep.dutt@intel.com>
In-Reply-To: <1380231195.17366.82.camel@joe-AO722>
References: <cover.1378423596.git.sudeep.dutt@intel.com>
	 <1378431368.19204.3.camel@joe-AO722> <20130926205424.GB19455@kroah.com>
	 <1380231195.17366.82.camel@joe-AO722>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 26 Sep 2013 14:40:27 -0700
Message-ID: <1380231627.116984.4.camel@blbiskey-desk1.amr.corp.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-30.el6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-09-26 at 14:33 -0700, Joe Perches wrote:
> On Thu, 2013-09-26 at 13:54 -0700, Greg Kroah-Hartman wrote:
> > On Thu, Sep 05, 2013 at 06:36:08PM -0700, Joe Perches wrote:
> > > Whitespace neatening...
> > > 
> > > Multiline statement argument alignment.
> > > Argument wrapping.
> > > Use kmalloc_array instead of kmalloc.
> > > 
> > > ---
> > 
> > -ENOSIGNEDOFFBY :(
> 
> These were just suggestions for Sudeep.
> 
> Sudeep said he'd incorporate and resend the series.
> 
> Sudeep?  Were you ever going to do that?
> 

We were waiting for Greg to apply the base patches to the char misc next
tree which happened today. We will send out the cleanup patch series
which addresses all feedback soon.

Thanks,
Sudeep Dutt

