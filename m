Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754363AbaJHRzb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 13:55:31 -0400
Received: from mga01.intel.com ([192.55.52.88]:65454 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753664AbaJHRza (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 13:55:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,679,1406617200"; 
   d="scan'208";a="611471302"
Date: Wed, 8 Oct 2014 10:55:58 -0700
From: David Cohen <david.a.cohen@linux.intel.com>
To: Felipe Balbi <balbi@ti.com>
Cc: gregkh@linuxfoundation.org, mina86@mina86.com, r.baldyga@samsung.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Subject: Re: [PATCH] usb: ffs: fix regression when quirk_ep_out_aligned_size
 flag is set
Message-ID: <20141008175558.GC16791@psi-dev26.jf.intel.com>
References: <1412727486-479-1-git-send-email-david.a.cohen@linux.intel.com>
 <20141008003256.GB9957@saruman>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141008003256.GB9957@saruman>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 07, 2014 at 07:32:56PM -0500, Felipe Balbi wrote:
> Hi again,
> 
> On Tue, Oct 07, 2014 at 05:18:06PM -0700, David Cohen wrote:
> > The commit '2e4c7553cd usb: gadget: f_fs: add aio support' broke the
> > quirk implemented to align buffer size to maxpacketsize on out endpoint.
> > As result, functionfs does not work on Intel platforms using dwc3 driver
> > (i.e. Bay Trail and Merrifield). This patch fixes the issue.
> > 
> > This code is based on a previous Qiuxu's patch.
> > 
> 
> btw, please resend and add below right here:
> 
> Fixes: 2e4c7553cd (usb: gadget: f_fs: add aio support)
> Cc: <stable@vger.kernel.org> # v3.16+

Sure. But v3.16 doesn't have the new 'function' directory under usb/gadget.
Not sure if same patch is useful for v3.16+.
The patch I sent is intended for v3.17.1 and v3.18-rc1.

Br, David

> 
> > Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
> > Signed-off-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
> 
> -- 
> balbi


