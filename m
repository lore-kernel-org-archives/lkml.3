Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752132Ab3LPB1e (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Dec 2013 20:27:34 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:33127 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751956Ab3LPB1b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Dec 2013 20:27:31 -0500
Date: Sun, 15 Dec 2013 20:27:25 -0500 (EST)
Message-Id: <20131215.202725.1549146673897801643.davem@davemloft.net>
To: msalter@redhat.com
Cc: dmitry.torokhov@gmail.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rth@twiddle.net, linux-alpha@vger.kernel.org, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, tony.luck@intel.com,
        fenghua.yu@intel.com, linux-ia64@vger.kernel.org, ralf@linux-mips.org,
        linux-mips@linux-mips.org, benh@kernel.crashing.org, paulus@samba.org,
        linuxppc-dev@lists.ozlabs.org, lethal@linux-sh.org,
        linux-sh@vger.kernel.org, sparclinux@vger.kernel.org,
        gxt@mprc.pku.edu.cn, mingo@redhat.com, tglx@linutronix.de,
        x86@kernel.org
Subject: Re: [PATCH 10/10] Kconfig: cleanup SERIO_I8042 dependencies
From: David Miller <davem@davemloft.net>
In-Reply-To: <1387122626.1979.136.camel@deneb.redhat.com>
References: <52ACA43F.2040402@zytor.com>
	<20131215103657.GB20197@core.coreip.homeip.net>
	<1387122626.1979.136.camel@deneb.redhat.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Sun, 15 Dec 2013 17:27:31 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Salter <msalter@redhat.com>
Date: Sun, 15 Dec 2013 10:50:26 -0500

> On Sun, 2013-12-15 at 02:36 -0800, Dmitry Torokhov wrote:
>> How are we going to merge this? In bulk through input tree or peacemeal
>> through all arches first?
>
> They should all go together to eliminate the chance of bisect breakage.
> Either the input tree or maybe akpm tree.

This sounds good to me.
