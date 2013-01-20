Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752342Ab3ATWth (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2013 17:49:37 -0500
Received: from mail-bk0-f43.google.com ([209.85.214.43]:48926 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752039Ab3ATWtg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2013 17:49:36 -0500
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
In-Reply-To: <50FC6731.3020209@ionic.de>
References: <50F9DF53.4090601@ionic.de>
	<CAKMK7uExHc=PEBpn2vPrX+sQcv=U7VuvsJHRxc-SSOh=_G_1Dg@mail.gmail.com>
	<50FC6731.3020209@ionic.de>
Date: Sun, 20 Jan 2013 23:49:34 +0100
Message-ID: <CAKMK7uEX0CG4LaVr3jkcPeQYTYFseG-G5f0_2zKTuCcfVfhF2g@mail.gmail.com>
Subject: Re: i915-related and general system freezes with specific kernel
 config // IOMMU
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Mihai Moldovan <ionic@ionic.de>
Cc: LKML <linux-kernel@vger.kernel.org>, David Woodhouse <dwmw2@infradead.org>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        dri-devel <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 20, 2013 at 10:52 PM, Mihai Moldovan <ionic@ionic.de> wrote:
> the patch does work, i.e., it turns off DMAR for the graphics card and
> alleviates the freezes when loading i915/kms.
>
> However, still seeing random machine freezes with it (being consistent with the
> behavior I've experienced with intel_iommu=igfx_off).

Thanks for testing, I've just submitted the patch for review. It
should included in a -fixes tree soon and the get backported to stable
kernels.

> The patch + forcing RWBF is working, too. Interestingly, this version didn't
> randomly freeze yet, after more than 5 hours of uptime! I'll leave the box
> running until tomorrow to make sure I did stick around long enough.
>
> All those tested kernels were able to handle USB and PCI(e) devices.
>
> I still have to test turning off IOMMU in general and Intel IOMMU specifically.
> Will probably do this tomorrow.

Please let me know when this works solidly for you, so that I can put
it into a real patch and also submit it for inclusion.

Thanks, Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
