Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757153Ab3DBXeK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 19:34:10 -0400
Received: from mga02.intel.com ([134.134.136.20]:63064 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751069Ab3DBXeI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 19:34:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,396,1363158000"; 
   d="scan'208";a="288473733"
Date: Tue, 2 Apr 2013 16:33:57 -0700
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Platform Driver <platform-driver-x86@vger.kernel.org>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Zhang Rui <rui.zhang@intel.com>,
        Rafael Wysocki <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [PATCH 1/1] Introduce Intel RAPL cooling device driver
Message-ID: <20130402163357.72dac902@chromoly>
In-Reply-To: <20130402230042.GA8713@kroah.com>
References: <1364940936-20846-1-git-send-email-jacob.jun.pan@linux.intel.com>
	<1364940936-20846-2-git-send-email-jacob.jun.pan@linux.intel.com>
	<20130402230042.GA8713@kroah.com>
Organization: OTC
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Apr 2013 16:00:42 -0700
Greg KH <gregkh@linuxfoundation.org> wrote:

> > +#include "intel_rapl.h"
> > +#include "../../../fs/sysfs/sysfs.h"  
> 
> WTF?
> 
> Oh, that's a sure sign you are not doing something properly, if you
> think it's ok to muck around with the internals of sysfs.
> 
> There's a reason that file is "private", why do you think it's ok to
> use it directly?  Did you just think that I somehow "forgot" to put
> it in the proper include directory?
I did feel unsure about this but i saw some precedence in the kernel.
Anyway, I needed a way to validate a userspace file passed to rapl
driver belong to the same sysfs directory. I will look for alternative
ways.

-- 
Thanks,

Jacob
