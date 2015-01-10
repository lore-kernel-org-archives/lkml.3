Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754043AbbAJILD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 03:11:03 -0500
Received: from mail-wi0-f173.google.com ([209.85.212.173]:36707 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752319AbbAJIK7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 03:10:59 -0500
Subject: Re: [PATCH v8 2/4] fpga manager: add sysfs interface document
Mime-Version: 1.0 (Mac OS X Mail 8.1 \(1993\))
Content-Type: text/plain; charset=utf-8
From: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
In-Reply-To: <20150109205643.GA5761@amd>
Date: Sat, 10 Jan 2015 10:10:51 +0200
Cc: atull <atull@opensource.altera.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        jgunthorpe@obsidianresearch.com, hpa@zytor.com,
        Michal Simek <monstr@monstr.eu>,
        Michal Simek <michal.simek@xilinx.com>, rdunlap@infradead.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        devicetree@vger.kernel.org, robh+dt@kernel.org,
        Grant Likely <grant.likely@linaro.org>, iws@ovro.caltech.edu,
        linux-doc@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        philip@balister.org, rubini@gnudd.com,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>, jason@lakedaemon.net,
        kyle.teske@ni.com, nico@linaro.org, Felipe Balbi <balbi@ti.com>,
        m.chehab@samsung.com, davidb@codeaurora.org,
        Rob Landley <rob@landley.net>, davem@davemloft.net, cesarb@cesarb.net,
        sameo@linux.intel.com, akpm@linux-foundation.org,
        Linus Walleij <linus.walleij@linaro.org>, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, devel@driverdev.osuosl.org,
        Alan Tull <delicious.quinoa@gmail.com>, dinguyen@opensource.altera.com,
        yvanderv@opensource.altera.com
Content-Transfer-Encoding: 8BIT
Message-Id: <4D4EA2D5-68DD-49F7-9E2D-3A0A8F6AF9CA@konsulko.com>
References: <1420575219-27061-1-git-send-email-atull@opensource.altera.com> <1420575219-27061-3-git-send-email-atull@opensource.altera.com> <20150107084819.GA1887@amd> <alpine.DEB.2.02.1501091302370.30067@linuxheads99> <20150109205643.GA5761@amd>
To: Pavel Machek <pavel@denx.de>
X-Mailer: Apple Mail (2.1993)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pavel,

> On Jan 9, 2015, at 22:56 , Pavel Machek <pavel@denx.de> wrote:
> 
> On Fri 2015-01-09 13:14:24, atull wrote:
>> On Wed, 7 Jan 2015, Pavel Machek wrote:
>> 
>>> On Tue 2015-01-06 14:13:37, atull@opensource.altera.com wrote:
>>>> +
>>>> +What:		/sys/class/fpga_manager/<fpga>/firmware
>>>> +Date:		October 2014
>>>> +KernelVersion:	3.18
>>>> +Contact:	Alan Tull <atull@opensource.altera.com>
>>>> +Description:	Name of the FPGA image file to load using firmware
>>>> class.
>>> 
>>> This one is ugly: it unneccessarily passes firmware name through the
>>> kernel. Just make interface and code simpler by always passing
>>> "socfpga-fpga-image" or something like that.
>>> 
>>> Thanks,
>>> 									Pavel
>> 
>> Hi Pavel,
>> 
>> It might be ugly.  It's not unnecessary.  Some uses of FPGAs involve
>> switching out the FPGA images dynamically under control of the userspace.
> 
> Then configure udev to load right firmware for you, or ln -s
> image-i-want-now socfpga-fpga-image to select the one to read…?
> 

Who said that udev is going to be available in the kind of system this is going to end in?

Doing ln -s tricks to load a different image? Really?

I say the interface is fine as it is.

Regards

— Pantelis

> 
> -- 
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
> --
> To unsubscribe from this list: send the line "unsubscribe devicetree" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

