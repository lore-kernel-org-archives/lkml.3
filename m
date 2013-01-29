Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754873Ab3A2ItU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 03:49:20 -0500
Received: from mail-bk0-f54.google.com ([209.85.214.54]:34111 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753963Ab3A2ItS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 03:49:18 -0500
Date: Tue, 29 Jan 2013 09:49:14 +0100
From: Ingo Molnar <mingo@kernel.org>
To: "Wang, Song-Bo (Stoney)" <song-bo.wang@hp.com>
Cc: "mingo.kernel.org@gmail.com" <mingo.kernel.org@gmail.com>,
        Yinghai Lu <yinghai@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Zhang, Lin-Bao (Linux Kernel R&D)" <linbao.zhang@hp.com>,
        "Pearson, Greg" <greg.pearson@hp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "suresh.b.siddha@intel.com" <suresh.b.siddha@intel.com>,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] x86/apic: check FADT settings after enable x2apic
Message-ID: <20130129084914.GB5350@gmail.com>
References: <1358214636-4801-1-git-send-email-song-bo.wang@hp.com>
 <FE3E8B88161FFE48B03E3B93408433EC671016E2@G9W0754.americas.hpqcorp.net>
 <CAE9FiQW75eP_exufb1gd7jQuu98WnkyGX23EBXktUCSyZX9Jvg@mail.gmail.com>
 <20130128101135.GD7168@gmail.com>
 <CAE9FiQUtQ4uaBZxndV+acHW55JL5-nb0EnuXHhwiB-mK8Swtag@mail.gmail.com>
 <20130129074746.GA594@gmail.com>
 <FE3E8B88161FFE48B03E3B93408433EC671027BC@G9W0754.americas.hpqcorp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <FE3E8B88161FFE48B03E3B93408433EC671027BC@G9W0754.americas.hpqcorp.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Wang, Song-Bo (Stoney) <song-bo.wang@hp.com> wrote:

> [...] Due to this mode mismatch, with specific HW 
> configurations, there will be intermittent lost interrupts, 
> which could result in a hang or data loss.

That's the key piece of information that was missing - which 
should be put into the changelog into a very prominent place.

> Logically, there is a mismatch because the kernel missed 
> detection on HW configurations, and we should fix it, right? 
> Do we need more detailed information?

No, the above sentence is more than enough and the fix looks 
nice. Note that this sentence is more useful to users than the 
rest of the changelog combined!

Thanks,

	Ingo
