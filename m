Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757418AbaE2RDU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 13:03:20 -0400
Received: from mail-vc0-f170.google.com ([209.85.220.170]:55284 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752294AbaE2RDS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 13:03:18 -0400
MIME-Version: 1.0
In-Reply-To: <5386915f.4772e50a.0657.ffffcda4SMTPIN_ADDED_BROKEN@mx.google.com>
References: <eb791998a8ada97b204dddf2719a359149e9ae31.1400607328.git.tony.luck@intel.com>
	<20140523033438.GC16945@gchen.bj.intel.com>
	<CA+8MBb+Una+Z5Q-Pn0OoMYaaSx9sPJ3fdriMRMgN=CE1Jdp7Cg@mail.gmail.com>
	<20140527161613.GC4108@mcs.anl.gov>
	<5384d07e.4504e00a.2680.ffff8c31SMTPIN_ADDED_BROKEN@mx.google.com>
	<CA+8MBbKuBo4c2v-Y0TOk-LUJuyJsGG=twqQyAPG5WOa8Aj4GyA@mail.gmail.com>
	<53852abb.867ce00a.3cef.3c7eSMTPIN_ADDED_BROKEN@mx.google.com>
	<FDBACF11-D9F6-4DE5-A0D4-800903A243B7@gmail.com>
	<53862f6c.91148c0a.5fb0.2d0cSMTPIN_ADDED_BROKEN@mx.google.com>
	<CA+8MBbKdKy+sbov-f+1xNnj=syEM5FWR1BV85AgRJ9S+qPbWEg@mail.gmail.com>
	<5386915f.4772e50a.0657.ffffcda4SMTPIN_ADDED_BROKEN@mx.google.com>
Date: Thu, 29 May 2014 10:03:17 -0700
Message-ID: <CA+8MBbLxvZWVuUsNdPG-CTEtrAZzxrPGVFp0u74iMgYaxzwf0Q@mail.gmail.com>
Subject: Re: [PATCH] mm/memory-failure.c: support dedicated thread to handle
 SIGBUS(BUS_MCEERR_AO) thread
From: Tony Luck <tony.luck@gmail.com>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Kamil Iskra <iskra@mcs.anl.gov>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andi Kleen <andi@firstfloor.org>, Borislav Petkov <bp@suse.de>,
        Chen Gong <gong.chen@linux.jf.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> OK, I'll take this.

If you didn't already apply it, then add a "Reviewed-by: Tony Luck
<tony.luck@intel,com>"

I see that this patch is on top of my earlier ones (includes the
"force_early" argument).
That means you have both of those queued too?

Thanks

-Tony
