Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754182Ab3I2C5S (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 22:57:18 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:51034 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753732Ab3I2C5Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 22:57:16 -0400
Message-ID: <1380423319.5601.4.camel@marge.simpson.net>
Subject: Re: [PATCH 2/2] x86: Cleanup boot CPUs table
From: Mike Galbraith <bitbucket@online.de>
To: Ingo Molnar <mingo@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>, hpa@zytor.com,
        linux-kernel@vger.kernel.org, huawei.libin@huawei.com,
        wangyijing@huawei.com, fenghua.yu@intel.com, tglx@linutronix.de,
        guohanjun@huawei.com, paul.gortmaker@windriver.com,
        linux-tip-commits@vger.kernel.org
Date: Sun, 29 Sep 2013 04:55:19 +0200
In-Reply-To: <20130928082542.GA18198@gmail.com>
References: <1378378676-18276-1-git-send-email-huawei.libin@huawei.com>
	 <tip-52239484bf8aec031afa84ae08aa88224d819b93@git.kernel.org>
	 <20130925100722.GB3433@nazgul.tnic> <20130925182936.GD16693@gmail.com>
	 <20130926231545.GD10123@pd.tnic> <20130927065115.GA6852@gmail.com>
	 <20130927103802.GA4422@pd.tnic> <20130927143249.GD4422@pd.tnic>
	 <20130927143554.GF4422@pd.tnic> <20130928082542.GA18198@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:AImcSANSvG+c/mHL7KnJQVPXDEpYOM4FK/SqNMHQGd1
 mhxdZEU+oqzVkXgTNfCVyB0NUmGN9kAJ7ZUa0DyNDUe3bBF1Zy
 +lXBgwtsxaRQ2QMwwhh6nvo+6DO7xh3ucXlcLYP0aVKbOBdeNT
 OhBq9POP9VFrR8dyYBqu7txRdNUeahyOSQil1CjATqtfYSE1TT
 /qfVQ8PrPMVd3ib/Fbcbi0qhTdlxDQBBbDBdt3s7MoOaWHbTjC
 QHnh1pBCFgPm8y/VEBzMq46/Ks41J3jd4FcOOEWvpeZRyANbAl
 ccniEIQikTP3cLGF10xDAMrFYTKXp4mG1FNWPwwrWDrQIjnL2x
 kkIE8gOs5aSxTDITLh/92zk02FMp0dhFOgXmdoMPmPo7lnVuXv
 ZLlqWsk2ekxbw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-09-28 at 10:25 +0200, Ingo Molnar wrote:

> > [    0.072367] x86: Booting node #0, CPUs:     #1 #2 #3 #4 #5 #6 #7 <-- 
> > [    0.686329] x86: Booted up 1 node, 8 CPUs
                                          ^ 
> - Added nodes count to the 'Booted up' line. Since we count nodes and
>     CPUs, we might as well want to demonstrate our superior counting
>     skills and print out both.

What superior counting skills?  ;-)

