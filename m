Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936369Ab3DIQPV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 12:15:21 -0400
Received: from mga14.intel.com ([143.182.124.37]:57718 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761860Ab3DIQPU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 12:15:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,439,1363158000"; 
   d="scan'208";a="225109728"
Date: Tue, 9 Apr 2013 09:15:17 -0700
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Platform Driver <platform-driver-x86@vger.kernel.org>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Joe Perches <joe@perches.com>, Zhang Rui <rui.zhang@intel.com>,
        Rafael Wysocki <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [PATCH v3 1/1] Introduce Intel RAPL cooling device driver
Message-ID: <20130409091517.3b73a583@chromoly>
In-Reply-To: <20130409152638.GA3033@kroah.com>
References: <1365511578-30453-1-git-send-email-jacob.jun.pan@linux.intel.com>
	<1365511578-30453-2-git-send-email-jacob.jun.pan@linux.intel.com>
	<20130409152638.GA3033@kroah.com>
Organization: OTC
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Apr 2013 08:26:38 -0700
Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> > +	if (NULL == rp->name || rp->flag & RAPL_PRIMITIVE_DUMMY)
> 
> In Linux we do (rp->name == NULL), or even better yet (!rp->name),
> please fix that up here and elsewhere in the driver.
> 
I can fix that. I did that because checkpatch does not complain about
it. also it avoids common mistake as:
rp->name = NULL

> > +
> > +#define PRIMITIVE_INFO_INIT(p, m, s, i, u, f) {#p, m, s, i, u, p,
> > f}
> 
> C has named initializers, use them please.
> 
this macro can save lots of repeated text.

> greg k-h
> --
> To unsubscribe from this list: send the line "unsubscribe
> platform-driver-x86" in the body of a message to
> majordomo@vger.kernel.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html

[Jacob Pan]

-- 
Thanks,

Jacob
