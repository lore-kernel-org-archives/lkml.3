Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753590Ab3ILFD7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 01:03:59 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:49769 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752365Ab3ILFD6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 01:03:58 -0400
X-Nat-Received: from [202.181.97.72]:61694 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1378962223.22386
To: herbert@gondor.hengli.com.au
Cc: andr345@gmail.com, rusty@rustcorp.com.au, linux-kernel@vger.kernel.org,
        arthur.marsh@internode.on.net, tim.c.chen@linux.intel.com
Subject: Re: [3.12-rc1] Dependency on module-init-tools >= 3.11 ?
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <1374283864.22432.393.camel@schen9-DESK>
	<20130720053021.GA19689@gondor.apana.org.au>
	<201307201456.JIC35412.VFOMFJOQLOtHFS@I-love.SAKURA.ne.jp>
	<201309112043.HBD04609.FOtLSOFVQHFOJM@I-love.SAKURA.ne.jp>
	<20130912042622.GA15181@gondor.apana.org.au>
In-Reply-To: <20130912042622.GA15181@gondor.apana.org.au>
Message-Id: <201309121403.FIH09821.JtLOVOSFOFHFQM@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Thu, 12 Sep 2013 14:03:41 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 12092013 #11042881, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Herbert Xu wrote:
> This way at least you'll have a working system until your initramfs
> tool is fixed to do the right thing.

Thank you. But it is module-init-tools-3.9-21.el6_4 in RHEL 6.4.
We can't wait until Red Hat backports module-init-tools >= 3.11 to RHEL 6.x.

Since most people are already using module-init-tools >= 3.11 and
there is workaround for my case (i.e. choose built-in), just updating

  module-init-tools      0.9.10                  # depmod -V

line at "Current Minimal Requirements" in Documentation/Changes will be OK.

Regards.
