Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754649Ab3I0TjF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 15:39:05 -0400
Received: from mga09.intel.com ([134.134.136.24]:17681 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753768Ab3I0TjA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 15:39:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,995,1371106800"; 
   d="scan'208";a="410570798"
Subject: Re: [PATCH CHAR-MISC-NEXT 4/4] Intel MIC Header File warning fix.
From: Sudeep Dutt <sudeep.dutt@intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, Nikhil Rao <nikhil.rao@intel.com>,
        Ashutosh Dixit <ashutosh.dixit@intel.com>,
        Dasaratharaman Chandramouli 
	<dasaratharaman.chandramouli@intel.com>,
        Harshavardhan R Kharche <harshavardhan.r.kharche@intel.com>,
        "Yaozu (Eddie) Dong" <eddie.dong@intel.com>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        Sudeep Dutt <sudeep.dutt@intel.com>
In-Reply-To: <20130927031727.GC13086@kroah.com>
References: <cover.1380241770.git.sudeep.dutt@intel.com>
	 <a12a4d52202e0511d03a0e6b85ef5d70348d64cf.1380241770.git.sudeep.dutt@intel.com>
	 <20130927031727.GC13086@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 27 Sep 2013 12:37:47 -0700
Message-ID: <1380310667.130632.20.camel@blbiskey-desk1.amr.corp.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-30.el6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-09-26 at 20:17 -0700, Greg Kroah-Hartman wrote:
> On Thu, Sep 26, 2013 at 06:10:23PM -0700, Sudeep Dutt wrote:
> > usr/include/linux/mic_ioctl.h:37:
> > found __[us]{8,16,32,64} type without #include <linux/types.h>
> 
> What is that from?  What does it mean?
> 

This warning was displayed during "make headers_check" via
scripts/headers_check.pl. The patch description has been fixed up to
read as follows in the patches resent this morning @
https://lkml.org/lkml/2013/9/27/376 

The following warning from mic_ioctl.h is fixed via this patch:
found __[us]{8,16,32,64} type without #include <linux/types.h>

Sorry for the confusion.

Thanks,
Sudeep Dutt

> confused,
> 
> greg k-h


