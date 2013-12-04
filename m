Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932785Ab3LDPvx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 10:51:53 -0500
Received: from smtp.infotech.no ([82.134.31.41]:52802 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932508Ab3LDPvv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 10:51:51 -0500
Message-ID: <529F4F73.7060706@interlog.com>
Date: Wed, 04 Dec 2013 16:51:15 +0100
From: Douglas Gilbert <dgilbert@interlog.com>
Reply-To: dgilbert@interlog.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>,
        boris brezillon <b.brezillon@overkiz.com>
CC: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@linaro.org>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 3/3] usb: ohci-at91: use device managed clk retrieval
References: <Pine.LNX.4.44L0.1312041021120.1329-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1312041021120.1329-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13-12-04 04:21 PM, Alan Stern wrote:
> On Wed, 4 Dec 2013, boris brezillon wrote:
>
>>> The patches look fine to me.  But only the 1/3 patch fixes a bug; the
>>> others merely change the resource management.
>>
>> Do you want me to split this series ?
>>    1) the 1st patch that should be merged in 3.13
>>    2) patches 2 to 4 that might be applied later
>
> That probably would make Greg happier.

Putting my initial reporter hat on, USB OHCI is
completely broken in lk 3.13.0 rc1 and rc2 for AT91
family members. So it is difficult to make the
situation worse. IMO the whole 4 patches should go
in, since it only impacts that family. Also the kernel
is more than a month away from release. Perhaps the
naysayers should be looking around for whatever else
the "of/irq: Pass trigger type in IRQ resource flags"
patch has broken.

Doug Gilbert


