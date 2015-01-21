Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752300AbbAUI5b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 03:57:31 -0500
Received: from mail-qg0-f54.google.com ([209.85.192.54]:55527 "EHLO
	mail-qg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750938AbbAUI5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 03:57:21 -0500
MIME-Version: 1.0
In-Reply-To: <20150119200005.GP20386@saruman>
References: <1421654209-6486-1-git-send-email-Sneeker.Yeh@tw.fujitsu.com>
	<1421654209-6486-3-git-send-email-Sneeker.Yeh@tw.fujitsu.com>
	<20150119144642.GD20386@saruman>
	<2B3535C5ECE8B5419E3ECBE3007729090174814C4D@us01wembx1.internal.synopsys.com>
	<20150119200005.GP20386@saruman>
Date: Wed, 21 Jan 2015 16:57:20 +0800
Message-ID: <CAJ1gpc1MqFcGQ5tY03X_UHajoHhOcr9+o9YkqUyzvOYsqugcOQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/5] usb: dwc3: add revision number DWC3_REVISION_300A
From: Sneeker Yeh <sneeker.yeh@gmail.com>
To: Felipe Balbi <balbi@ti.com>
Cc: John Youn <John.Youn@synopsys.com>,
        Paul Zimmerman <paul.zimmerman@synopsys.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Grant Likely <grant.likely@linaro.org>, Huang Rui <ray.huang@amd.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        Andy Green <andy.green@linaro.org>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Sneeker Yeh <Sneeker.Yeh@tw.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

2015-01-20 4:00 GMT+08:00 Felipe Balbi <balbi@ti.com>:
> On Mon, Jan 19, 2015 at 07:45:31PM +0000, John Youn wrote:
>> > -----Original Message-----
>> > From: Felipe Balbi [mailto:balbi@ti.com]
>> > Sent: Monday, January 19, 2015 6:47 AM
>> >
>> > looking at Synopsys Solvnet for this IP, it shows that current version
>> > is 2.90a. There's no 3.00a. Paul, John, is there a 3.00a version of the
>> > DWC USB3 IP ?
>>
>> Yes there is, but it has not been released yet, thus it's not in Solvnet.
>
> alright, in that case, Sneeker, can you update this patch to add 2.90a
> and 3.00a macros ?

Sure,
I'll also add 2.90a in next round,

Thanks, and much appreciate,
Sneeker

>
> Thanks
>
> --
> balbi
