Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755635AbaEHVPb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 17:15:31 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:41505 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754628AbaEHVPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 17:15:30 -0400
MIME-Version: 1.0
In-Reply-To: <CAF2Aj3gDTYvv+vqa3FPBVdgOLwqctH0bd+coN29TpR53jNYKhg@mail.gmail.com>
References: <1397659455-13638-1-git-send-email-linus.walleij@linaro.org>
	<1397659455-13638-3-git-send-email-linus.walleij@linaro.org>
	<20140506125221.GA2870@dragon>
	<CAF2Aj3gDTYvv+vqa3FPBVdgOLwqctH0bd+coN29TpR53jNYKhg@mail.gmail.com>
Date: Thu, 8 May 2014 23:15:30 +0200
Message-ID: <CACRpkdZddOFmEYSk+sEYC+cjb5_YS0-9xh-DbCgiak1QvcY0oQ@mail.gmail.com>
Subject: Re: [PATCH 2/6] mfd: stmpe: add optional regulators
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: Shawn Guo <shawn.guo@linaro.org>, Philipp Zabel <p.zabel@pengutronix.de>,
        Shiraz Hashim <shiraz.hashim@st.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Silvio F <silvio.fricke@gmail.com>,
        spear-devel <spear-devel@list.st.com>,
        Viresh Kumar <viresh.linux@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 7, 2014 at 1:05 PM, Lee Jones <lee.jones@linaro.org> wrote:
> On 6 May 2014 13:52, "Shawn Guo" <shawn.guo@linaro.org> wrote:
>>
>> What happens for this patch?  I'm asking because I need to know if I
>> should apply patch "ARM: dts: imx6: edmqmx6: add vcc and vio power
>> supplies to stmpe".
>
> Actually I'm now a little confused as to the current status of this set, as
> there have been two fixup patches sent independently of the group.
>
> Linus, would you mind resubmitting please?

OK I'll resend with a RESEND prefix. I think the agreed way forward
is that you apply patches 1 thru 4 to the MFD tree. The rest I will
funnel in due time ...

Yours,
Linus Walleij
