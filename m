Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751777AbaKJWjQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 17:39:16 -0500
Received: from mail-qa0-f52.google.com ([209.85.216.52]:40981 "EHLO
	mail-qa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182AbaKJWjP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 17:39:15 -0500
MIME-Version: 1.0
In-Reply-To: <548fd9c6edf94ca2b20299895f78b139@BN1AFFO11FD036.protection.gbl>
References: <1415504283-31321-1-git-send-email-crosthwaite.peter@gmail.com>
	<1415504283-31321-2-git-send-email-crosthwaite.peter@gmail.com>
	<548fd9c6edf94ca2b20299895f78b139@BN1AFFO11FD036.protection.gbl>
Date: Tue, 11 Nov 2014 08:39:14 +1000
Message-ID: <CAPokK=ovsR--ARj-2rNV6udbPEPqy4bChqC5FJw-u6O=cnHZQA@mail.gmail.com>
Subject: Re: [PATCH 2/2] arm: dts: zynq: Add Digilent ZYBO board
From: Peter Crosthwaite <crosthwaitepeter@gmail.com>
To: =?UTF-8?Q?S=C3=B6ren_Brinkmann?= <soren.brinkmann@xilinx.com>
Cc: linux-kernel@vger.kernel.org, michals@xilinx.com, sorenb@xilinx.com,
        Steve Wang <steven.wang@digilentinc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 10, 2014 at 7:47 AM, Sören Brinkmann
<soren.brinkmann@xilinx.com> wrote:
> Hi Peter,
>
> On Sun, 2014-11-09 at 01:38PM +1000, Peter Crosthwaite wrote:
>> Add a DTS describing the Digilent ZYBO board. Similar to ZED but with
>
> "Digilent ZYBO" here...
>
> [...]
>> +/ {
>> +     model = "Zynq ZYBO Development Board";
>> +     compatible = "xlnx,zynq-zybo", "xlnx,zynq-7000";
>
> ... "xlnx,zynq-zybo" here. Seems inconsistent. IMHO, there should rather be
> a digilent vendor prefix.
>

Was going for consistency with ZED which also makes this mistake:

    model = "Zynq Zed Development Board";
    compatible = "xlnx,zynq-zed", "xlnx,zynq-7000";

We have to choose between consistency and correctness. If we do fix it
though, what is Diglent's four-letter vendor prefix?

Regards,
Peter

> Everything else looks pretty straight forward and good.
>
>         Soren
