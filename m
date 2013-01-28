Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754689Ab3A1Jwa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 04:52:30 -0500
Received: from mail.skyhub.de ([78.46.96.112]:53873 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752431Ab3A1JwP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 04:52:15 -0500
Date: Mon, 28 Jan 2013 10:55:01 +0100
From: Borislav Petkov <bp@alien8.de>
To: Mike Galbraith <efault@gmx.de>
Cc: Alex Shi <alex.shi@intel.com>, torvalds@linux-foundation.org,
        mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, pjt@google.com,
        namhyung@kernel.org, vincent.guittot@linaro.org,
        gregkh@linuxfoundation.org, preeti@linux.vnet.ibm.com,
        viresh.kumar@linaro.org, linux-kernel@vger.kernel.org
Subject: Re: [patch v4 0/18] sched: simplified fork, release load avg and
 power awareness scheduling
Message-ID: <20130128095501.GB6109@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Mike Galbraith <efault@gmx.de>, Alex Shi <alex.shi@intel.com>,
	torvalds@linux-foundation.org, mingo@redhat.com,
	peterz@infradead.org, tglx@linutronix.de, akpm@linux-foundation.org,
	arjan@linux.intel.com, pjt@google.com, namhyung@kernel.org,
	vincent.guittot@linaro.org, gregkh@linuxfoundation.org,
	preeti@linux.vnet.ibm.com, viresh.kumar@linaro.org,
	linux-kernel@vger.kernel.org
References: <1358996820-23036-1-git-send-email-alex.shi@intel.com>
 <20130124094439.GB13463@pd.tnic>
 <51014E34.60309@intel.com>
 <510493E4.8060602@intel.com>
 <1359261385.5803.46.camel@marge.simpson.net>
 <20130127103508.GB8894@pd.tnic>
 <51052ACB.3070703@intel.com>
 <1359301903.5805.11.camel@marge.simpson.net>
 <1359350266.5783.39.camel@marge.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1359350266.5783.39.camel@marge.simpson.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 28, 2013 at 06:17:46AM +0100, Mike Galbraith wrote:
> Zzzt.  Wish I could turn turbo thingy off.

Try setting /sys/devices/system/cpu/cpufreq/boost to 0.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
