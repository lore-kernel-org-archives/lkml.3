Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753386Ab3JDQsi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 12:48:38 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58335 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750880Ab3JDQsh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 12:48:37 -0400
Message-ID: <524EF0CE.4040002@zytor.com>
Date: Fri, 04 Oct 2013 09:46:06 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: monstr@monstr.eu
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Pavel Machek <pavel@denx.de>, Michal Simek <michal.simek@xilinx.com>,
        linux-kernel@vger.kernel.org, Alan Tull <atull@altera.com>,
        Dinh Nguyen <dinguyen@altera.com>,
        Philip Balister <philip@balister.org>,
        Alessandro Rubini <rubini@gnudd.com>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
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
Subject: Re: [RFC PATCH v2 0/1] FPGA subsystem core
References: <cover.1380727889.git.michal.simek@xilinx.com> <524C6D64.8080801@zytor.com> <20131003064915.GB17155@amd.pavel.ucw.cz> <524EC965.70701@monstr.eu> <20131004141646.GA9396@kroah.com> <d700a91e-1319-4c35-895d-55e323c40703@email.android.com> <524ED081.1040600@monstr.eu>
In-Reply-To: <524ED081.1040600@monstr.eu>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/04/2013 07:28 AM, Michal Simek wrote:
> On 10/04/2013 04:21 PM, H. Peter Anvin wrote:
>> Yes; I never got too corner Greg ;)
>> 
>> Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>>> On Fri, Oct 04, 2013 at 03:57:57PM +0200, Michal Simek wrote:
>>>> But anyway what was resolution from that meeting?
>>> 
>>> It never happened, we got distracted by lunch :)
> 
> Then why not to have it here?
> 

The essential question is if the firmware interface really is
appropriate for FPGAs.  It definitely has a feel of a "square peg in a
round hole", especially when you consider the myriad ways FPGAs can be
configured (some persistent, some not, some which takes effect now,
some which come later, some which involve bytecode interpreters...)
and considering reconfiguration and partial reconfiguration.

	-hpa


