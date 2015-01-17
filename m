Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751349AbbAQGCj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2015 01:02:39 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:33683 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751135AbbAQGCh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2015 01:02:37 -0500
MIME-Version: 1.0
In-Reply-To: <1AE640813FDE7649BE1B193DEA596E88026B7CAD@SHSMSX101.ccr.corp.intel.com>
References: <1AE640813FDE7649BE1B193DEA596E88026B7CAD@SHSMSX101.ccr.corp.intel.com>
Date: Sat, 17 Jan 2015 17:02:31 +1100
Message-ID: <CAE1zotJapkp83cSWndWuw5brR-rCZyAyr4a1rJCO3xRucq1-Og@mail.gmail.com>
Subject: Re: About 2 ACPICA table patches
From: Octavian Purdila <octavian.purdila@intel.com>
To: "Zheng, Lv" <lv.zheng@intel.com>
Cc: "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "Box, David E" <david.e.box@intel.com>,
        "Moore, Robert" <robert.moore@intel.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Brown, Len" <len.brown@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 16, 2015 at 11:44 AM, Zheng, Lv <lv.zheng@intel.com> wrote:
> Hi, Octavian
>

Hi Lv,

> I noticed there are 2 patches you've sent to the community.
> But unfortunately I didn't find them in my mailbox.
> Let me comment you here.
>
> https://patchwork.kernel.org/patch/5501621/
> This patch seem to be correct.
> But Rafael should merge it directly via Linux because acpi_unload_table_id() is not in the ACPICA upstream.

OK, thanks for letting me know. Rafel, does the patch look ok to you?

> We expect the OSPMs to use acpi_unload_parent_table() instead.
> I have a divergences reduction series to achieve the transition.
> But they are pending for review for almost half a year.
> If you have an environment to test.
> Could you help to test this again?
> I can prepare the patchset for you.
>

Sure, if you can point me to the patch-set I can test it on my setup.

> https://patchwork.kernel.org/patch/5501561/
> This patch is correct, I've put it in the 201501 ACPICA release materials for review:
> https://patchwork.kernel.org/patch/5501621/
> The patch can be found at:
> https://github.com/zetalog/acpica/commit/281ff873
> So if it is merged, you'll see it in the upstream after 201501 ACPICA release cycle.
> And hence Linux trees doesn't need to merge this patch directly.
>

Thanks,
Tavi
