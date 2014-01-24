Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752324AbaAXI3J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 03:29:09 -0500
Received: from mail-we0-f181.google.com ([74.125.82.181]:61610 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752204AbaAXI3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 03:29:06 -0500
Date: Fri, 24 Jan 2014 08:28:59 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
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
Subject: Re: [PATCH v2 2/4] pinctrl: st: Add software edge trigger interrupt
 support.
Message-ID: <20140124082859.GJ8586@lee--X1>
References: <1389886545-31498-1-git-send-email-srinivas.kandagatla@st.com>
 <1389886651-31990-1-git-send-email-srinivas.kandagatla@st.com>
 <CACRpkdaBAnpfHBqkgU2emZrYwHGh9KvDvqfnCvaWdU5jYgxStA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkdaBAnpfHBqkgU2emZrYwHGh9KvDvqfnCvaWdU5jYgxStA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > +/*
> > + * As edge triggers are not supported at hardware level, it is supported by
> > + * software by exploiting the level trigger support in hardware.
> 
> (...)
> 
> All this is quite hard to understand. Maybe it's just because
> it's hard overall. Edge triggers are not supported by hardware
> so we use the hardware edge trigger support?
> 
> That is a bit oxymoronic...

That's not what is says. Read it again. :)

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
