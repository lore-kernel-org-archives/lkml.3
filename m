Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763311Ab3DDQkY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 12:40:24 -0400
Received: from mga09.intel.com ([134.134.136.24]:37840 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762758Ab3DDQkW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 12:40:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,410,1363158000"; 
   d="scan'208";a="289430314"
Date: Thu, 4 Apr 2013 09:40:21 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Vivek Gautam <gautamvivek1987@gmail.com>
Cc: balbi@ti.com, Vivek Gautam <gautam.vivek@samsung.com>,
        linux-usb@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, stern@rowland.harvard.edu,
        rob.herring@calxeda.com, kgene.kim@samsung.com, kishon@ti.com,
        dianders@chromium.org, t.figa@samsung.com, p.paneri@samsung.com
Subject: Re: [PATCH v3 00/11] usb: dwc3/xhci/phy: Enable runtime power
 management
Message-ID: <20130404164021.GB15489@xanatos>
References: <1364824448-14732-1-git-send-email-gautam.vivek@samsung.com>
 <20130403172751.GC10089@xanatos>
 <CAFp+6iGnDUSOjVgu9ZCAPF9rUDWD5r9ZttBtTo864Q2ACvKFrA@mail.gmail.com>
 <20130404071015.GB30287@arwen.pp.htv.fi>
 <CAFp+6iGqDFPhNjktD3WA4ZJuEdcX1C7Ma3hsSZieuW-b4_wpLA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFp+6iGqDFPhNjktD3WA4ZJuEdcX1C7Ma3hsSZieuW-b4_wpLA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 04, 2013 at 01:02:45PM +0530, Vivek Gautam wrote:
> On Thu, Apr 4, 2013 at 12:40 PM, Felipe Balbi <balbi@ti.com> wrote:
> > On Thu, Apr 04, 2013 at 10:34:57AM +0530, Vivek Gautam wrote:
> >> Hi Sarah,
> >>
> >>
> >> On Wed, Apr 3, 2013 at 10:57 PM, Sarah Sharp
> >> <sarah.a.sharp@linux.intel.com> wrote:
> >> > Question: Do you still need this patch for 3.10?
> >>
> >> Felipe's 'next' is closed for 3.10, so this series won't be making it
> >> to 3.10 now, as a whole. :-(
> >
> > right, besides we're still discussing what to do with the whole PHY
> > part, right ?
> 
> Right ofcourse. :-)

Ok, so it sounds like I shouldn't merge that patch for 3.10.  Please
include that patch in your next round of revisions instead.  And now I'm
glad I'm slow. :)

Sarah Sharp
