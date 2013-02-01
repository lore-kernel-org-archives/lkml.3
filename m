Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756571Ab3BAJxn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 04:53:43 -0500
Received: from mail-ia0-f182.google.com ([209.85.210.182]:56141 "EHLO
	mail-ia0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756235Ab3BAJxh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 04:53:37 -0500
MIME-Version: 1.0
In-Reply-To: <51085315.2000302@free-electrons.com>
References: <1359313332-12305-1-git-send-email-maxime.ripard@free-electrons.com>
	<1359313332-12305-2-git-send-email-maxime.ripard@free-electrons.com>
	<CACRpkdZi0zCNf6LDd9UAcd57kFqqWyteVqxL8WfDrFfrt9_5sQ@mail.gmail.com>
	<51085315.2000302@free-electrons.com>
Date: Fri, 1 Feb 2013 10:53:36 +0100
Message-ID: <CACRpkdYzX8PFVLei0+UJvEA6rGq_RBGsMKdRs0RnmAQL3h7S5A@mail.gmail.com>
Subject: Re: [PATCH 1/3] pinctrl: sunxi: Add of_xlate function
From: Linus Walleij <linus.walleij@linaro.org>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: linux-arm-kernel@lists.infradead.org, Emilio Lopez <emilio@elopez.com.ar>,
        Alejandro Mery <amery@geeks.cl>, Stefan Roese <sr@denx.de>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 29, 2013 at 11:54 PM, Maxime Ripard
<maxime.ripard@free-electrons.com> wrote:
> Le 29/01/2013 23:41, Linus Walleij a écrit :
>> On Sun, Jan 27, 2013 at 8:02 PM, Maxime Ripard
>> <maxime.ripard@free-electrons.com> wrote:
>>
>>> Since the pin controller of sunxi chips is represented as a single bank
>>> in the driver.
>>> Since this is neither convenient nor represented that way in the
>>> datasheets, define a custom of_xlate function with the layout <bank pin
>>> flag>
>>>
>>> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
>>
>> This does not apply and I only have 1/3 it seems?
>>
>> Sorry, help me understand which order these patches go in...
>
> My bad, I forgot to mention the order of the patchsets, and to cc you
> for the all series... Sorry about that.
>
> This patch should come after the patch series that adds the support for
> the A10 SoCs in the pinctrl driver.

I now tried to apply this on top of the A10 series and it
*still* does not apply.

> Do you want me to resend this serie and cc you?

Please rebase these three on my allwinner branch:
git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-pinctrl.git
allwinner-sunxi

Seen here:
http://git.kernel.org/?p=linux/kernel/git/linusw/linux-pinctrl.git;a=shortlog;h=refs/heads/allwinner-sunxi

Yours,
Linus Walleij
