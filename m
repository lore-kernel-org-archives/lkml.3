Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752656AbaHLHPZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 03:15:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37157 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751464AbaHLHPY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 03:15:24 -0400
Date: Tue, 12 Aug 2014 15:14:43 +0800
From: Dave Young <dyoung@redhat.com>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Matt Fleming <matt.fleming@intel.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        hpa@zytor.com, Alessandro Zummo <a.zummo@towertech.it>,
        Leif Lindholm <leif.lindholm@linaro.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Mark Salter <msalter@redhat.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-efi@vger.kernel.org,
        rtc-linux@googlegroups.com
Subject: Re: [PATCH 1/5] efi: move noefi early param code out of x86 arch code
Message-ID: <20140812071443.GB14031@darkstar.nay.redhat.com>
References: <1407823822-23829-1-git-send-email-dyoung@redhat.com>
 <53E9B9B3.1050504@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53E9B9B3.1050504@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/11/14 at 11:52pm, Randy Dunlap wrote:
> On 08/11/14 23:10, Dave Young wrote:
> > noefi param can be used for arches other than X86 later, thus move it out of
> > x86 platform code.
> > 
> > Signed-off-by: Dave Young <dyoung@redhat.com>
> > ---
> >  arch/x86/platform/efi/efi.c | 10 +---------
> >  drivers/firmware/efi/efi.c  | 13 +++++++++++++
> >  include/linux/efi.h         |  1 +
> >  3 files changed, 15 insertions(+), 9 deletions(-)
> 
> This line in Documentation/kernel-parameters.txt needs to be updated:
> 
> 	noefi		[X86] Disable EFI runtime services support.

Randy, thanks

Will update the documentation.

Dave
