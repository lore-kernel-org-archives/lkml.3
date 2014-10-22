Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932692AbaJVIDf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 04:03:35 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:48434 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754011AbaJVIDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 04:03:08 -0400
Date: Wed, 22 Oct 2014 10:03:02 +0200
From: Richard Cochran <richardcochran@gmail.com>
To: Peter Foley <pefoley2@pefoley.com>
Cc: David Daney <ddaney.cavm@gmail.com>, David Miller <davem@davemloft.net>,
        markos.chandras@imgtec.com, linux-mips@linux-mips.org, corbet@lwn.net,
        netdev@vger.kernel.org,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Documentation: ptp: Fix build failure on MIPS cross
 builds
Message-ID: <20141022080302.GA4037@localhost.localdomain>
References: <1413794538-28465-1-git-send-email-markos.chandras@imgtec.com>
 <20141021110724.GA16479@netboy>
 <20141021.123544.9516812519754063.davem@davemloft.net>
 <544690CB.4030307@gmail.com>
 <20141021182757.GA3960@localhost.localdomain>
 <CAOFdcFNYHgupvMChb4NedMsUMAOmE8k0D_F5eRjL-8H8ft=eRw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOFdcFNYHgupvMChb4NedMsUMAOmE8k0D_F5eRjL-8H8ft=eRw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 21, 2014 at 06:04:51PM -0400, Peter Foley wrote:
> The intention of these changes was to generate more compiliation
> coverage for code in Documentation/

Sounds good.

> The underlying issue is that this doesn't work for cross-compiling
> because kbuild doesn't have cross-compile support for userspace code.

Well, my testptp does cross compile just fine. All it needs is the glibc
library bundled with the tool chain and the kernel headers.

> I submitted a patch to disable building Documentation when
> cross-compiling, as the consensus in the thread that resulted in that
> patch (https://lkml.org/lkml/2014/10/8/510) was that implementing
> targetprogs in kbuild was not currently worth it.

So this patch did not make it in, right?

Otherwise people wouldn't be disabling cross compilation ad hoc, like
in the patch that started this thread.

> I can try to take a crack at adding targetprogs support, but I'm
> rather busy right now, so it may take a little while.

No rush, please do.

In the mean time, I would like to restore the testptp.mk that *does*
cross compile, so that people may use the test program if they
want. In fact I use this all the time, and so I am a bit annoyed that
something working was deleted and replaced with something broken.

Thanks,
Richard
