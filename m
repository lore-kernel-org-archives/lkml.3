Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754411AbaBVAqH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 19:46:07 -0500
Received: from mail-qc0-f176.google.com ([209.85.216.176]:42411 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751797AbaBVAqF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 19:46:05 -0500
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:fd64:fd93:29f6:64f2:9832]
In-Reply-To: <20140221110950.GB8731@mudshark.cambridge.arm.com>
References: <20140221115857.3ea3d7277d03c5b6b4d26488@canb.auug.org.au>
	<CAOesGMimJxYLor11EQ-Cn9BnZGg60VrOFC8ZqBdC+wNunptm8w@mail.gmail.com>
	<20140221110950.GB8731@mudshark.cambridge.arm.com>
Date: Fri, 21 Feb 2014 16:46:04 -0800
Message-ID: <CAOesGMi6p5LPQ0P2p9MtJEXJP4+5eU-7shze3EB2Gy3BuPv_wg@mail.gmail.com>
Subject: Re: linux-next: manual merge of the arm-soc tree with the arm-perf tree
From: Olof Johansson <olof@lixom.net>
To: Will Deacon <will.deacon@arm.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stephen Boyd <sboyd@codeaurora.org>, Kumar Gala <galak@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 21, 2014 at 3:09 AM, Will Deacon <will.deacon@arm.com> wrote:
> On Fri, Feb 21, 2014 at 01:02:47AM +0000, Olof Johansson wrote:
>> On Thu, Feb 20, 2014 at 4:58 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>> > Today's linux-next merge of the arm-soc tree got a conflict in
>> > arch/arm/boot/dts/qcom-msm8960-cdp.dts between commit a1d711938959 ("ARM:
>> > dts: msm: Add krait-pmu to platforms with Krait CPUs") from the arm-perf
>> > tree and commit cc60a1a4d47a ("ARM: dts: msm: split out msm8660 and
>> > msm8960 soc into dts include") from the arm-soc tree.
>> >
>> > I fixed it up (probably not the best way ... see below) and can carry the
>> > fix as necessary (no action is required).
>>
>> Will, I think we'll be better off taking dts changes through arm-soc,
>> unless there's a good reason to take them through other trees (such as
>> the perf tree in this case). Is there, or should we move them over?
>
> Sure, I can drop that from my tree (it came as part of the series adding
> Krait PMU support).
>
> I've included the original patch below so you can put it into arm-soc.

Thanks, I've applied it now (with the fixups to move to the dtsi).


-Olof
