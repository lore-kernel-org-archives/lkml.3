Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756134AbbAFSyi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 13:54:38 -0500
Received: from mga11.intel.com ([192.55.52.93]:20338 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755717AbbAFSyh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 13:54:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,709,1413270000"; 
   d="scan'208";a="633328332"
Message-ID: <54AC2F62.40708@linux.intel.com>
Date: Tue, 06 Jan 2015 10:54:26 -0800
From: Dave Hansen <dave.hansen@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>
CC: Andi Kleen <andi@firstfloor.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        ilya.enkovich@intel.com
Subject: Re: [PATCH 3.19 3/3] x86, mpx: Change the MPX enable/disable API
 to arch_prctl
References: <cover.1419900414.git.luto@amacapital.net> <d5efe02b133f6d9fb4cb9d03e0f0b9e17211c06f.1419900414.git.luto@amacapital.net> <54A64E6D.1020304@linux.intel.com> <87mw5x0xjz.fsf@tassilo.jf.intel.com> <54AAFFA3.6000901@linux.intel.com> <CALCETrUeMS7zwjXfSMN-6A8-gpLc68n7U5Y6SPdzgw6hSbYGNg@mail.gmail.com> <20150106040428.GR2915@two.firstfloor.org> <CALCETrU3oHO5Rjqp_DmJaOkEBOtZpQ+f99xXiY5=84JfJphZCA@mail.gmail.com> <54AC1FFB.7030504@linux.intel.com> <CALCETrVJyBR7NoZvC=A4htRtm-fLe5NUEGUdvJRL28adU4MhUg@mail.gmail.com> <54AC29B1.70004@linux.intel.com> <CALCETrUE+kZeC+vx1OnpYsuL-b0u3fFJe3QfjeZQ=hCiQRPrHg@mail.gmail.com>
In-Reply-To: <CALCETrUE+kZeC+vx1OnpYsuL-b0u3fFJe3QfjeZQ=hCiQRPrHg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/06/2015 10:41 AM, Andy Lutomirski wrote:
> The runtime seems to be here:
> 
> https://software.intel.com/protected-download/267266/144917
> 
> but I'm not going to accept the EULA.

That is not the code I'm talking about here.

The SDE doesn't use the prctl()s.  The runtime you're pointing to here
does not use the prctls() (it predates them).  It's not the same as the
code being pushed in to gcc.



