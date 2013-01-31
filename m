Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753837Ab3AaLci (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 06:32:38 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:60757 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082Ab3AaLcf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 06:32:35 -0500
Date: Thu, 31 Jan 2013 12:32:30 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: "Wang, Song-Bo (Stoney)" <song-bo.wang@hp.com>,
        "mingo.kernel.org@gmail.com" <mingo.kernel.org@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        "Zhang, Lin-Bao (Linux Kernel R&D)" <linbao.zhang@hp.com>,
        "Pearson, Greg" <greg.pearson@hp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "suresh.b.siddha@intel.com" <suresh.b.siddha@intel.com>,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] x86/apic: check FADT settings after enable x2apic
Message-ID: <20130131113230.GD4587@gmail.com>
References: <1358214636-4801-1-git-send-email-song-bo.wang@hp.com>
 <FE3E8B88161FFE48B03E3B93408433EC671016E2@G9W0754.americas.hpqcorp.net>
 <CAE9FiQW75eP_exufb1gd7jQuu98WnkyGX23EBXktUCSyZX9Jvg@mail.gmail.com>
 <20130128101135.GD7168@gmail.com>
 <CAE9FiQUtQ4uaBZxndV+acHW55JL5-nb0EnuXHhwiB-mK8Swtag@mail.gmail.com>
 <20130129074746.GA594@gmail.com>
 <FE3E8B88161FFE48B03E3B93408433EC671027BC@G9W0754.americas.hpqcorp.net>
 <20130129084914.GB5350@gmail.com>
 <CAE9FiQXe2QHacwyJx+5MQWmoGYW1Swnr5M-MSircgfA4_9e19Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE9FiQXe2QHacwyJx+5MQWmoGYW1Swnr5M-MSircgfA4_9e19Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <yinghai@kernel.org> wrote:

> Please check attached.

Almost good.

This:

  > When some HP sytems boot without x2apic_phys, there will be

Should mention the approximate models of the systems affected - 
is it just a specific line of systems, or a wider range of 
systems affected?

This will inform users and will help maintainers like me to 
prioritize the merging and backporting of patches.

Thanks,

	Ingo
