Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753990AbaFMRah (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 13:30:37 -0400
Received: from mail-ob0-f172.google.com ([209.85.214.172]:50433 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753840AbaFMRad (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 13:30:33 -0400
MIME-Version: 1.0
In-Reply-To: <CAL_JsqKJq-u7GGDfNONAT7tjAK-2AKQi64X8Au0N8gzPpEoNug@mail.gmail.com>
References: <20140610165700.GA3453@www.outflux.net>
	<CAL_JsqKJq-u7GGDfNONAT7tjAK-2AKQi64X8Au0N8gzPpEoNug@mail.gmail.com>
Date: Fri, 13 Jun 2014 10:30:33 -0700
X-Google-Sender-Auth: tq2Gs8ezHzDKO7AlQplwKyeRsIg
Message-ID: <CAGXu5jKR4Eo7QR=_N-8Y89KkShBB7yk6_vkUhvh6uOXDz0vuyw@mail.gmail.com>
Subject: Re: [PATCH] of: avoid format string parsing in kobject names
From: Kees Cook <keescook@chromium.org>
To: Rob Herring <robherring2@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 13, 2014 at 7:55 AM, Rob Herring <robherring2@gmail.com> wrote:
> On Tue, Jun 10, 2014 at 11:57 AM, Kees Cook <keescook@chromium.org> wrote:
>> This makes sure a format string cannot leak into the kobject name that
>> is constructed. (And splits the >80 character line.)
>>
>> Signed-off-by: Kees Cook <keescook@chromium.org>
>
> Applied.
>
> This seems like a non-obvious thing to do, but I guess most people
> aren't dealing directly with kobjects.

Yeah, it's really unlikely this could get reached, but I just keep
cleaning this up any time I see them just to be safe. :)

Thanks!

-Kees


-- 
Kees Cook
Chrome OS Security
