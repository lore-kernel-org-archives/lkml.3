Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753286Ab3KYXQ2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 18:16:28 -0500
Received: from mail-qe0-f53.google.com ([209.85.128.53]:53812 "EHLO
	mail-qe0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752703Ab3KYXQZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 18:16:25 -0500
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:1b02:6e3b:e5ff:fe16:f1aa]
In-Reply-To: <CAD=FV=VHLHL-VxUr_G7CoBQ5UY8t1jbdTCwcGz9BYrR5C3cpAQ@mail.gmail.com>
References: <1382533861-12688-1-git-send-email-dianders@chromium.org>
	<CAD=FV=VHLHL-VxUr_G7CoBQ5UY8t1jbdTCwcGz9BYrR5C3cpAQ@mail.gmail.com>
Date: Mon, 25 Nov 2013 15:16:23 -0800
Message-ID: <CAOesGMhfioBLMgmFi7EHrkVys_96KKzBcLp0C8sdLaRs5FMJBw@mail.gmail.com>
Subject: Re: [PATCH] ARM: dts: Add max77686 RTC interrupt to cros5250-common
From: Olof Johansson <olof@lixom.net>
To: Doug Anderson <dianders@chromium.org>
Cc: Kukjin Kim <kgene.kim@samsung.com>, Marc Zyngier <marc.zyngier@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        Rahul Sharma <rahul.sharma@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 25, 2013 at 3:11 PM, Doug Anderson <dianders@chromium.org> wrote:
> Olof or Kukjin,
>
> On Wed, Oct 23, 2013 at 6:11 AM, Doug Anderson <dianders@chromium.org> wrote:
>> Without the interrupt you'll get problems if you enable
>> CONFIG_RTC_DRV_MAX77686.  Setup the interrupt properly in the device
>> tree.
>>
>> Signed-off-by: Doug Anderson <dianders@chromium.org>
>> ---
>>  arch/arm/boot/dts/cros5250-common.dtsi | 12 ++++++++++++
>>  1 file changed, 12 insertions(+)
>
> Would one of you be interested in applying this to your tree, with
> Marc's "Tested-by"?  I know there are lots more things to fixup in the
> dts, but this is one that I know works.  ;)

Yes, I'll apply this to fixes for 3.13, and mark it for stable 3.12 at least.


-Olof
