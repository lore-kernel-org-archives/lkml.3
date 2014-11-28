Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751590AbaK1X6R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 18:58:17 -0500
Received: from mail-qc0-f169.google.com ([209.85.216.169]:41911 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751530AbaK1X6O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 18:58:14 -0500
MIME-Version: 1.0
In-Reply-To: <OFCF68BFE0.14A043A7-ON86257D8D.000BF746-86257D8D.000BF749@ni.com>
References: <1415504283-31321-1-git-send-email-crosthwaite.peter@gmail.com>
	<1415504283-31321-2-git-send-email-crosthwaite.peter@gmail.com>
	<548fd9c6edf94ca2b20299895f78b139@BN1AFFO11FD036.protection.gbl>
	<CAPokK=ovsR--ARj-2rNV6udbPEPqy4bChqC5FJw-u6O=cnHZQA@mail.gmail.com>
	<a7677222807f4dd3a7d74df647e48598@BL2FFO11FD053.protection.gbl>
	<CAPokK=ohd6L=ExZ7xQCGpEDj=BbN6RUec2F+=Trz3BCn1Nw-sQ@mail.gmail.com>
	<OFCF68BFE0.14A043A7-ON86257D8D.000BF746-86257D8D.000BF749@ni.com>
Date: Sat, 29 Nov 2014 09:58:13 +1000
Message-ID: <CAPokK=r6qVrpdHrM=NeDabkijQWB3R-r7LKuTcXcYdxLBBqDTQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] arm: dts: zynq: Add Digilent ZYBO board
From: Peter Crosthwaite <crosthwaitepeter@gmail.com>
To: Steve Wang <steven.wang@digilentinc.com>
Cc: linux-kernel@vger.kernel.org, michals@xilinx.com,
        =?UTF-8?Q?S=C3=B6ren_Brinkmann?= <soren.brinkmann@xilinx.com>,
        sorenb@xilinx.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steve,

On Tue, Nov 11, 2014 at 12:10 PM, Steve Wang
<steven.wang@digilentinc.com> wrote:
> Hi, Peter,
>
> According to naming convention, I think "dglnt" is good enough ^.^
>
> By the way, I think there is a need to address another issue that needs to
> be addressed for ZYBO as well (maybe in a separate thread):
> MAC address pre-load from on-board EEPROM.

So i'm not doing any networking work so I don't have visibility of
this feature. My understanding though is its an extra feature and
default networking behaviour provided by the SoC should still be
functional making this follow up work?

The alternative would be to disable gem in the dts on first commit.

> I think ZYBO might still be the only Zynq-based board that has an on-board
> EEPROM for MAC address as well.
>

Is that just software policy though? Should there be DTS level
awareness of MAC address via EEPROM contents or should the dts just
describe the EEPROM?

Regards,
Peter

> Regards,
> Steve
>
> -----Peter Crosthwaite <crosthwaitepeter@gmail.com> wrote: -----
> To: Sören Brinkmann <soren.brinkmann@xilinx.com>, Steve Wang
> <steven.wang@digilentinc.com>
> From: Peter Crosthwaite <crosthwaitepeter@gmail.com>
> Date: 11/10/2014 02:56PM
> Cc: linux-kernel@vger.kernel.org, michals@xilinx.com, sorenb@xilinx.com
> Subject: Re: [PATCH 2/2] arm: dts: zynq: Add Digilent ZYBO board
>
>
> On Tue, Nov 11, 2014 at 8:42 AM, Sören Brinkmann
> <soren.brinkmann@xilinx.com> wrote:
>> On Tue, 2014-11-11 at 08:39AM +1000, Peter Crosthwaite wrote:
>>> On Mon, Nov 10, 2014 at 7:47 AM, Sören Brinkmann
>>> <soren.brinkmann@xilinx.com> wrote:
>>> > Hi Peter,
>>> >
>>> > On Sun, 2014-11-09 at 01:38PM +1000, Peter Crosthwaite wrote:
>>> >> Add a DTS describing the Digilent ZYBO board. Similar to ZED but with
>>> >
>>> > "Digilent ZYBO" here...
>>> >
>>> > [...]
>>> >> +/ {
>>> >> +     model = "Zynq ZYBO Development Board";
>>> >> +     compatible = "xlnx,zynq-zybo", "xlnx,zynq-7000";
>>> >
>>> > ... "xlnx,zynq-zybo" here. Seems inconsistent. IMHO, there should
>>> > rather be
>>> > a digilent vendor prefix.
>>> >
>>>
>>> Was going for consistency with ZED which also makes this mistake:
>>>
>>>     model = "Zynq Zed Development Board";
>>>     compatible = "xlnx,zynq-zed", "xlnx,zynq-7000";
>>>
>>> We have to choose between consistency and correctness. If we do fix it
>>> though, what is Diglent's four-letter vendor prefix?
>>
>> Since Digilent is the board vendor, I'm for using the appropriate
>> prefix. Vendor prefixes are found in
>> Documentation/devicetree/bindings/vendor-prefixes.txt.
>>
>
> It's not there,
>
> Steven, does Digilent have a preferred dts vendor prefix?
>
> Regards,
> Peter
>
>>         Soren
