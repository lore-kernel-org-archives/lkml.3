Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754069AbaCNKul (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 06:50:41 -0400
Received: from mail-oa0-f51.google.com ([209.85.219.51]:33721 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752693AbaCNKuj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 06:50:39 -0400
MIME-Version: 1.0
In-Reply-To: <1394723102.17925.40.camel@acox1-desk.ger.corp.intel.com>
References: <1394456094-21671-1-git-send-email-mika.westerberg@linux.intel.com>
	<1394456094-21671-6-git-send-email-mika.westerberg@linux.intel.com>
	<CACRpkdY3z-XGHwn5sQKM-8cKYHzr3_40h53032ETN6PaDW779w@mail.gmail.com>
	<1394723102.17925.40.camel@acox1-desk.ger.corp.intel.com>
Date: Fri, 14 Mar 2014 11:50:39 +0100
Message-ID: <CACRpkdaoQZ4TTSyAiGuCAseyWd1e7PFGeQ0xjqwJqC=aasVdww@mail.gmail.com>
Subject: Re: [PATCH v2 5/5] gpio / ACPI: Add support for ACPI GPIO operation regions
From: Linus Walleij <linus.walleij@linaro.org>
To: "Cox, Alan" <alan.cox@intel.com>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Alexandre Courbot <gnurou@gmail.com>,
        "Lan, Tianyu" <tianyu.lan@intel.com>, "Zheng, Lv" <lv.zheng@intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 13, 2014 at 4:05 PM, Cox, Alan <alan.cox@intel.com> wrote:
>> > +                       gpiod_set_raw_value(desc, !!((1 << i) & *value));
>>
>> What is this? How can the expression !!((1 << i) possibly evaluate to
>> anything else than "true"? I don't get it. Just (desc, *value) seem more
>> apropriate.
>
>
> The expression is !!((1 << i) & *value)
>
> so its the standard C sematic for 'logical and' ? 1 : 0

Hm I missed the first paranthesis when parsing in my head,
all wrong, too bad. Thanks Alan.

Yours,
Linus Walleij
