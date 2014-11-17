Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752057AbaKQKEN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 05:04:13 -0500
Received: from mail-lb0-f179.google.com ([209.85.217.179]:43819 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751540AbaKQKEM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 05:04:12 -0500
MIME-Version: 1.0
In-Reply-To: <20141117092456.GA3247@distanz.ch>
References: <20141114220419.GA32497@dtor-ws>
	<20141117092456.GA3247@distanz.ch>
Date: Mon, 17 Nov 2014 18:04:10 +0800
X-Google-Sender-Auth: 6YJgUejRdKCt_6rbqQ2frDFBsF8
Message-ID: <CAFiDJ5-3j62Ert5+7jrNh4CUg91SBn1Rdq9uq9Jr_5a+KL-4JQ@mail.gmail.com>
Subject: Re: [PATCH] nios2: fix error handling of irq_of_parse_and_map
From: Ley Foon Tan <lftan@altera.com>
To: Tobias Klauser <tklauser@distanz.ch>
Cc: Dmitry Torokhov <dtor@chromium.org>,
        "nios2-dev@lists.rocketboards.org" <nios2-dev@lists.rocketboards.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 17, 2014 at 5:24 PM, Tobias Klauser <tklauser@distanz.ch> wrote:
> On 2014-11-14 at 23:04:19 +0100, Dmitry Torokhov <dtor@chromium.org> wrote:
>> Return value of irq_of_parse_and_map() is unsigned int, with 0
>> indicating failure, so testing for negative result never works.
>>
>> Signed-off-by: Dmitry Torokhov <dtor@chromium.org>
>
> Reviewed-by: Tobias Klauser <tklauser@distanz.ch>
>
> Thanks for catching this.
Thanks for your patch.

Regards
Ley Foon
