Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964950Ab3HHKCn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 06:02:43 -0400
Received: from mail.skyhub.de ([78.46.96.112]:57577 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934100Ab3HHKCl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 06:02:41 -0400
Date: Thu, 8 Aug 2013 12:02:38 +0200
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Yu, Fenghua" <fenghua.yu@intel.com>,
        Torsten Kaiser <just.for.lkml@googlemail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Jacob Shin <jacob.shin@amd.com>,
        Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/5] x86, AMD: cleanup: merge common code in early
 microcode loading
Message-ID: <20130808100238.GA27974@pd.tnic>
References: <20130723230026.394a5ee1@googlemail.com>
 <20130724133254.GE30777@pd.tnic>
 <3E5A0FA7E9CA944F9D5414FEC6C712205A53B73A@ORSMSX106.amr.corp.intel.com>
 <78b1bca9-80bb-4e60-af3a-738424babfd0@email.android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <78b1bca9-80bb-4e60-af3a-738424babfd0@email.android.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 07, 2013 at 07:22:39PM -0700, H. Peter Anvin wrote:
> How much does this matter?

I know what you're asking :-)

And no, it doesn't really matter as we fail in the patch version check
so maybe only a comment will suffice here so that people don't get
confused.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
