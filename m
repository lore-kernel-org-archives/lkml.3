Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934030Ab3GWSJK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 14:09:10 -0400
Received: from mail-qc0-f170.google.com ([209.85.216.170]:34188 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933943Ab3GWSDG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 14:03:06 -0400
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:1b02:6e3b:e5ff:fe16:f1aa]
In-Reply-To: <20130628103855.c4a89a6f1c6ef425fee34bc6@canb.auug.org.au>
References: <1372336962-6459-1-git-send-email-vincent.stehle@freescale.com>
	<51CC37BF.8030309@monstr.eu>
	<20130628103855.c4a89a6f1c6ef425fee34bc6@canb.auug.org.au>
Date: Tue, 23 Jul 2013 11:03:05 -0700
Message-ID: <CAOesGMgCDb=YUdNsmNw7GfnnQM0F1C2r18h0orW8Zf4-nFWT1w@mail.gmail.com>
Subject: Re: [PATCH linux-next] arm: zynq: fix compilation warning
From: Olof Johansson <olof@lixom.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Michal Simek <monstr@monstr.eu>,
        =?ISO-8859-1?Q?Vincent_Stehl=E9?= <vincent.stehle@freescale.com>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Robin Holt <holt@sgi.com>, Michal Simek <michal.simek@xilinx.com>,
        Russell King <linux@arm.linux.org.uk>, trivial@kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 27, 2013 at 5:38 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> On Thu, 27 Jun 2013 15:01:51 +0200 Michal Simek <monstr@monstr.eu> wrote:
>>
>> Arnd asked in this post
>> http://www.mail-archive.com/linux-kernel@vger.kernel.org/msg454947.html
>> to fold his small patch to that larger one.
>>
>> Not sure why it is not there.
>> Arnd, Robin?
>
> Should have asked Andrew :-)
>
> I have added (most of) Arnd's patch to the end of the akpm tree today.

It was a dependency thing where new code was added in arm-soc, so the
sweeping patches in Andrew's tree couldn't cover them (without adding
said dependency and thus no longer apply on top of mainline).

I'll apply this and the keystone fix to the arm-soc fixes branch now
for 3.11-rc3.


-Olof
