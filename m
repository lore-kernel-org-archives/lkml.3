Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759601Ab3D3Ilo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 04:41:44 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:56998 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759146Ab3D3Ilk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 04:41:40 -0400
Date: Tue, 30 Apr 2013 10:41:35 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Mike Galbraith <bitbucket@online.de>
Cc: Len Brown <lenb@kernel.org>, Borislav Petkov <bp@alien8.de>,
        Alex Shi <alex.shi@intel.com>, mingo@redhat.com, peterz@infradead.org,
        tglx@linutronix.de, akpm@linux-foundation.org, arjan@linux.intel.com,
        pjt@google.com, namhyung@kernel.org, morten.rasmussen@arm.com,
        vincent.guittot@linaro.org, gregkh@linuxfoundation.org,
        preeti@linux.vnet.ibm.com, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org, len.brown@intel.com,
        rafael.j.wysocki@intel.com, jkosina@suse.cz, clark.williams@gmail.com,
        tony.luck@intel.com, keescook@chromium.org, mgorman@suse.de,
        riel@redhat.com, Linux PM list <linux-pm@vger.kernel.org>
Subject: Re: [patch v7 0/21] sched: power aware scheduling
Message-ID: <20130430084135.GA21473@gmail.com>
References: <1365040862-8390-1-git-send-email-alex.shi@intel.com>
 <516724F5.20504@kernel.org>
 <5167C9FA.8050406@intel.com>
 <20130412162348.GE2368@pd.tnic>
 <1365785311.5814.36.camel@marge.simpson.net>
 <516F19EE.5060309@kernel.org>
 <1366989087.30242.11.camel@marge.simpson.net>
 <1367298972.4616.41.camel@marge.simpson.net>
 <1367310625.4616.71.camel@marge.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1367310625.4616.71.camel@marge.simpson.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mike Galbraith <bitbucket@online.de> wrote:

> On Tue, 2013-04-30 at 07:16 +0200, Mike Galbraith wrote:
> 
> > Well now, that's not exactly what I expected to see for AIM7 compute.
> > Filesystem is munching cycles otherwise used for compute when load is
> > spread across the whole box vs consolidated.
> 
> So AIM7 compute performance delta boils down to: powersaving stacks
> tasks, so they pat single bit of spinning rust sequentially/gently.

So AIM7 with real block IO improved, due to sequentiality. Does it improve 
if AIM7 works on an SSD, or into ramdisk?

Which are the workloads where 'powersaving' mode hurts workload 
performance measurably?

Thanks,

	Ingo
