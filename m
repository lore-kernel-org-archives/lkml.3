Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751345Ab3JEFft (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Oct 2013 01:35:49 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35317 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751162Ab3JEFfr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Oct 2013 01:35:47 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <20131005051056.GA7698@obsidianresearch.com>
References: <524EC965.70701@monstr.eu> <20131004141646.GA9396@kroah.com> <d700a91e-1319-4c35-895d-55e323c40703@email.android.com> <524ED081.1040600@monstr.eu> <524EF0CE.4040002@zytor.com> <524EFE76.70200@monstr.eu> <524F04FD.5020804@zytor.com> <20131004233341.GA4028@kroah.com> <20131004234929.GB3652@obsidianresearch.com> <875b2a01-be5a-47d1-b89a-9385d54b9b64@email.android.com> <20131005051056.GA7698@obsidianresearch.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [RFC PATCH v2 0/1] FPGA subsystem core
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Fri, 04 Oct 2013 22:34:10 -0700
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, monstr@monstr.eu,
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
Message-ID: <1c9db96e-7a36-4ec9-ab16-885780ce6de5@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I do it all the time.

JAM/STAPL seems to me to be more used for exotic connections to serial flash for persistent programming.

Jason Gunthorpe <jgunthorpe@obsidianresearch.com> wrote:
>On Fri, Oct 04, 2013 at 09:00:28PM -0700, H. Peter Anvin wrote:
>
>> Every FPGA toolchain I know of has a way to emit JAM/STAPL bytecode
>> files... and a fair number of programming scenarios need them.
>
>Yes, but now you are talking about JTAG.
>
>JTAG is a very different problem than configuring over the
>configuration bus, I don't think it makes much sense to try and
>combine those two things into a single subsystem.
>
>The majority use of JAM/STAPL output is for manufacturing
>automation. In system, In field programming of SRAM FPGAs via JTAG is
>uncommon.
>
>Jason

-- 
Sent from my mobile phone.  Please pardon brevity and lack of formatting.
