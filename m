Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932066AbaEMWxx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 18:53:53 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47708 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753372AbaEMWxq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 18:53:46 -0400
Message-ID: <5372A220.6080301@zytor.com>
Date: Tue, 13 May 2014 15:52:16 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Pavel Machek <pavel@denx.de>,
        Pantelis Antoniou <pantelis.antoniou@konsulko.com>
CC: Alan Tull <atull@altera.com>, linux-kernel@vger.kernel.org,
        Michal Simek <monstr@monstr.eu>,
        Michal Simek <michal.simek@xilinx.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Mark Brown <broonie@kernel.org>, Philip Balister <philip@balister.org>,
        Alessandro Rubini <rubini@gnudd.com>,
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
        Alan Tull <delicious.quinoa@gmail.com>,
        Dinh Nguyen <dinguyen@altera.com>,
        Yves Vandervennet <rocket.yvanderv@gmail.com>
Subject: Re: [RFC PATCH v1] fpga manager framework with configfs interface
References: <1399411381-10902-1-git-send-email-atull@altera.com> <1399411381-10902-2-git-send-email-atull@altera.com> <20140513192330.GA6561@amd.pavel.ucw.cz> <4190CF2D-6114-4652-90BA-899B5003ACCC@konsulko.com> <20140513205641.GA4114@amd.pavel.ucw.cz>
In-Reply-To: <20140513205641.GA4114@amd.pavel.ucw.cz>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/13/2014 01:56 PM, Pavel Machek wrote:
> Hi!
> 
>>> Echoing filenames into files in configfs is strange at the very
>>> least. Think chroot, and what about permissions...?
>>>
>>> It would be much better to just cat bitstream into configfs...
>>
>> No binary attributes supported for configfs. Apparently this is done on purpose.
>>
>> In fact it was my first idea about the configfs interface for DT overlays but decided 
>> to go with firmware file names instead.
>>
>> If this is valid use case (which seems to be) would patches adding binary attributes
>> to configfs be accepted?
> 
> I'd say this is very valid use, but I'm not configfs maintainer. It is
> certainly better then echoing filenames there.
> 

Almost anything is better...

	-hpa


