Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755405AbbAPM2W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 07:28:22 -0500
Received: from mail-ig0-f172.google.com ([209.85.213.172]:59934 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751640AbbAPM2V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 07:28:21 -0500
MIME-Version: 1.0
In-Reply-To: <CAL_JsqKQJzUOWE2oJsABH3Aa1cCD+526L0G7-WRH=LbKFxesyQ@mail.gmail.com>
References: <1420924457-12730-1-git-send-email-linus.walleij@linaro.org>
	<CAL_JsqKQJzUOWE2oJsABH3Aa1cCD+526L0G7-WRH=LbKFxesyQ@mail.gmail.com>
Date: Fri, 16 Jan 2015 13:28:20 +0100
Message-ID: <CACRpkda9YXi2MJnC_r_CWcfHM7i10oZ2d6VZUQnkix9r_M8fhg@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: fix up device tree bindings
From: Linus Walleij <linus.walleij@linaro.org>
To: Rob Herring <robherring2@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2015 at 9:06 PM, Rob Herring <robherring2@gmail.com> wrote:
> On Sat, Jan 10, 2015 at 3:14 PM, Linus Walleij <linus.walleij@linaro.org> wrote:
>> After the Nomadik pin controller was force migrated to generic pin
>> control bindings, some leftovers in the documentation need to be
>> cleaned up. The code and device trees are already migrated.
>>
>> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
>
> Applied for 3.20. Thanks.

Oh thanks! :)

I was thinking I'd take it through the pinctrl tree but the
DT tree is even better.

Yours,
Linus Walleij
