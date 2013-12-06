Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757743Ab3LFQGO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 11:06:14 -0500
Received: from mail.skyhub.de ([78.46.96.112]:44139 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756559Ab3LFQGM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 11:06:12 -0500
Date: Fri, 6 Dec 2013 17:06:08 +0100
From: Borislav Petkov <bp@alien8.de>
To: "Ren, Qiaowei" <qiaowei.ren@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Xudong Hao <xudong.hao@intel.com>,
        "Liu, Jinsong" <jinsong.liu@intel.com>
Subject: Re: [PATCH 1/3] x86, mpx: add documentation on Intel MPX
Message-ID: <20131206160607.GE6694@pd.tnic>
References: <1386355976-11732-1-git-send-email-qiaowei.ren@intel.com>
 <20131206132648.GB6694@pd.tnic>
 <9E0BE1322F2F2246BD820DA9FC397ADE014A4322@SHSMSX102.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <9E0BE1322F2F2246BD820DA9FC397ADE014A4322@SHSMSX102.ccr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 06, 2013 at 03:55:10PM +0000, Ren, Qiaowei wrote:
> It is from public introduction and specification, you can refer to
http://software.intel.com/en-us/articles/introduction-to-intel-memory-protection-extensions

Yep, saw it there too. Which doesn't make it any less strange :)

Btw, if you're going to quote the public documentation, why even add the
text file here? You can simply add the link above as a comment to the
code or as a oneliner somewhere in Documentation/x86/.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
