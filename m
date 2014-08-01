Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754112AbaHAIRN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 04:17:13 -0400
Received: from mail-ig0-f179.google.com ([209.85.213.179]:42331 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736AbaHAIRH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 04:17:07 -0400
Date: Fri, 1 Aug 2014 09:17:00 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Jassi Brar <jaswinder.singh@linaro.org>
Cc: Devicetree List <devicetree@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        "ks.giri@samsung.com" <ks.giri@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>, Ian Campbell <ijc@hellion.org.uk>,
        Mark Rutland <mark.rutland@arm.com>, robh@kernel.org,
        Pawel Moll <pawel.moll@arm.com>,
        Courtney Cavin <courtney.cavin@sonymobile.com>,
        Matt Porter <mporter@linaro.org>,
        Craig McGeachie <slapdau@yahoo.com.au>,
        LeyFoon Tan <lftan.linux@gmail.com>,
        Loic Pallardy <loic.pallardy@st.com>, "Anna, Suman" <s-anna@ti.com>,
        Ashwin Chaugule <ashwin.chaugule@linaro.org>,
        Bjorn Andersson <bjorn@kryo.se>, Patch Tracking <patches@linaro.org>,
        Tetsuya Takinishi <t.takinishi@jp.fujitsu.com>,
        Mark Brown <broonie@linaro.org>, Kevin Hilman <khilman@linaro.org>,
        Mollie Wu <mollie.wu@linaro.org>, Andy Green <andy.green@linaro.org>
Subject: Re: [PATCHv9 2/4] mailbox: Introduce framework for mailbox
Message-ID: <20140801081700.GM9030@lee--X1>
References: <1406055250-29159-1-git-send-email-jaswinder.singh@linaro.org>
 <1406055374-29275-1-git-send-email-jaswinder.singh@linaro.org>
 <20140723085411.GG23210@lee--X1>
 <CAJe_ZhfaLqgKb3oK-m5Rpae5+zeAEk9-DLFOovq4qjBgg64b-w@mail.gmail.com>
 <20140723152649.GJ23210@lee--X1>
 <CAJe_ZhcOXyGO49sZUXnqCk9wm7WvQ01b76k7Wqxxi1S3qisDPA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJe_ZhcOXyGO49sZUXnqCk9wm7WvQ01b76k7Wqxxi1S3qisDPA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Jul 2014, Jassi Brar wrote:

> On 23 July 2014 20:56, Lee Jones <lee.jones@linaro.org> wrote:
> > On Wed, 23 Jul 2014, Jassi Brar wrote:
> 
> >> >> +     if (chan->txdone_method == (TXDONE_BY_POLL | TXDONE_BY_ACK))
> >> >> +             chan->txdone_method = TXDONE_BY_POLL;
> >> >
> >> > Unless you're leaving it there for clarity, you can drop the
> >> > "TXDONE_BY_POLL |" from if().
> >> >
> >> We need to check for both.
> >
> > What I'm trying to get at is; if it's already TXDONE_BY_POLL, there is no
> > need to set it to TXDONE_BY_POLL.
> >
> In mbox_request_channel() we added the ACK flag, if POLL was set and
> now we need to revert that in mbox_free_channel().

Okay, I see what you're doing.  Thanks for the clarification.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
