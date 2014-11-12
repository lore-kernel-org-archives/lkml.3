Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752201AbaKLHeH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 02:34:07 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:35469 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752112AbaKLHeC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 02:34:02 -0500
Date: Wed, 12 Nov 2014 16:31:33 +0900
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Mathieu Poirier <mathieu.poirier@linaro.org>
Cc: Rob Herring <robherring2@gmail.com>, Rob Herring <robh+dt@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] coresight: bindings for coresight drivers
Message-ID: <20141112073133.GA8354@kroah.com>
References: <1415727960-29524-1-git-send-email-mathieu.poirier@linaro.org>
 <CAL_JsqLXTx9jWT3sm3wnu1oWCk_VH_CUjfVX7t1HEA_9BfSeAg@mail.gmail.com>
 <CANLsYkxok7LVGey6tPqmt42GEAs8R7SYAG_cs4VRjYeqkwKEKw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANLsYkxok7LVGey6tPqmt42GEAs8R7SYAG_cs4VRjYeqkwKEKw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 11, 2014 at 02:52:17PM -0700, Mathieu Poirier wrote:
> On 11 November 2014 11:04, Rob Herring <robherring2@gmail.com> wrote:
> > On Tue, Nov 11, 2014 at 11:46 AM,  <mathieu.poirier@linaro.org> wrote:
> >> Greg,
> >>
> >> Please consider this as a supplement to the coresight patchset.  It should have
> >> been sent with the rest of the patches but I missed the original ack from Rob
> >> Herring.
> >
> > Ummm...
> >
> >>
> >> Thanks,
> >> Mathieu
> >>
> >> From 69cae46640b8cdc836bf7b86211d5f2adf3d0270 Mon Sep 17 00:00:00 2001
> >> From: Mathieu Poirier <mathieu.poirier@linaro.org>
> >> Date: Thu, 7 Aug 2014 12:34:06 -0600
> >> Subject: [PATCH] coresight: bindings for coresight drivers
> >>
> >> Coresight IP blocks allow for the support of HW assisted tracing
> >> on ARM SoCs.  Bindings for the currently available blocks are
> >> presented herein.
> >>
> >> Signed-off-by: Pratik Patel <pratikp@codeaurora.org>
> >> Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
> >
> > And you still did.
> 
> https://patchwork.ozlabs.org/patch/388318/

How does that help me?  It's not on this patch, so I can't add it.

And I can't even _take_ this patch, I need something that I can apply,
not have to hand-edit in order to get it to apply properly.

Please resend, _with_ the ack, and then I can queue it up.

greg k-h
