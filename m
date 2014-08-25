Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755144AbaHYKYc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 06:24:32 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:53019 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753344AbaHYKYa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 06:24:30 -0400
Date: Mon, 25 Aug 2014 11:24:26 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Dave Young <dyoung@redhat.com>
Cc: Matt Fleming <matt.fleming@intel.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        hpa@zytor.com, Alessandro Zummo <a.zummo@towertech.it>,
        Leif Lindholm <leif.lindholm@linaro.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Mark Salter <msalter@redhat.com>, Randy Dunlap <rdunlap@infradead.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-efi@vger.kernel.org, Daniel Kiper <daniel.kiper@oracle.com>,
        Russ Anderson <rja@sgi.com>
Subject: Re: [PATCH 1/7] efi: move noefi early param code out of x86 arch code
Message-ID: <20140825102426.GO29733@console-pimps.org>
References: <1408007731-15081-1-git-send-email-dyoung@redhat.com>
 <20140814092638.GB6330@darkstar.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140814092638.GB6330@darkstar.nay.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Aug, at 05:26:38PM, Dave Young wrote:
> Hi,
> 
> I addressed several comments from Matt, Randy and Will in this post.
> 
> Also rewrote the patch for efi=noruntime with using a generic param handling
> function.
> 
> CCed Xen and SGI people, removed rtc list in cc for [1-6]/7 patches

Thanks Dave, I picked all of these patches up into the 'next' branch.

-- 
Matt Fleming, Intel Open Source Technology Center
