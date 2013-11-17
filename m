Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752905Ab3KQWq7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Nov 2013 17:46:59 -0500
Received: from mail.skyhub.de ([78.46.96.112]:48200 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751377Ab3KQWqx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Nov 2013 17:46:53 -0500
Date: Sun, 17 Nov 2013 23:46:21 +0100
From: Borislav Petkov <bp@alien8.de>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Francis Moreau <francis.moro@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: Re: 3.12: kernel panic when resuming from suspend to RAM (x86_64)
Message-ID: <20131117224621.GR27323@pd.tnic>
References: <52888F6D.6000802@gmail.com>
 <CAC9WiBggfssh+31_MqVCT-hDf2E8zTuc81q-DhLYQuVF053mEA@mail.gmail.com>
 <20131117220611.GQ27323@pd.tnic>
 <4636530.OR894YNbbr@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4636530.OR894YNbbr@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 17, 2013 at 11:34:20PM +0100, Rafael J. Wysocki wrote:
> This looks like a softirq bug to me (and related to cpuidle).

Reportedly, it happens right after resume from RAM. Francis, is that
correct?

> I'm wondering if that happens with any of the older kernels or just
> 3.12?

That could be helpful, yeah.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
