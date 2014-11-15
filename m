Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755211AbaKOAoK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 19:44:10 -0500
Received: from mail-ig0-f173.google.com ([209.85.213.173]:33346 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752246AbaKOAoI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 19:44:08 -0500
From: Dmitry Torokhov <dtor@chromium.org>
To: James Hogan <james.hogan@imgtec.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>, Wolfram Sang <wsa@the-dreams.de>,
        linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] gpio-tz1090: fix error handling of irq_of_parse_and_map
Date: Fri, 14 Nov 2014 16:44:06 -0800
Message-ID: <4324315.2x5Mj9E2n5@dtor-glaptop>
User-Agent: KMail/4.13.3 (Linux/3.13.0-39-generic; KDE/4.13.3; x86_64; ; )
In-Reply-To: <20141114235307.GF1739@jhogan-linux.le.imgtec.org>
References: <20141114213256.GA24709@dtor-ws> <20141114235307.GF1739@jhogan-linux.le.imgtec.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, November 14, 2014 11:53:07 PM James Hogan wrote:
> On Fri, Nov 14, 2014 at 01:32:56PM -0800, Dmitry Torokhov wrote:
> > irq_of_parse_and_map() returns 0 on error, so testing for negative
> > result never works.
> > 
> > Signed-off-by: Dmitry Torokhov <dtor@chromium.org>
> 
> Good catch, thanks!
> 
> Acked-by: James Hogan <james.hogan@imgtec.com>
> 
> A quick coccinelle script shows up numerous other cases of this error
> around the kernel tree too...

Yeah, I sent out a few patches today.

Thanks,
Dmitry
