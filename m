Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755388Ab3EPHRv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 03:17:51 -0400
Received: from mga14.intel.com ([143.182.124.37]:62782 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754310Ab3EPHRu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 03:17:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,681,1363158000"; 
   d="scan'208";a="303235155"
Message-ID: <1368688777.15764.175.camel@sauron.fi.intel.com>
Subject: Re: [PATCH v2 0/4] Export the ecc step size to user applications
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Huang Shijie <shijie8@gmail.com>
Cc: Huang Shijie <b32955@freescale.com>, David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Thu, 16 May 2013 10:19:37 +0300
In-Reply-To: <CAMiH66GygmwvfZrwys7RoeoY4Q_fFkfbiZF_pJN4RxQBPaz0fw@mail.gmail.com>
References: <1368607606-4344-1-git-send-email-b32955@freescale.com>
	 <1368619642.15764.96.camel@sauron.fi.intel.com>
	 <CAMiH66GygmwvfZrwys7RoeoY4Q_fFkfbiZF_pJN4RxQBPaz0fw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-05-15 at 22:19 +0800, Huang Shijie wrote:
> ok.   can i send a separate patch to fix it?
> or a new version patch set？
> 
Just a follow-up patch. I would like to let this patch-set sit in the
mailing list for some time before I pick it, in case someone wants to
comment.

Also, surely the things you expose are the real ECC step and ECC
strength? I think the datasheet ones in your other patch-set should be
named differently to make sure the reader of the code understands that
they are only the recommended datasheet values, not necessarily the
values which are actually in use.

-- 
Best Regards,
Artem Bityutskiy

