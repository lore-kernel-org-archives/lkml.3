Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756703AbbAFVW7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 16:22:59 -0500
Received: from one.firstfloor.org ([193.170.194.197]:57723 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755511AbbAFVW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 16:22:58 -0500
Date: Tue, 6 Jan 2015 22:22:55 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Andi Kleen <andi@firstfloor.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        ilya.enkovich@intel.com
Subject: Re: [PATCH 3.19 3/3] x86, mpx: Change the MPX enable/disable API
 to arch_prctl
Message-ID: <20150106212255.GV2915@two.firstfloor.org>
References: <CALCETrUeMS7zwjXfSMN-6A8-gpLc68n7U5Y6SPdzgw6hSbYGNg@mail.gmail.com>
 <20150106040428.GR2915@two.firstfloor.org>
 <CALCETrU3oHO5Rjqp_DmJaOkEBOtZpQ+f99xXiY5=84JfJphZCA@mail.gmail.com>
 <54AC1FFB.7030504@linux.intel.com>
 <CALCETrVJyBR7NoZvC=A4htRtm-fLe5NUEGUdvJRL28adU4MhUg@mail.gmail.com>
 <54AC29B1.70004@linux.intel.com>
 <CALCETrUE+kZeC+vx1OnpYsuL-b0u3fFJe3QfjeZQ=hCiQRPrHg@mail.gmail.com>
 <54AC2F62.40708@linux.intel.com>
 <20150106191649.GU2915@two.firstfloor.org>
 <CALCETrUNpi1Gc-Qpmu1bJ0BVcSH2xquaY_X+YYhLjbPaQcf0_w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrUNpi1Gc-Qpmu1bJ0BVcSH2xquaY_X+YYhLjbPaQcf0_w@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Given that it doesn't seen to have been committed yet, I'm not too
> worried about compatibility.  And "prctl (43)" doesn't actually seem a
> whole lot better than "syscall(SYS_arch_prctl, ARCH_ENABLE_MPX, 0)"

This would actually fail with the EINVAL change you requested.

> (preprocessor macros ftw!).  But I don't feel that strongly about this
> point.

-Andi
