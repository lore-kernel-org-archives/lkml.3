Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752104Ab3LLTCa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 14:02:30 -0500
Received: from mail-ob0-f179.google.com ([209.85.214.179]:48164 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751785Ab3LLTC1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 14:02:27 -0500
MIME-Version: 1.0
In-Reply-To: <1386717544-478-1-git-send-email-sboyd@codeaurora.org>
References: <1386717544-478-1-git-send-email-sboyd@codeaurora.org>
Date: Thu, 12 Dec 2013 20:02:27 +0100
Message-ID: <CACRpkdY8W8tGVH-Os5neeFfHWjojdB5fBbjgWcsWkiMyJj=YAA@mail.gmail.com>
Subject: Re: [PATCH 1/2] gpio: msm: Fix irq mask/unmask by writing bits
 instead of numbers
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Boyd <sboyd@codeaurora.org>,
        Bjorn Andersson <Bjorn.Andersson@sonymobile.com>,
        Rohit Vaswani <rvaswani@codeaurora.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 11, 2013 at 12:19 AM, Stephen Boyd <sboyd@codeaurora.org> wrote:

> We should be writing bits here but instead we're writing the
> numbers that correspond to the bits we want to write. Fix it by
> wrapping the numbers in the BIT() macro. This fixes gpios acting
> as interrupts.
>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>

I've applied this for fixes and tagged for stable.
Björn, Rohit: OK?

Yours,
Linus Walleij
