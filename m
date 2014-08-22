Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932294AbaHVPrZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 11:47:25 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:54776 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756466AbaHVPrX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 11:47:23 -0400
Date: Fri, 22 Aug 2014 16:47:19 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Will Deacon <will.deacon@arm.com>
Cc: Dave Young <dyoung@redhat.com>, Matt Fleming <matt.fleming@intel.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Leif Lindholm <leif.lindholm@linaro.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        "msalter@redhat.com" <msalter@redhat.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        Daniel Kiper <daniel.kiper@oracle.com>, Russ Anderson <rja@sgi.com>
Subject: Re: [PATCH 5/7 update] arm64/efi: do not enter virtual mode in case
 booting with efi=noruntime or noefi
Message-ID: <20140822154719.GN29733@console-pimps.org>
References: <1408007731-15081-1-git-send-email-dyoung@redhat.com>
 <1408007731-15081-5-git-send-email-dyoung@redhat.com>
 <20140815150952.GY27466@arm.com>
 <20140818013007.GB3379@darkstar.nay.redhat.com>
 <20140822151007.GA17255@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140822151007.GA17255@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Aug, at 04:10:07PM, Will Deacon wrote:
> 
> Are you sending these via the efi tree as part of this series, or do you
> need me to pick anything up into the arm64 tree?

I was planning on taking the entire series through the EFI tree (once
I've had chance to review it).

Does that work?

-- 
Matt Fleming, Intel Open Source Technology Center
