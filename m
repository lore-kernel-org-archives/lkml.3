Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933270Ab3DDHct (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 03:32:49 -0400
Received: from mail-bk0-f45.google.com ([209.85.214.45]:54156 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933245Ab3DDHcr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 03:32:47 -0400
MIME-Version: 1.0
In-Reply-To: <20130404071015.GB30287@arwen.pp.htv.fi>
References: <1364824448-14732-1-git-send-email-gautam.vivek@samsung.com>
	<20130403172751.GC10089@xanatos>
	<CAFp+6iGnDUSOjVgu9ZCAPF9rUDWD5r9ZttBtTo864Q2ACvKFrA@mail.gmail.com>
	<20130404071015.GB30287@arwen.pp.htv.fi>
Date: Thu, 4 Apr 2013 13:02:45 +0530
Message-ID: <CAFp+6iGqDFPhNjktD3WA4ZJuEdcX1C7Ma3hsSZieuW-b4_wpLA@mail.gmail.com>
Subject: Re: [PATCH v3 00/11] usb: dwc3/xhci/phy: Enable runtime power management
From: Vivek Gautam <gautamvivek1987@gmail.com>
To: balbi@ti.com
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Vivek Gautam <gautam.vivek@samsung.com>, linux-usb@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        stern@rowland.harvard.edu, rob.herring@calxeda.com,
        kgene.kim@samsung.com, kishon@ti.com, dianders@chromium.org,
        t.figa@samsung.com, p.paneri@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 4, 2013 at 12:40 PM, Felipe Balbi <balbi@ti.com> wrote:
> On Thu, Apr 04, 2013 at 10:34:57AM +0530, Vivek Gautam wrote:
>> Hi Sarah,
>>
>>
>> On Wed, Apr 3, 2013 at 10:57 PM, Sarah Sharp
>> <sarah.a.sharp@linux.intel.com> wrote:
>> > Question: Do you still need this patch for 3.10?
>>
>> Felipe's 'next' is closed for 3.10, so this series won't be making it
>> to 3.10 now, as a whole. :-(
>
> right, besides we're still discussing what to do with the whole PHY
> part, right ?

Right ofcourse. :-)



-- 
Thanks & Regards
Vivek
