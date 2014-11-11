Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753217AbaKKKbi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 05:31:38 -0500
Received: from mail-ig0-f173.google.com ([209.85.213.173]:45683 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752104AbaKKKbg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 05:31:36 -0500
MIME-Version: 1.0
In-Reply-To: <CAAVeFu+fsgG86b8iYVeHNmGqtb2m_P6esF1QFrbsMhwTh+P7Aw@mail.gmail.com>
References: <1414825380-15322-1-git-send-email-acourbot@nvidia.com>
	<CACRpkdaaXxXCm9===0zaKW5QJsHFBznnERdFrcbtKLQhxygzhA@mail.gmail.com>
	<CAAVeFu+fsgG86b8iYVeHNmGqtb2m_P6esF1QFrbsMhwTh+P7Aw@mail.gmail.com>
Date: Tue, 11 Nov 2014 11:31:35 +0100
Message-ID: <CACRpkdaA=F852HRhEYLYscCyTr5pYmNSAGw-dZU=oA4C6Qh2gA@mail.gmail.com>
Subject: Re: [RFC] gpio: remove gpio_descs global array
From: Linus Walleij <linus.walleij@linaro.org>
To: Alexandre Courbot <gnurou@gmail.com>
Cc: Alexandre Courbot <acourbot@nvidia.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 4, 2014 at 10:10 AM, Alexandre Courbot <gnurou@gmail.com> wrote:
> On Mon, Nov 3, 2014 at 11:11 PM, Linus Walleij <linus.walleij@linaro.org> wrote:
>> On Sat, Nov 1, 2014 at 8:03 AM, Alexandre Courbot <acourbot@nvidia.com> wrote:
>>
>>> The issue with this patch is its use of kzalloc() in gpiochip_add(), a
>>> function potentially called during early boot, before kzalloc() becomes
>>> usable. Hence its [RFC] status until we can find a solution for this or
>>> agree that this issue is actually never ran into (from which point can
>>> one use kzalloc()?)
>>
>> So which driver requires that the gpiochip be statically defined...
>> I heard about early call but not *that* early.
>
> Let me know if you feel adventurous - in that case I will submit a
> proper version of this patch to put in -next, and we'll see if people
> complain... :)

лес рубят — щепки летят as the russians say.

Let us have the patch.

Yours,
Linus Walleij
