Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752883AbaKLOM6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 09:12:58 -0500
Received: from mail.skyhub.de ([78.46.96.112]:48153 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752516AbaKLOM5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 09:12:57 -0500
Date: Wed, 12 Nov 2014 15:12:50 +0100
From: Borislav Petkov <bp@alien8.de>
To: "Anvin, H Peter" <h.peter.anvin@intel.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        David Airlie <airlied@linux.ie>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH 3/6] x86: Add support for the clwb instruction
Message-ID: <20141112141250.GE16807@pd.tnic>
References: <1415731396-19364-1-git-send-email-ross.zwisler@linux.intel.com>
 <1415731396-19364-4-git-send-email-ross.zwisler@linux.intel.com>
 <20141112123909.GD16807@pd.tnic>
 <C40DC70F50313144AB3AF8625D4F407F71D61056@ORSMSX101.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <C40DC70F50313144AB3AF8625D4F407F71D61056@ORSMSX101.amr.corp.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 12, 2014 at 01:38:45PM +0000, Anvin, H Peter wrote:
> No, it doesn't.  x86 requires 3.4+ at a minimum.

The only test I see is:

#if GCC_VERSION < 30200
# error Sorry, your compiler is too old - please upgrade it.
#endif

And even if we do require 3.4, the build fails with 4.1+ so...

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
