Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752409AbaFFLCG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 07:02:06 -0400
Received: from mail-qa0-f48.google.com ([209.85.216.48]:45189 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751494AbaFFLCE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 07:02:04 -0400
MIME-Version: 1.0
In-Reply-To: <20140606071106.GA30156@kwain>
References: <1401983326-19205-1-git-send-email-antoine.tenart@free-electrons.com>
	<1401983326-19205-5-git-send-email-antoine.tenart@free-electrons.com>
	<CAFp+6iEKLD_rLg84h3J2oyzw7vizEV-Eqo0e_jqurx_v9ZX2JA@mail.gmail.com>
	<20140606071106.GA30156@kwain>
Date: Fri, 6 Jun 2014 16:32:03 +0530
X-Google-Sender-Auth: RzYx2Xtik9Ht137qFzE_4jW_70U
Message-ID: <CAFp+6iH+J4T=7pJU_+ZZKrgDwJWwQfznv9NWuy5SkLgz_j75_Q@mail.gmail.com>
Subject: Re: [PATCH 4/9] usb: phy: add the Berlin USB PHY driver
From: Vivek Gautam <gautam.vivek@samsung.com>
To: =?UTF-8?Q?Antoine_T=C3=A9nart?= <antoine.tenart@free-electrons.com>
Cc: kishon <kishon@ti.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Felipe Balbi <balbi@ti.com>, alexandre.belloni@free-electrons.com,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        zhiming Xu <zmxu@marvell.com>, jszhang@marvell.com,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Jun 6, 2014 at 12:41 PM, Antoine Ténart
<antoine.tenart@free-electrons.com> wrote:
> Hi,
>
> On Fri, Jun 06, 2014 at 12:09:06PM +0530, Vivek Gautam wrote:
>> On Thu, Jun 5, 2014 at 9:18 PM, Antoine Ténart
>> <antoine.tenart@free-electrons.com> wrote:
>> > Add the driver driving the Marvell Berlin USB PHY. This allows to
>> > initialize the PHY and to use it from the USB driver later.
>>
>> Just out of curiosity, going forward we would like to have phy drivers based on
>> generic phy framework (drivers/phy).
>> Any particular reason that we are still adding phy drivers in usb-phy layer ?
>>
>> Looking at it, seems like it can very well be written based on phy framework.
>
> This USB controller are ChipIdea compatible, and the ChipIdea common
> functions use the usb_phy framework. That's why this PHY driver is
> there.

Ok, i see that now. In that case shouldn't we be moving even the chipidea
drivers to use the generic phy functions to get the phy and init/exit it.

I think Felipe and Kishon can comment on this better, and tell how
things should be. :-)

[snip]


-- 
Best Regards
Vivek Gautam
Samsung R&D Institute, Bangalore
India
