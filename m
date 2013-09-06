Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751397Ab3IFS22 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 14:28:28 -0400
Received: from mga14.intel.com ([143.182.124.37]:61269 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750956Ab3IFS20 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 14:28:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,855,1371106800"; 
   d="scan'208";a="356957446"
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
In-Reply-To: <1378431368.19204.3.camel@joe-AO722>
References: <cover.1378423596.git.sudeep.dutt@intel.com>
	 <1378431368.19204.3.camel@joe-AO722>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 06 Sep 2013 11:27:49 -0700
Message-ID: <1378492069.107744.50.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-30.el6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-09-05 at 18:36 -0700, Joe Perches wrote:
> Whitespace neatening...
> 
> Multiline statement argument alignment.
> Argument wrapping.
> Use kmalloc_array instead of kmalloc.
> 
> ---

Hi Joe,

We will incorporate your changes in the next version of this patch
series and run all future patches via the "--strict" checkpatch option.

Thanks a lot for the patch!
Sudeep Dutt

