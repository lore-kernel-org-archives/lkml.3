Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752270Ab3JVIhF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 04:37:05 -0400
Received: from mail.skyhub.de ([78.46.96.112]:46739 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751000Ab3JVIhC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 04:37:02 -0400
Date: Tue, 22 Oct 2013 10:37:02 +0200
From: Borislav Petkov <bp@alien8.de>
To: Tony Luck <tony.luck@gmail.com>
Cc: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        "Chen, Gong" <gong.chen@linux.intel.com>,
        "joe@perches.com" <joe@perches.com>,
        "m.chehab@samsung.com" <m.chehab@samsung.com>,
        "arozansk@redhat.com" <arozansk@redhat.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 4/9] ACPI, x86: Extended error log driver for x86
 platform
Message-ID: <20131022083702.GB10268@nazgul.tnic>
References: <20131019095753.GA26338@pd.tnic>
 <52657a78162905670f@agluck-desk.sc.intel.com>
 <CA+8MBbLnxAiV-ccpn_HUiiP9Fp7qXWqy_i+RPu6mUTAxzV4uHA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CA+8MBbLnxAiV-ccpn_HUiiP9Fp7qXWqy_i+RPu6mUTAxzV4uHA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 21, 2013 at 03:39:20PM -0700, Tony Luck wrote:
> I folded that back into the series. Also switched out the test on
> whether to print the "No further action is required" message to only
> do so for corrected errors. Cleaned up some of the commit messages,
>
> The result is sitting at:
> git://git.kernel.org/pub/scm/linux/kernel/git/ras/ras.git eMCA
>
> Anything we missed?

Doesn't look so, at a first glance. But I agree with you - this stuff
will be subject to change as we go along and we make up our mind about
what exactly is sufficient and necessary to do proper decoding.

I like the idea of keeping an open mind about it. :-)

Thanks.
