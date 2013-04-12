Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755650Ab3DLRNA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 13:13:00 -0400
Received: from mail.skyhub.de ([78.46.96.112]:56971 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755504Ab3DLRM6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 13:12:58 -0400
Date: Fri, 12 Apr 2013 19:12:51 +0200
From: Borislav Petkov <bp@alien8.de>
To: Mike Galbraith <efault@gmx.de>
Cc: Alex Shi <alex.shi@intel.com>, Len Brown <lenb@kernel.org>,
        mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, pjt@google.com,
        namhyung@kernel.org, morten.rasmussen@arm.com,
        vincent.guittot@linaro.org, gregkh@linuxfoundation.org,
        preeti@linux.vnet.ibm.com, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org, len.brown@intel.com,
        rafael.j.wysocki@intel.com, jkosina@suse.cz, clark.williams@gmail.com,
        tony.luck@intel.com, keescook@chromium.org, mgorman@suse.de,
        riel@redhat.com, Linux PM list <linux-pm@vger.kernel.org>
Subject: Re: [patch v7 0/21] sched: power aware scheduling
Message-ID: <20130412171251.GF2368@pd.tnic>
References: <1365040862-8390-1-git-send-email-alex.shi@intel.com>
 <516724F5.20504@kernel.org>
 <5167C9FA.8050406@intel.com>
 <20130412162348.GE2368@pd.tnic>
 <1365785311.5814.36.camel@marge.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1365785311.5814.36.camel@marge.simpson.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 12, 2013 at 06:48:31PM +0200, Mike Galbraith wrote:
> (just saying there are other aspects besides joules in there)

Yeah, but we don't allow any regressions in sched*, do we? Can we pick
only the good cherries? :-)

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
