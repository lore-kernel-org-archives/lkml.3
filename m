Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755233AbaDXKr0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 06:47:26 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:60185 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754084AbaDXKrC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 06:47:02 -0400
Date: Thu, 24 Apr 2014 11:46:24 +0100
From: Will Deacon <will.deacon@arm.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Steve Capper <steve.capper@linaro.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "robherring2@gmail.com" <robherring2@gmail.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "gerald.schaefer@de.ibm.com" <gerald.schaefer@de.ibm.com>
Subject: Re: [PATCH V2 0/5] Huge pages for short descriptors on ARM
Message-ID: <20140424104624.GD19564@arm.com>
References: <1397648803-15961-1-git-send-email-steve.capper@linaro.org>
 <20140424102229.GA28014@linaro.org>
 <20140424103639.GC19564@arm.com>
 <20140424104232.GK26756@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140424104232.GK26756@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 24, 2014 at 11:42:32AM +0100, Russell King - ARM Linux wrote:
> On Thu, Apr 24, 2014 at 11:36:39AM +0100, Will Deacon wrote:
> > I guess I'm after some commitment that this is (a) useful to somebody and
> > (b) going to be tested regularly, otherwise it will go the way of things
> > like big-endian, where we end up carrying around code which is broken more
> > often than not (although big-endian is more self-contained).
> 
> It may be something worth considering adding to my nightly builder/boot
> testing, but I suspect that's impractical as it probably requires a BE
> userspace, which would then mean that the platform can't boot LE.
> 
> I suspect that we will just have to rely on BE users staying around and
> reporting problems when they occur.

Indeed. Marc and I have BE guests running under kvmtool on an LE host, so
that's what I've been using (then a BE busybox can sit in the host
filesystem and be passed via something like 9pfs).

Will
