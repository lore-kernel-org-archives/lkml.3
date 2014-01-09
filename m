Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753166AbaAIINu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 03:13:50 -0500
Received: from mail-pb0-f54.google.com ([209.85.160.54]:39372 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751201AbaAIINo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 03:13:44 -0500
Date: Thu, 9 Jan 2014 00:11:42 -0800
From: Olof Johansson <olof@lixom.net>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "arm@kernel.org" <arm@kernel.org>, linux-arm-msm@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Clark <robdclark@gmail.com>, Dave Airlie <airlied@redhat.com>,
        David Brown <davidb@codeaurora.org>, Chris Ball <cjb@laptop.org>
Subject: Re: [PATCH v2 0/7] Allow MSM DT platforms to be built multi-platform
Message-ID: <20140109081142.GH8285@quad.lixom.net>
References: <1388438133-431-1-git-send-email-sboyd@codeaurora.org>
 <201401021913.25920.arnd@arndb.de>
 <52C70698.2030004@codeaurora.org>
 <CAOesGMiFixweRT1R-y2Cxvx+p6tzf3Qr-TaAwqDBCgB=Ge8FfA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOesGMiFixweRT1R-y2Cxvx+p6tzf3Qr-TaAwqDBCgB=Ge8FfA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 03, 2014 at 11:31:46AM -0800, Olof Johansson wrote:
> On Fri, Jan 3, 2014 at 10:51 AM, Stephen Boyd <sboyd@codeaurora.org> wrote:
> > On 01/02/14 10:13, Arnd Bergmann wrote:
> >> On Monday 30 December 2013, Stephen Boyd wrote:
> >>> These patches allow the DT based MSM platforms to be built as part of the
> >>> multi-platform kernel. I need acks from Chris Ball on the mmc patch and
> >>> Rob/Dave on the drm patch. I dropped Arnd's ack on patch 6 because I've
> >>> rebased that patch on top of the patchset David sent out (which this is in
> >>> reply to). The rebase was fairly minor and the new patch for drm/msm is
> >>> trivial. Please consider for v3.14.
> >> Just for the record, I'm definitely happy with the way this is turning out,
> >> don't see my question on the serial driver as a NAK. I assume we will apply
> >> the patches for 3.14, but I first want to have a better understanding on
> >> where we are with the stuff that is already queued up for 3.14.
> >>
> >
> > It would be great if we could get these patches in for 3.14. Now that
> > Olof has applied the collection of patches that David sent, these
> > patches should apply cleanly on top of arm-soc.git qcom/soc. Can you
> > apply them directly to the arm-soc tree?
> 
> Yeah, we'll get to it in a bit.

Ok, I've applied all but the DRM patch since Rob needed that respun. It should
probably be merged through the DRM tree given the conflicts.


-Olof
