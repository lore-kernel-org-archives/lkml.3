Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753550AbaA0Jnk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 04:43:40 -0500
Received: from mail-oa0-f41.google.com ([209.85.219.41]:55926 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753431AbaA0Jnh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 04:43:37 -0500
MIME-Version: 1.0
In-Reply-To: <20140124082859.GJ8586@lee--X1>
References: <1389886545-31498-1-git-send-email-srinivas.kandagatla@st.com>
	<1389886651-31990-1-git-send-email-srinivas.kandagatla@st.com>
	<CACRpkdaBAnpfHBqkgU2emZrYwHGh9KvDvqfnCvaWdU5jYgxStA@mail.gmail.com>
	<20140124082859.GJ8586@lee--X1>
Date: Mon, 27 Jan 2014 10:43:37 +0100
Message-ID: <CACRpkdb9cM_dh7UNpErv+gKrvMW0HbE7NcZq22AiZfEjrqS1qA@mail.gmail.com>
Subject: Re: [PATCH v2 2/4] pinctrl: st: Add software edge trigger interrupt support.
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>,
        Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Rob Landley <rob@landley.net>,
        Kumar Gala <galak@codeaurora.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 24, 2014 at 9:28 AM, Lee Jones <lee.jones@linaro.org> wrote:
>> > +/*
>> > + * As edge triggers are not supported at hardware level, it is supported by
>> > + * software by exploiting the level trigger support in hardware.
>>
>> (...)
>>
>> All this is quite hard to understand. Maybe it's just because
>> it's hard overall. Edge triggers are not supported by hardware
>> so we use the hardware edge trigger support?
>>
>> That is a bit oxymoronic...
>
> That's not what is says. Read it again. :)

Argh yeah I was wrong ... it's perfectly consistent with the
implementation. Sorry for being such a slow brain this last
friday.

Yours,
Linus Walleij
