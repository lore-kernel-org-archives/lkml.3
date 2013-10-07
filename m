Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755824Ab3JGPIV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 11:08:21 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56658 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755472Ab3JGPIU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 11:08:20 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <5252CD30.3070305@monstr.eu>
References: <524EC965.70701@monstr.eu> <20131004141646.GA9396@kroah.com> <d700a91e-1319-4c35-895d-55e323c40703@email.android.com> <524ED081.1040600@monstr.eu> <524EF0CE.4040002@zytor.com> <524EFE76.70200@monstr.eu> <524F04FD.5020804@zytor.com> <20131004233341.GA4028@kroah.com> <20131004234929.GB3652@obsidianresearch.com> <875b2a01-be5a-47d1-b89a-9385d54b9b64@email.android.com> <20131005051056.GA7698@obsidianresearch.com> <1c9db96e-7a36-4ec9-ab16-885780ce6de5@email.android.com> <524FB756.3040203@monstr.eu> <c59c68b8-2565-45c5-bfe9-574b76f3f9bc@email.android.com> <5252B2F4.7050600@monstr.eu> <ea858a91-1149-44cc-b2e1-bab1f579915e@email.android.com> <5252CD30.3070305@monstr.eu>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [RFC PATCH v2 0/1] FPGA subsystem core
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Mon, 07 Oct 2013 08:07:00 -0700
To: monstr@monstr.eu, Michal Simek <monstr@monstr.eu>
CC: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Pavel Machek <pavel@denx.de>, Michal Simek <michal.simek@xilinx.com>,
        linux-kernel@vger.kernel.org, Alan Tull <atull@altera.com>,
        Dinh Nguyen <dinguyen@altera.com>,
        Philip Balister <philip@balister.org>,
        Alessandro Rubini <rubini@gnudd.com>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        Jason Cooper <jason@lakedaemon.net>,
        Yves Vandervennet <rocket.yvanderv@gmail.com>,
        Kyle Teske <kyle.teske@ni.com>, Josh Cartwright <joshc@eso.teric.us>,
        Nicolas Pitre <nico@linaro.org>,
        Mark Langsdorf <mark.langsdorf@calxeda.com>,
        Felipe Balbi <balbi@ti.com>, linux-doc@vger.kernel.org,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        David Brown <davidb@codeaurora.org>, Rob Landley <rob@landley.net>,
        "David S. Miller" <davem@davemloft.net>, Joe Perches <joe@perches.com>,
        Cesar Eduardo Barros <cesarb@cesarb.net>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>
Message-ID: <708b6f80-97a7-41a7-9d5c-fa8bd2a8e0c5@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Special soft IP presenting a PCI device to the host.

Michal Simek <monstr@monstr.eu> wrote:
>On 10/07/2013 04:55 PM, H. Peter Anvin wrote:
>> If I recall correctly we simply poked at the FPGA directly from
>userspace. 
>Not ideal by any means and also meant we had to have a backup recovery
>mechanism as it meant
>that the FPGA had to be programmed already as the bus interface was in
>soft IP.
>
>ok. How was that physical hardware connection to device you wanted to
>talk?
>Was it any special IP with MMIO? Or gpio jtag emulation or similar?
>
>Thanks,
>Michal

-- 
Sent from my mobile phone.  Please pardon brevity and lack of formatting.
