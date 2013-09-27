Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751118Ab3I0KiN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 06:38:13 -0400
Received: from mail.skyhub.de ([78.46.96.112]:37552 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750871Ab3I0KiG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 06:38:06 -0400
Date: Fri, 27 Sep 2013 12:38:02 +0200
From: Borislav Petkov <bp@alien8.de>
To: Ingo Molnar <mingo@kernel.org>
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org, huawei.libin@huawei.com,
        wangyijing@huawei.com, fenghua.yu@intel.com, tglx@linutronix.de,
        guohanjun@huawei.com, paul.gortmaker@windriver.com,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86/smpboot: Fix announce_cpu() to printk() the
 last "OK" properly
Message-ID: <20130927103802.GA4422@pd.tnic>
References: <1378378676-18276-1-git-send-email-huawei.libin@huawei.com>
 <tip-52239484bf8aec031afa84ae08aa88224d819b93@git.kernel.org>
 <20130925100722.GB3433@nazgul.tnic>
 <20130925182936.GD16693@gmail.com>
 <20130926231545.GD10123@pd.tnic>
 <20130927065115.GA6852@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130927065115.GA6852@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 27, 2013 at 08:51:15AM +0200, Ingo Molnar wrote:

<snip stuff to do>

> (and I hope you learned the lesson about sending improvement patches
> against long-bitrotten code, as the new x86 CPU bootup printout format
> code maintainer!)

Oh shit, what did I get into!? I only wanted to do a quick fix and get
back to the real, manly bugs!

:-) :-) :-)

Ok, I'll do all that you suggested and send you the results.

Btw, qemu is so cool in generating the craziest topologies and much
easier than me actually going and looking for such a real big system:

kvm -smp 64 \
-numa node,nodeid=0,cpus=0-7 \
-numa node,nodeid=1,cpus=8-15 \
-numa node,nodeid=2,cpus=16-23 \
-numa node,nodeid=3,cpus=24-31 \
-numa node,nodeid=4,cpus=32-39 \
-numa node,nodeid=5,cpus=40-47 \
-numa node,nodeid=6,cpus=48-55 \
-numa node,nodeid=7,cpus=56-63 ...

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
