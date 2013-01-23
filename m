Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755049Ab3AWKQV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 05:16:21 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:64254 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754709Ab3AWKQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 05:16:19 -0500
MIME-Version: 1.0
In-Reply-To: <20130121122203.GA30289@balto.lan>
References: <1358770172-30125-1-git-send-email-fabio.baltieri@linaro.org>
	<20130121122203.GA30289@balto.lan>
Date: Wed, 23 Jan 2013 11:16:19 +0100
Message-ID: <CACRpkdacW89oq+yyjayY2674UGPdnnHS5veQsn2DaZ4-nao1Pg@mail.gmail.com>
Subject: Re: [PATCH 1/2] clocksource: dbx500-prcmu: use relaxed readl variant
From: Linus Walleij <linus.walleij@linaro.org>
To: Fabio Baltieri <fabio.baltieri@linaro.org>,
        John Stultz <johnstul@us.ibm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Rabin Vincent <rabin.vincent@stericsson.com>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 21, 2013 at 1:22 PM, Fabio Baltieri
<fabio.baltieri@linaro.org> wrote:
> On Mon, Jan 21, 2013 at 01:09:31PM +0100, Fabio Baltieri wrote:
>> From: Rabin Vincent <rabin.vincent@stericsson.com>
>>
>> Modify clksrc_dbx500_prcmu_read to replace readl() with readl_relaxed().
>> This speeds up calls to the function by about 40%.
>
> Hello John,
>
> these two patches may go in the existing ux500 clksrc branch
> together with the nomadik-mtu's patches queued up some time ago.
>
> Can I have your Acked-by for that?

Actually now when I look at it these changes are fully orthogonal
to the other stuff, so these two should just go in through John's
timer tree as usual.

John?

Yours,
Linus Walleij
