Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753630AbaDWLjM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 07:39:12 -0400
Received: from mail-ob0-f178.google.com ([209.85.214.178]:46766 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751361AbaDWLjH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 07:39:07 -0400
MIME-Version: 1.0
In-Reply-To: <20140417104925.GM28725@lee--X1>
References: <1397659455-13638-1-git-send-email-linus.walleij@linaro.org>
	<1397659455-13638-2-git-send-email-linus.walleij@linaro.org>
	<20140417104925.GM28725@lee--X1>
Date: Wed, 23 Apr 2014 13:39:06 +0200
Message-ID: <CACRpkdaHQkOMx1NrAWkDd0prc1AqXRs-p69TX9ihoPUhx49oEQ@mail.gmail.com>
Subject: Re: [PATCH 1/6] mfd: stmpe: root out static GPIO and IRQ assignments
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Silvio F <silvio.fricke@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Shawn Guo <shawn.guo@linaro.org>,
        Viresh Kumar <viresh.linux@gmail.com>,
        Shiraz Hashim <shiraz.hashim@st.com>,
        spear-devel <spear-devel@list.st.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 17, 2014 at 12:49 PM, Lee Jones <lee.jones@linaro.org> wrote:
>> The only platform using the STMPE expander now boots from
>> device tree using all-dynamic GPIO and IRQ number assignments, so
>> remove the mechanism to pass this from the device tree entirely.
>>
>> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
>> ---
>>  drivers/gpio/gpio-stmpe.c | 18 +++++-------------
>>  drivers/mfd/stmpe.c       |  3 +--
>>  include/linux/mfd/stmpe.h | 14 --------------
>>  3 files changed, 6 insertions(+), 29 deletions(-)
>
> MFD changes look good to me.
>
> Acked-by: Lee Jones <lee.jones@linaro.org>
>
> Do you want me to set up and immutable branch between MFD and GPIO?

That would be perfect. Can you stack up the MFD portions in patches
1 thru 4 (given you're happy with the v2 of 3/6) and provide a branch
to me, please?

Yours,
Linus Walleij
