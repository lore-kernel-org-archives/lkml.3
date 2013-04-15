Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753172Ab3DOJwQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 05:52:16 -0400
Received: from mail.skyhub.de ([78.46.96.112]:40721 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751169Ab3DOJwO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 05:52:14 -0400
Date: Mon, 15 Apr 2013 11:52:03 +0200
From: Borislav Petkov <bp@alien8.de>
To: Alex Shi <alex.shi@intel.com>
Cc: Len Brown <lenb@kernel.org>, mingo@redhat.com, peterz@infradead.org,
        tglx@linutronix.de, akpm@linux-foundation.org, arjan@linux.intel.com,
        pjt@google.com, namhyung@kernel.org, efault@gmx.de,
        morten.rasmussen@arm.com, vincent.guittot@linaro.org,
        gregkh@linuxfoundation.org, preeti@linux.vnet.ibm.com,
        viresh.kumar@linaro.org, linux-kernel@vger.kernel.org,
        len.brown@intel.com, rafael.j.wysocki@intel.com, jkosina@suse.cz,
        clark.williams@gmail.com, tony.luck@intel.com, keescook@chromium.org,
        mgorman@suse.de, riel@redhat.com,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: Re: [patch v7 0/21] sched: power aware scheduling
Message-ID: <20130415095203.GA26524@pd.tnic>
References: <1365040862-8390-1-git-send-email-alex.shi@intel.com>
 <516724F5.20504@kernel.org>
 <5167C9FA.8050406@intel.com>
 <20130412162348.GE2368@pd.tnic>
 <516A0652.8040505@intel.com>
 <20130414155925.GC20547@pd.tnic>
 <516B9859.70004@intel.com>
 <516B9B57.3030902@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <516B9B57.3030902@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 15, 2013 at 02:16:55PM +0800, Alex Shi wrote:
> And I need to say again. the powersaving policy just effect on system
> under utilisation. when system goes busy, it won't has effect.
> performance oriented policy will take over balance behaviour.

And AFACU your patches, you do this automatically, right? In which case,
an underutilized system will have switched to powersaving balancing and
will use *more* energy to retire the workload. Correct?

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
