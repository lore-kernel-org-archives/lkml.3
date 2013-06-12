Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755756Ab3FLIil (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 04:38:41 -0400
Received: from mail-ob0-f181.google.com ([209.85.214.181]:38490 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752512Ab3FLIii (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 04:38:38 -0400
MIME-Version: 1.0
In-Reply-To: <20130612075225.GI4107@intel.com>
References: <1370435206-13474-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1370435206-13474-3-git-send-email-andriy.shevchenko@linux.intel.com>
	<20130612050829.GB4107@intel.com>
	<CAHp75Ver2xo2f9crQZkAmJcTF=5cZZa3NgvufPqQW3+uTXffJA@mail.gmail.com>
	<20130612073806.GG4107@intel.com>
	<CAHp75VfsSDdLa_uPULbhVGproxnD5mofYm62O75y4xRbPBJ7pQ@mail.gmail.com>
	<20130612075225.GI4107@intel.com>
Date: Wed, 12 Jun 2013 11:38:37 +0300
Message-ID: <CAHp75Vc=hO_FF0WMvhPm6MMRuCb+=MhOEOCSYb_TaCRf-xQ=sg@mail.gmail.com>
Subject: Re: [PATCH v2 2/4] dma: move dw_dmac driver to an own directory
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.jf.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        spear-devel <spear-devel@list.st.com>,
        Viresh Kumar <viresh.kumar@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Felipe Balbi <balbi@ti.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 12, 2013 at 10:52 AM, Vinod Koul <vinod.koul@intel.com> wrote:
> On Wed, Jun 12, 2013 at 11:27:51AM +0300, Andy Shevchenko wrote:
>> On Wed, Jun 12, 2013 at 10:39 AM, Vinod Koul <vinod.koul@intel.com> wrote:
>>
>> []
>>
>> > Something like
>> > config DW_DMAC_BIG_ENDIAN_IO
>> >         tristate
>> >
>> > config DW_DMAC
>> >         select DW_DMAC_BIG_ENDIAN_IO
>> >
>> > I belive DW_DMAC is for AVR support and the PCI ones is different right.
>> > The point is that these things should be selected by the required symbols based
>> > on what ARCH we are on and not be prompted for user to configure via menuconfig
>>
>> DW_DMAC is a generic platform driver which supports AVR32, ARM and
>> Intel (ACPI case) platforms.
>>
>> We may do that option invisible to user
> Yup
>>
>> and then use
>>
>> config DW_DMAC
>>          select DW_DMAC_BIG_ENDIAN_IO if ARCH=AVR32
> Thats would be the right way

Do you prefer to have this as separate patch or integrated in the split?
In my humble opinion I better to do separate patch.

--
With Best Regards,
Andy Shevchenko
