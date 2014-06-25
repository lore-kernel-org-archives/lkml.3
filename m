Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754886AbaFYTCy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 15:02:54 -0400
Received: from sanddollar.geekisp.com ([216.168.135.167]:3529 "HELO
	sanddollar.geekisp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753257AbaFYTCw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 15:02:52 -0400
X-Greylist: delayed 441 seconds by postgrey-1.27 at vger.kernel.org; Wed, 25 Jun 2014 15:02:52 EDT
Message-ID: <53AB1AD9.7050108@balister.org>
Date: Wed, 25 Jun 2014 11:54:17 -0700
From: Philip Balister <philip@balister.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>, Alan Tull <delicious.quinoa@gmail.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
CC: Pantelis Antoniou <pantelis.antoniou@konsulko.com>,
        Joel Becker <jlbec@evilplan.org>, Pavel Machek <pavel@denx.de>,
        Alan Tull <atull@altera.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Michal Simek <monstr@monstr.eu>,
        Michal Simek <michal.simek@xilinx.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Brown <broonie@kernel.org>, Alessandro Rubini <rubini@gnudd.com>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        Jason Cooper <jason@lakedaemon.net>, Kyle Teske <kyle.teske@ni.com>,
        Josh Cartwright <joshc@eso.teric.us>, Nicolas Pitre <nico@linaro.org>,
        Felipe Balbi <balbi@ti.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        David Brown <davidb@codeaurora.org>, Rob Landley <rob@landley.net>,
        "David S. Miller" <davem@davemloft.net>, Joe Perches <joe@perches.com>,
        Cesar Eduardo Barros <cesarb@cesarb.net>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dinh Nguyen <dinguyen@altera.com>,
        Yves Vandervennet <rocket.yvanderv@gmail.com>
Subject: Re: [RFC PATCH v1] fpga manager framework with configfs interface
References: <1399411381-10902-2-git-send-email-atull@altera.com>	<20140513192330.GA6561@amd.pavel.ucw.cz>	<4190CF2D-6114-4652-90BA-899B5003ACCC@konsulko.com>	<20140513205641.GA4114@amd.pavel.ucw.cz>	<5372A220.6080301@zytor.com>	<20140625125449.GV30852@ZenIV.linux.org.uk>	<DF9393AB-E2A0-494A-A007-CB4A19A64E2A@konsulko.com>	<1cacd7d5-826b-40e0-8b5c-f3463fe7a809@email.android.com>	<D4CC4816-F293-427B-8D52-1D4F93635E2D@konsulko.com>	<CANk1AXQcqzu16OaT3LziWaroeyyuUoXU1CQy4e6BoGKLOk6fSg@mail.gmail.com>	<20140625175440.GC13460@obsidianresearch.com> <CANk1AXS+JZCv7CMJW956PvnJ_YvebyyLVm_TkCPZr5TX1Wb4Yw@mail.gmail.com> <53AB1842.5020703@zytor.com>
In-Reply-To: <53AB1842.5020703@zytor.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/25/2014 11:43 AM, H. Peter Anvin wrote:
> On 06/25/2014 11:37 AM, Alan Tull wrote:
>>
>> Yes, that's why I've recently felt more love for the firmware
>> interface.  Since I need resume, it gives me a straightforward path to
>> be able to reprogram the FPGA without holding ram for the bitfile.
>> Also it is scalable.
>>
> 
> The firmware interface is definitely pretty much ideal for the
> "production driver" use case... after all, the fact that the firmware
> happens to be an FPGA is to some degree an implementation detail (well,
> modulo fun things like showing up on the bus with one device ID and then
> disconnecting and reconnecting with another device ID after firmware load.)
> 
> There are *so* many use cases for FPGA bitstreams...

Agreed!

Philip


> 
> 	-hpa
> 
> 
> 
