Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751586Ab3A2Val (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 16:30:41 -0500
Received: from mail-ia0-f173.google.com ([209.85.210.173]:52304 "EHLO
	mail-ia0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750972Ab3A2Vai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 16:30:38 -0500
MIME-Version: 1.0
In-Reply-To: <20130129084914.GB5350@gmail.com>
References: <1358214636-4801-1-git-send-email-song-bo.wang@hp.com>
	<FE3E8B88161FFE48B03E3B93408433EC671016E2@G9W0754.americas.hpqcorp.net>
	<CAE9FiQW75eP_exufb1gd7jQuu98WnkyGX23EBXktUCSyZX9Jvg@mail.gmail.com>
	<20130128101135.GD7168@gmail.com>
	<CAE9FiQUtQ4uaBZxndV+acHW55JL5-nb0EnuXHhwiB-mK8Swtag@mail.gmail.com>
	<20130129074746.GA594@gmail.com>
	<FE3E8B88161FFE48B03E3B93408433EC671027BC@G9W0754.americas.hpqcorp.net>
	<20130129084914.GB5350@gmail.com>
Date: Tue, 29 Jan 2013 13:30:37 -0800
X-Google-Sender-Auth: 5s4zdyu8sxKDlLfYuSjBmkcCPig
Message-ID: <CAE9FiQXfmRMeqboa4PEQ3nKd4POmSqJhj9oc69EC3u+xzk0gdA@mail.gmail.com>
Subject: Re: [PATCH] x86/apic: check FADT settings after enable x2apic
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@kernel.org>,
        "Wang, Song-Bo (Stoney)" <song-bo.wang@hp.com>
Cc: "mingo.kernel.org@gmail.com" <mingo.kernel.org@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        "Zhang, Lin-Bao (Linux Kernel R&D)" <linbao.zhang@hp.com>,
        "Pearson, Greg" <greg.pearson@hp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "suresh.b.siddha@intel.com" <suresh.b.siddha@intel.com>,
        Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 29, 2013 at 12:49 AM, Ingo Molnar <mingo@kernel.org> wrote:
>
> * Wang, Song-Bo (Stoney) <song-bo.wang@hp.com> wrote:
>
>> [...] Due to this mode mismatch, with specific HW
>> configurations, there will be intermittent lost interrupts,
>> which could result in a hang or data loss.

Wang,

Maybe off topic, You should never ship those kind of system before you
fix that in BIOS, as user will have problem with current distribution.

You need to ask your BIOS guys (or OEM's BIOS guys) to check with Intel
to set one bit in IIO configure space to enable x2apic cluster.

Thanks

Yinghai
