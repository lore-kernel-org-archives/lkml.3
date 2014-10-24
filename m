Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753513AbaJXJVG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 05:21:06 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:60731 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750888AbaJXJVC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 05:21:02 -0400
Subject: Re: [PATCH v2 2/3] ARM: dts: socfpga: fpga bridges bindings docs
Mime-Version: 1.0 (Mac OS X Mail 8.0 \(1990.1\))
Content-Type: text/plain; charset=utf-8
From: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
In-Reply-To: <20141024070042.GL10262@pengutronix.de>
Date: Fri, 24 Oct 2014 12:20:53 +0300
Cc: atull@opensource.altera.com, jgunthorpe@obsidianresearch.com,
        hpa@zytor.com, Michal Simek <monstr@monstr.eu>,
        michal.simek@xilinx.com, rdunlap@infradead.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        devicetree@vger.kernel.org, robh+dt@kernel.org,
        Grant Likely <grant.likely@linaro.org>, iws@ovro.caltech.edu,
        linux-doc@vger.kernel.org, pavel@denx.de, broonie@kernel.org,
        philip@balister.org, rubini@gnudd.com, jason@lakedaemon.net,
        kyle.teske@ni.com, nico@linaro.org, balbi@ti.com, m.chehab@samsung.com,
        davidb@codeaurora.org, rob@landley.net, davem@davemloft.net,
        cesarb@cesarb.net, sameo@linux.intel.com, akpm@linux-foundation.org,
        linus.walleij@linaro.org, mgerlach@opensource.altera.com,
        delicious.quinoa@gmail.com, dinguyen@opensource.altera.com,
        yvanderv@opensource.altera.com
Content-Transfer-Encoding: 8BIT
Message-Id: <5FB7B7FD-7B5B-4250-BADE-85573FDBBE48@konsulko.com>
References: <1414108267-22058-1-git-send-email-atull@opensource.altera.com> <1414108267-22058-3-git-send-email-atull@opensource.altera.com> <20141024070042.GL10262@pengutronix.de>
To: Steffen Trumtrar <s.trumtrar@pengutronix.de>
X-Mailer: Apple Mail (2.1990.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stefan, Allan,

Sorry, haven’t had a chance to review all this yet; will do so in the weekend.
Just wanted to pop in and comment on a few things.

> On Oct 24, 2014, at 10:00 AM, Steffen Trumtrar <s.trumtrar@pengutronix.de> wrote:
> 
> Hi!
> 
> On Thu, Oct 23, 2014 at 06:51:06PM -0500, atull@opensource.altera.com wrote:
>> From: Alan Tull <atull@opensource.altera.com>
> 
> (...)
> 
>> diff --git a/Documentation/devicetree/bindings/fpga/altera-hps2fpga-bridge.txt b/Documentation/devicetree/bindings/fpga/altera-hps2fpga-bridge.txt
>> new file mode 100644
>> index 0000000..bc24a2e
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/fpga/altera-hps2fpga-bridge.txt
>> @@ -0,0 +1,53 @@
>> +Altera FPGA/HPS Bridge Driver
>> +
>> +This driver manages a bridge between a FPGA and a host processor system (HPS).
>> +User space can enable or disable the bridge by writing a "1" or a "0",
>> +respectively, to its enable file under bridge's entry in
>> +/sys/class/fpga-bridge.  Typically, one disables the bridges before
>> +reprogramming the FPGA.  Once the FPGA is reprogrammed, the bridges are
>> +reenabled.
>> +
> 
> NAK.
> 
> This is all linux specific and doesn't belong here.
> 

We know. The DT spec hasn’t been updated for a while, and this is going to be
part of what we want to do with the restarting of the ePAPR spec process.

So absolutes like “DT is a hardware description only" might be too strong statements, that
do not work in practice anymore.

There’s no such thing as pure hardware devices lately - there is always a configuration
component; some of it OS specific, some of it not.

We have to be engaged in the process and figure out how to update the spec for what is
now the state of the art in the industry.

Regards

— Pantelis

