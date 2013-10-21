Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752462Ab3JUWjX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 18:39:23 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:38394 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751463Ab3JUWjV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 18:39:21 -0400
MIME-Version: 1.0
In-Reply-To: <52657a78162905670f@agluck-desk.sc.intel.com>
References: <20131019095753.GA26338@pd.tnic>
	<52657a78162905670f@agluck-desk.sc.intel.com>
Date: Mon, 21 Oct 2013 15:39:20 -0700
Message-ID: <CA+8MBbLnxAiV-ccpn_HUiiP9Fp7qXWqy_i+RPu6mUTAxzV4uHA@mail.gmail.com>
Subject: Re: [PATCH v3 4/9] ACPI, x86: Extended error log driver for x86 platform
From: Tony Luck <tony.luck@gmail.com>
To: Borislav Petkov <bp@alien8.de>
Cc: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        "Chen, Gong" <gong.chen@linux.intel.com>,
        "joe@perches.com" <joe@perches.com>,
        "m.chehab@samsung.com" <m.chehab@samsung.com>,
        "arozansk@redhat.com" <arozansk@redhat.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 21, 2013 at 12:03 PM, Luck, Tony <tony.luck@intel.com> wrote:
> So this is on top of the 9 patch series (using the V4 that Chen Gong
> posted for part 4/9 and V3 for all the others).  Obviously it should
> be folded back into the series if we go this way.
>
> It's a bit simplistic right now - the registered function just returns
> NOTIFY_DONE in all cases so it will not disturb processing by any other
> registered functions - we can make it smarter later.

I folded that back into the series. Also switched out the test on whether to
print the "No further action is required" message to only do so for corrected
errors.  Cleaned up some of the commit messages,

The result is sitting at:
git://git.kernel.org/pub/scm/linux/kernel/git/ras/ras.git eMCA

Anything we missed?

-Tony
