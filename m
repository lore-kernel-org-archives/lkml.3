Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753703Ab3I0Oc5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 10:32:57 -0400
Received: from mail.skyhub.de ([78.46.96.112]:44022 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752323Ab3I0Ocw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 10:32:52 -0400
Date: Fri, 27 Sep 2013 16:32:49 +0200
From: Borislav Petkov <bp@alien8.de>
To: Ingo Molnar <mingo@kernel.org>
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org, huawei.libin@huawei.com,
        wangyijing@huawei.com, fenghua.yu@intel.com, tglx@linutronix.de,
        guohanjun@huawei.com, paul.gortmaker@windriver.com,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86/smpboot: Fix announce_cpu() to printk() the
 last "OK" properly
Message-ID: <20130927143249.GD4422@pd.tnic>
References: <1378378676-18276-1-git-send-email-huawei.libin@huawei.com>
 <tip-52239484bf8aec031afa84ae08aa88224d819b93@git.kernel.org>
 <20130925100722.GB3433@nazgul.tnic>
 <20130925182936.GD16693@gmail.com>
 <20130926231545.GD10123@pd.tnic>
 <20130927065115.GA6852@gmail.com>
 <20130927103802.GA4422@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130927103802.GA4422@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 27, 2013 at 12:38:02PM +0200, Borislav Petkov wrote:
> On Fri, Sep 27, 2013 at 08:51:15AM +0200, Ingo Molnar wrote:
> 
> <snip stuff to do>
> 
> > (and I hope you learned the lesson about sending improvement patches
> > against long-bitrotten code, as the new x86 CPU bootup printout format
> > code maintainer!)

Ok, here it is:

[    0.075410] smpboot: Booting Node   0, Processors:      #1  #2  #3  #4  #5  #6  #7 OK
[    0.645005] smpboot: Booting Node   1, Processors:  #8  #9 #10 #11 #12 #13 #14 #15 OK
[    1.251005] smpboot: Booting Node   2, Processors: #16 #17 #18 #19 #20 #21 #22 #23 OK
[    1.853005] smpboot: Booting Node   3, Processors: #24 #25 #26 #27 #28 #29 #30 #31 OK
[    2.455005] smpboot: Booting Node   4, Processors: #32 #33 #34 #35 #36 #37 #38 #39 OK
[    3.074005] smpboot: Booting Node   5, Processors: #40 #41 #42 #43 #44 #45 #46 #47 OK
[    3.700005] smpboot: Booting Node   6, Processors: #48 #49 #50 #51 #52 #53 #54 #55 OK
[    4.320005] smpboot: Booting Node   7, Processors: #56 #57 #58 #59 #60 #61 #62 #63 OK
[    4.945472] Brought up 64 CPUs

smaller boxes:

[    0.072367] smpboot: Booting Node   0, Processors:    #1 #2 #3 #4 #5 #6 #7 OK
[    0.686329] Brought up 8 CPUs

Libin, I'd appreciate it if you run the following patches on your box to
make sure everything is still ok.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
