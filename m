Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932480AbbAFTQx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 14:16:53 -0500
Received: from one.firstfloor.org ([193.170.194.197]:57527 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932436AbbAFTQv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 14:16:51 -0500
Date: Tue, 6 Jan 2015 20:16:49 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Andy Lutomirski <luto@amacapital.net>, Andi Kleen <andi@firstfloor.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        ilya.enkovich@intel.com
Subject: Re: [PATCH 3.19 3/3] x86, mpx: Change the MPX enable/disable API
 to arch_prctl
Message-ID: <20150106191649.GU2915@two.firstfloor.org>
References: <87mw5x0xjz.fsf@tassilo.jf.intel.com>
 <54AAFFA3.6000901@linux.intel.com>
 <CALCETrUeMS7zwjXfSMN-6A8-gpLc68n7U5Y6SPdzgw6hSbYGNg@mail.gmail.com>
 <20150106040428.GR2915@two.firstfloor.org>
 <CALCETrU3oHO5Rjqp_DmJaOkEBOtZpQ+f99xXiY5=84JfJphZCA@mail.gmail.com>
 <54AC1FFB.7030504@linux.intel.com>
 <CALCETrVJyBR7NoZvC=A4htRtm-fLe5NUEGUdvJRL28adU4MhUg@mail.gmail.com>
 <54AC29B1.70004@linux.intel.com>
 <CALCETrUE+kZeC+vx1OnpYsuL-b0u3fFJe3QfjeZQ=hCiQRPrHg@mail.gmail.com>
 <54AC2F62.40708@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54AC2F62.40708@linux.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 06, 2015 at 10:54:26AM -0800, Dave Hansen wrote:
> On 01/06/2015 10:41 AM, Andy Lutomirski wrote:
> > The runtime seems to be here:
> > 
> > https://software.intel.com/protected-download/267266/144917
> > 
> > but I'm not going to accept the EULA.
> 
> That is not the code I'm talking about here.

The MPX run time patch is here (may not be the latest version)

https://gcc.gnu.org/ml/gcc-patches/2014-11/msg01026.html

-Andi
