Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934031Ab3FSBgA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 21:36:00 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:51416 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932687Ab3FSBf6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 21:35:58 -0400
MIME-Version: 1.0
In-Reply-To: <20130618201245.GB14784@arwen.pp.htv.fi>
References: <20130618173030.16d73801ab72b7c611faccea@canb.auug.org.au>
 <51C0AC74.5050705@infradead.org> <20130618201245.GB14784@arwen.pp.htv.fi>
From: Peter Chen <hzpeterchen@gmail.com>
Date: Wed, 19 Jun 2013 09:35:37 +0800
Message-ID: <CAL411-qXeUNhL5Gw35LCC6QVRmym9mjAV_iedq-L+18QCd8-pA@mail.gmail.com>
Subject: Re: linux-next: Tree for Jun 18 usb/chipidea)
To: "balbi@ti.com" <balbi@ti.com>
Cc: Randy Dunlap <rdunlap@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, USB list <linux-usb@vger.kernel.org>,
        David Lopo <dlopo@chipidea.mips.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 19, 2013 at 4:12 AM, Felipe Balbi <balbi@ti.com> wrote:
> Hi,
>
> On Tue, Jun 18, 2013 at 11:52:36AM -0700, Randy Dunlap wrote:
>> On 06/18/13 00:30, Stephen Rothwell wrote:
>> > Hi all,
>> >
>> > Changes since 20130617:
>> >
>>
>>
>> on i386:
>>
>> # CONFIG_USB_PHY is not set
>>
>> drivers/built-in.o: In function `ci_hdrc_probe':
>> core.c:(.text+0x20446b): undefined reference to `of_usb_get_phy_mode'
>>
>>
>> chipidea needs to depend on or select some kind of USB_PHY support...?
>
> hmm, looks like a missing stub to me. Alex ?
>
> --
> balbi

Seems i386 chooses CONFIG_OF, but not CONFIG_USB_PHY.
I will send a patch to fix it.

--
BR,
Peter Chen
