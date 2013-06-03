Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757684Ab3FCXpt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 19:45:49 -0400
Received: from mga03.intel.com ([143.182.124.21]:5578 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754049Ab3FCXpm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 19:45:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,796,1363158000"; 
   d="scan'208";a="311790214"
Date: Tue, 4 Jun 2013 07:45:24 +0800
From: Haicheng Li <haicheng.li@linux.intel.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Huajun Li <huajun.li@intel.com>, jaegeuk.kim@samsung.com,
        linux-fsdevel@vger.kernel.org, huajun.li.lee@gmail.com,
        namjae.jeon@samsung.com, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Subject: Re: [RFC 5/5] f2fs: add tracepoints to debug inline data operations
Message-ID: <20130603234524.GA5816@hli22-desktop>
References: <1370253854-15084-1-git-send-email-huajun.li@intel.com>
 <1370253854-15084-6-git-send-email-huajun.li@intel.com>
 <1370267400.26799.90.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370267400.26799.90.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 03, 2013 at 09:50:00AM -0400, Steven Rostedt wrote:
> Can you convert the above to use DECLARE_EVENT_CLASS() and
> DEFINE_EVENT(), as the above three are basically the same. You'll save a
> few K in text by doing so.

sure, thank you for the review.
 
> 
> > +
> >  #endif /* _TRACE_F2FS_H */
> >  
> >   /* This part must be outside protection */
> 
