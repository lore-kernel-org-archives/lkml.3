Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754156AbaF3DeG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2014 23:34:06 -0400
Received: from mail-la0-f52.google.com ([209.85.215.52]:55706 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751283AbaF3DeD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2014 23:34:03 -0400
MIME-Version: 1.0
In-Reply-To: <20140628054641.GA14192@shlinux1.ap.freescale.net>
References: <1403868233-5123-1-git-send-email-punnaia@xilinx.com>
	<fa656d2d-a2a8-4b8d-a29b-e89e4bfced3e@BL2FFO11FD034.protection.gbl>
	<20140627125515.GA6025@pengutronix.de>
	<20140628054641.GA14192@shlinux1.ap.freescale.net>
Date: Mon, 30 Jun 2014 09:04:01 +0530
X-Google-Sender-Auth: rAXrG1lfix_vNqxsIbfAPOCxbMM
Message-ID: <CAGnW=Ba3SGejFPEyNt0rArPpcGwbi5Y6JkRgaw6iw4Aj4R7xJw@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] usb: chipidea: Add support for zynq usb host and
 device controller
From: punnaiah choudary kalluri <punnaia@xilinx.com>
To: Peter Chen <peter.chen@freescale.com>
Cc: Michael Grzeschik <mgr@pengutronix.de>,
        Punnaiah Choudary Kalluri 
	<punnaiah.choudary.kalluri@xilinx.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Kumar Gala <galak@codeaurora.org>, rdunlap@infradead.org,
        "michal.simek@xilinx.com" <michal.simek@xilinx.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org,
        Punnaiah Choudary <kpc528@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 28, 2014 at 11:16 AM, Peter Chen <peter.chen@freescale.com> wrote:
> On Fri, Jun 27, 2014 at 02:55:15PM +0200, Michael Grzeschik wrote:
>> Hi,
>>
>> On Fri, Jun 27, 2014 at 04:53:53PM +0530, Punnaiah Choudary Kalluri wrote:
>> > Zynq soc uses Chipidea/Synopsys usb IP core(CI13612). This patch adds
>> > necessary glue to allow the chipidea driver to work on zynq soc.
>> >
>>
>> Did you see the currently discussed patches for the generic chipidea
>> glue?
>>
>> http://www.spinics.net/lists/linux-usb/msg109576.html
>>
>> Try to improve that code instead writing another version
>> of this simple gluecode.
>>
>
> +1 if you think your version can be covered by generic one.

Ok. I will check this possibility.

Thanks,
Punnaiah
>
> --
>
> Best Regards,
> Peter Chen
