Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755722Ab3ENDPC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 23:15:02 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:39059 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751788Ab3ENDPA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 23:15:00 -0400
MIME-Version: 1.0
In-Reply-To: <100D68C7BA14664A8938383216E40DE027F80E97@fmsmsx111.amr.corp.intel.com>
References: <1368419898-25493-1-git-send-email-sachin.kamat@linaro.org>
	<100D68C7BA14664A8938383216E40DE027F80E97@fmsmsx111.amr.corp.intel.com>
Date: Tue, 14 May 2013 08:44:59 +0530
Message-ID: <CAK9yfHxfu-M-78mkp29d8tTStOjDjNRmPDTkQQbcn5D8WnY-KA@mail.gmail.com>
Subject: Re: [PATCH 1/1] NVMe: Remove redundant version.h header include
From: Sachin Kamat <sachin.kamat@linaro.org>
To: "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "vishal.l.verma@linux.intel.com" <vishal.l.verma@linux.intel.com>,
        "Busch, Keith" <keith.busch@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13 May 2013 19:20, Wilcox, Matthew R <matthew.r.wilcox@intel.com> wrote:
> I can't apply this patch.  Instead of following what it says in MAINTAINERS, you've sent it to my Exchange address.  And now it's all mangled.

I ran the get_maintainer.pl on the patch and this is what it gave me:

scripts/get_maintainer.pl
0001-NVMe-Remove-redundant-version.h-header-include.patch
Matthew Wilcox <matthew.r.wilcox@intel.com> (commit_signer:6/7=86%)
Vishal Verma <vishal.l.verma@linux.intel.com> (commit_signer:5/7=71%)
Keith Busch <keith.busch@intel.com> (commit_signer:3/7=43%)
Sachin Kamat <sachin.kamat@linaro.org> (commit_signer:1/7=14%)
linux-kernel@vger.kernel.org (open list)

I think with Dan's patch [1] it should provide the right info.
Resending this patch to the list pointed out by you.

[1] https://lkml.org/lkml/2013/5/13/302


>
> NVM EXPRESS DRIVER
> M:      Matthew Wilcox <willy@linux.intel.com>
> L:      linux-nvme@lists.infradead.org

-- 
With warm regards,
Sachin
