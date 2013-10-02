Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755349Ab3JBRbM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 13:31:12 -0400
Received: from mail-bk0-f47.google.com ([209.85.214.47]:59513 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754189Ab3JBRbK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 13:31:10 -0400
MIME-Version: 1.0
In-Reply-To: <63caad476ca6b7f3481d5512febcb4ef3db72209.1380703263.git.agordeev@redhat.com>
References: <cover.1380703262.git.agordeev@redhat.com>
	<63caad476ca6b7f3481d5512febcb4ef3db72209.1380703263.git.agordeev@redhat.com>
Date: Wed, 2 Oct 2013 10:31:09 -0700
Message-ID: <CAPcyv4j=Huz8d+00vMJa8mCFCKWeNG9-XAc1u19v89fNruM9kg@mail.gmail.com>
Subject: Re: [PATCH RFC 34/77] ioat: Update MSI/MSI-X interrupts enablement code
From: "Williams, Dan J" <dan.j.williams@intel.com>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: linux-kernel@vger.kernel.org, Jon Mason <jon.mason@intel.com>,
        Dave Jiang <dave.jiang@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ dropping all cc's except lkml ]

On Wed, Oct 2, 2013 at 3:48 AM, Alexander Gordeev <agordeev@redhat.com> wrote:
> As result of recent re-design of the MSI/MSI-X interrupts enabling
> pattern this driver has to be updated to use the new technique to
> obtain a optimal number of MSI/MSI-X interrupts required.
>

What happens if this patch is not applied.  This changelog does not
have enough information for me to judge the patch.  Unless I missed it
I do not see a patch 00/77 explaining the background of the change,
and a quick search did not turn up a discussion of why drivers now
need to call pci_msix_table_size() prior to pci_enable_msix.

> Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
> ---

Not sure why everybody needed to be cc'd on this one patch.  Please
put targeted cc's in the patches themselves.  If anything only patch
00/77 should go to the union of all addresses.

--
Dan
