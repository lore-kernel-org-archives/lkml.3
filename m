Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758546Ab3JOKVt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 06:21:49 -0400
Received: from mga02.intel.com ([134.134.136.20]:1084 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758358Ab3JOKVs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 06:21:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,498,1378882800"; 
   d="scan'208";a="411173705"
Message-ID: <1381832537.9823.3.camel@karhu.fi.intel.com>
Subject: Re: [PATCH 2/2 for 3.12-rc6] Revert "partitions/efi: account for
 pmbr size in lba"
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Davidlohr Bueso <davidlohr@hp.com>, Matt Fleming <matt.fleming@intel.com>,
        Karel Zak <kzak@redhat.com>,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>,
        Doug Anderson <dianders@chromium.org>
Date: Tue, 15 Oct 2013 13:22:17 +0300
In-Reply-To: <20131014112642.8efe63022ea05b07ced7fad8@linux-foundation.org>
References: <1381750909-20082-1-git-send-email-dedekind1@gmail.com>
	 <1381750909-20082-2-git-send-email-dedekind1@gmail.com>
	 <20131014112642.8efe63022ea05b07ced7fad8@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-10-14 at 11:26 -0700, Andrew Morton wrote:
> On Mon, 14 Oct 2013 14:41:49 +0300 Artem Bityutskiy <dedekind1@gmail.com> wrote:
> 
> > This reverts commit 27a7c642174eaec627f6a3a254035bf8abd02c5e.
> > 
> > This patch breaks existing systems, for example, Tizen IVI images do not boot
> > the way they have always been booted because of this patch.
> 
> Does Doug's patch fix this?

Yes, thanks.

-- 
Best Regards,
Artem Bityutskiy

