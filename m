Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752712AbaJ0PFj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 11:05:39 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:49442 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751951AbaJ0PFh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 11:05:37 -0400
Subject: Re: [PATCH v2 2/3] ARM: dts: socfpga: fpga bridges bindings docs
Mime-Version: 1.0 (Mac OS X Mail 8.0 \(1990.1\))
Content-Type: text/plain; charset=utf-8
From: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
In-Reply-To: <20141027150147.GX18557@sirena.org.uk>
Date: Mon, 27 Oct 2014 17:05:29 +0200
Cc: atull@opensource.altera.com, jgunthorpe@obsidianresearch.com,
        hpa@zytor.com, Michal Simek <monstr@monstr.eu>,
        michal.simek@xilinx.com, rdunlap@infradead.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        devicetree@vger.kernel.org, robh+dt@kernel.org,
        Grant Likely <grant.likely@linaro.org>, iws@ovro.caltech.edu,
        linux-doc@vger.kernel.org, Pavel Machek <pavel@denx.de>,
        philip@balister.org, rubini@gnudd.com,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>, jason@lakedaemon.net,
        kyle.teske@ni.com, nico@linaro.org, Felipe Balbi <balbi@ti.com>,
        m.chehab@samsung.com, davidb@codeaurora.org,
        Rob Landley <rob@landley.net>, davem@davemloft.net, cesarb@cesarb.net,
        sameo@linux.intel.com, akpm@linux-foundation.org,
        Linus Walleij <linus.walleij@linaro.org>,
        mgerlach@opensource.altera.com, Alan Tull <delicious.quinoa@gmail.com>,
        dinguyen@opensource.altera.com, yvanderv@opensource.altera.com
Content-Transfer-Encoding: 8BIT
Message-Id: <31BBCD26-65E2-431A-9ADF-95D7EDC7E34E@konsulko.com>
References: <1414108267-22058-1-git-send-email-atull@opensource.altera.com> <1414108267-22058-3-git-send-email-atull@opensource.altera.com> <CCE2D027-AA89-41C4-B9AA-2B92AA62129B@konsulko.com> <20141027150147.GX18557@sirena.org.uk>
To: Mark Brown <broonie@kernel.org>
X-Mailer: Apple Mail (2.1990.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

> On Oct 27, 2014, at 17:01 , Mark Brown <broonie@kernel.org> wrote:
> 
> On Mon, Oct 27, 2014 at 01:48:02PM +0200, Pantelis Antoniou wrote:
>>> On Oct 24, 2014, at 02:51 , atull@opensource.altera.com wrote:
> 
>>> + - init-val         : 0 if driver should disable bridge at startup
>>> +                      1 if driver should enable bridge at startup
>>> +                      driver leaves bridge in current state if property not
>>> +		      specified.
> 
>> Isn’t init-val a boolean property? It’s not named very well.
> 
> It's not boolean, it's tristate - turn on, turn off or don't touch.
> 

I see. Even then ‘init-val’ is cryptic. I’d prefer two booleans,
enable-at-startup; disable-at-startup.

>> Along with the label, is kinda hard to defend as configuration in DT.
> 
> Yeah...  presumably this decision would fall out of the users?

Well, it’s the user that should make the decision, but the driver should
pick it up. This works but it’s not very nice.

Regards

— Pantelis

