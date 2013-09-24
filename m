Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752709Ab3IXNAS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 09:00:18 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:46066 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750742Ab3IXNAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 09:00:15 -0400
X-AuditID: cbfec7f4-b7f0a6d000007b1b-8b-52418cdc9023
From: Tomasz Figa <t.figa@samsung.com>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>,
        "kyungmin.park@samsung.com" <kyungmin.park@samsung.com>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "rob@landley.net" <rob@landley.net>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "m.szyprowski@samsung.com" <m.szyprowski@samsung.com>,
        "b.zolnierkie@samsung.com" <b.zolnierkie@samsung.com>
Subject: Re: [PATCH v2] MTD: Onenand: Add device tree support for samsung
 onenand
Date: Tue, 24 Sep 2013 15:00:01 +0200
Message-id: <2086340.RrXQX9ib0T@amdc1227>
Organization: Samsung Poland R&D Center
User-Agent: KMail/4.11 (Linux/3.10.10-gentoo; KDE/4.11.0; x86_64; ; )
In-reply-to: <20130923140823.GC16069@e106331-lin.cambridge.arm.com>
References: <1379941608-5068-1-git-send-email-m.krawczuk@partner.samsung.com>
 <20130923140823.GC16069@e106331-lin.cambridge.arm.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprOIsWRmVeSWpSXmKPExsVy+t/xK7p3ehyDDA5dNLLYOGM9q8X8I+dY
	LSaunMxsceDPDkaLc69WMlqcbXrDbrGwbQmLxeVdc9gsdjctY7eYcX4fk8XpNaeYLdYeuctu
	sfT6RSaLCdPXslgcXnGAyWLdy+ksFq8OtrE4CHqsmbeG0WPB5yvsHiuXf2Hz2LxCy+PV6pms
	Hneu7QHyltR7HHy3h8mjb8sqRo/Pm+Q8Ns4NDeCO4rJJSc3JLEst0rdL4Mr4NvEIS8Fm5Yqb
	qxcwNzDulO5i5OSQEDCR2PpmPROELSZx4d56ti5GLg4hgaWMEmumzQBLCAl0MUl8a5IAsdkE
	1CQ+NzxiA7FFBNQlenZ9YQGxmQXa2CVaHsmA2MICwRKrN19kBLFZBFQlruxuYAexeQU0JY4+
	agKz+YF63217CjZfVMBV4tPCjWBxTgFniWkLNkMd0cYo0Xj4DwtEs6DEj8n3oJbJS+zbP5UV
	wtaSWL/zONMERsFZSMpmISmbhaRsASPzKkbR1NLkguKk9FxDveLE3OLSvHS95PzcTYyQyPyy
	g3HxMatDjAIcjEo8vBcTHIKEWBPLiitzDzFKcDArifBq1joGCfGmJFZWpRblxxeV5qQWH2Jk
	4uCUamCMWRla2e2X+z9YQcrIbaKkDkdEemL+9uxPW7wrV27zX3FU9LOG5V+/ZOfZzlY/ZS+m
	xP6IC2040D73Ujz3x3meG2a4tc2JC+G5rn3MpX3imflnl1ye8mv37X2CkWFyEYeWXIrOt8gR
	k/SUd1Zxf/r/1axZrxboLoo4vF9+S/A3GbfKpnsM++OVWIozEg21mIuKEwEN3q0OqgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mateusz, Mark,

On Monday 23 of September 2013 15:08:23 Mark Rutland wrote:
> On Mon, Sep 23, 2013 at 02:06:48PM +0100, Mateusz Krawczuk wrote:
> > +
> > +Required properties:
> > +  - compatible: value should be either of the following.
> > +      (a) "samsung,s3c6400-onenand",
> > +		for onenand controller compatible with s3c6400.
> > +      (b) "samsung,s3c6410-onenand",
> > +		for onenand controller compatible with s3c6410.
> > +      (c) "samsung,s5pc100-onenand",
> > +		for onenand controller compatible with s5pc100.
> > +      (d) "samsung,s5pc110-onenand",
> > +      for s5pc100-like onenand controller used on s5pc110 which supports DMA.
> > +
> 
> As I asked on the last posting, what are the differences between these
> implementations?

(d) is a completely different controller than (a), (b) and (c). They
have completely different register layouts. Also see below.

> > +Required properties for s5pc110:
> > +
> > + - reg: the offset and length of the control registers. First region describes
> > +	OneNAND interface, second control registers.
> 
> Also, the complete reg description is a bit confusing. How about
> something like:
> 
>  - reg: two register specifiers:
>         [0] - The OneNAND interface
> 	[1] - The control registers

This looks much better, although I wouldn't be afraid of using words
instead of symbols to write this as follows instead:

  - reg: two memory mapped register regions:
    - first entry: memory mapped OneNAND chip,
    - second entry: control registers.

But... The controller in theory supports more than one OneNAND chip, each
mapped at different, so I'd suggest reordering the entries:

  - reg: memory mapped register regions:
    - first entry: control registers.
    - second entry: memory mapped OneNAND chip 0,
    - ...
    - Nth entry: memory mapped OneNAND chip (N-2).

> Do we expect future OneNAND devices which may require more reg entries
> to describe?

Nope. In age of eMMC I wouldn't even expect any new OneNAND controller
to be handled by these bindings.

> > + - interrupt-parent, interrupts		Onenand memory interrupts
> 
> As it's a common property, I don't think interrupt-parent needs to
> be described.
> 
> Is there more than one interrupt? What's it called on the manual?

There is one interrupt per OneNAND chip, so this is what should be
represented in the binding.

> > +
> > +Required properties for others:
> > +
> > + - reg: the offset and length of the control registers. First region describes
> > +	control registers, second OneNAND interface.
> 
> Why does the s5pc110 OneNAND binding take its registers in the opposite
> order to the rest of these? Can we not fix up the driver first to make
> it consistent? Then we only need to describe this once and it's going to
> be far less of a headache to support.

Both areas in both "major" hardware variants have completely different
meaning:
 - in case of SoCs earlier or equal to S5PC100, first entry represents
   controller registers that are used to control various operating
   parameters, while second entry is a command/data interface, which is
   used to trigger read/write/etc. operations in the controller and
   push/pull data through it. In this variant there is no direct mapping
   of OneNAND chip in CPU address space. This variant supports only
   one memory chip per controller instance,
 - in case of S5PC110, each OneNAND chip is directly mapped into CPU
   address space. In addition there is a block of control registers that
   are used to configure the interface and control internal DMA engine
   (which is not present in <= S5PC100 variants). This variant supports
   multiple memory chips per controller instance (2 in case of S5PV210,
   but current driver handles only one AFAIK).

> > +
> > +Clocks:
> > + - gate - clock which output is supplied to external OneNAND flash memory.
> 
> How about the following (without the Clocks header):
> 
> - clocks: clock-specifiers for the clocks named in clock-names, per the
>           common clock bindings.
> 
> - clock-names: should contain "gate" for the clock to the OneNAND flash
>                memory.
> 
> Is this the only clock that might be necessary on all platforms?

S3C64xx SoCs have only one OneNAND gate clock per controller.
S5PC100 SoC has one IP gate clock and one memory chip gate clock.
S5PC110 SoC has one gate that gates both IP and all memory chips.

Best regards,
Tomasz

