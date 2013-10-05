Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751208Ab3JEEBq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Oct 2013 00:01:46 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34787 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750741Ab3JEEBo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Oct 2013 00:01:44 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <20131004234929.GB3652@obsidianresearch.com>
References: <524C6D64.8080801@zytor.com> <20131003064915.GB17155@amd.pavel.ucw.cz> <524EC965.70701@monstr.eu> <20131004141646.GA9396@kroah.com> <d700a91e-1319-4c35-895d-55e323c40703@email.android.com> <524ED081.1040600@monstr.eu> <524EF0CE.4040002@zytor.com> <524EFE76.70200@monstr.eu> <524F04FD.5020804@zytor.com> <20131004233341.GA4028@kroah.com> <20131004234929.GB3652@obsidianresearch.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [RFC PATCH v2 0/1] FPGA subsystem core
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Fri, 04 Oct 2013 21:00:28 -0700
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: monstr@monstr.eu, Pavel Machek <pavel@denx.de>,
        Michal Simek <michal.simek@xilinx.com>, linux-kernel@vger.kernel.org,
        Alan Tull <atull@altera.com>, Dinh Nguyen <dinguyen@altera.com>,
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
Message-ID: <875b2a01-be5a-47d1-b89a-9385d54b9b64@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Every FPGA toolchain I know of has a way to emit JAM/STAPL bytecode files... and a fair number of programming scenarios need them.

Jason Gunthorpe <jgunthorpe@obsidianresearch.com> wrote:
>On Fri, Oct 04, 2013 at 04:33:41PM -0700, Greg Kroah-Hartman wrote:
>
>> > I agree that the firmware interface makes sense when the use of the
>> > FPGA is an implementation detail in a fixed hardware configuration,
>> > but that is a fairly restricted use case all things considered.
>> 
>> Ideally I thought this would be just like "firmware", you dump the
>file
>> to the FPGA, it validates it and away you go with a new image running
>in
>> the chip.
>
>That is 99% of the use cases. The other stuff people are talking about
>is fringe.
>
>I've been doing FPGAs for > 10 years and I've never once used read back
>via the config bus. In fact all my FPGAs turn that feature off once
>they are loaded.
>
>Partial reconfiguration is very specialized, and hard to use from a
>FPGA design standpoint.
>
>I also think it is sensible to focus this interface on simple SRAM
>FPGAs, not FLASH based stuff, or whatever complex device required a
>byte code interpreter (never heard of that before).
>
>Jason

-- 
Sent from my mobile phone.  Please pardon brevity and lack of formatting.
