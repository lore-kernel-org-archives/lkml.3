Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751382AbaEWHeL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 03:34:11 -0400
Received: from mail-oa0-f41.google.com ([209.85.219.41]:49928 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178AbaEWHeG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 03:34:06 -0400
MIME-Version: 1.0
In-Reply-To: <CAAVeFu+8MQwBtUaz5r84zGgJZMLns1XzOkUWTtd+mTk6VF-ieQ@mail.gmail.com>
References: <1400306090-4092-1-git-send-email-acourbot@nvidia.com>
	<CACRpkdbfNpx6fHZyQTP1X3NSxBe_u2OXLgnNOmLuKvYq9ghprA@mail.gmail.com>
	<CAAVeFu+8MQwBtUaz5r84zGgJZMLns1XzOkUWTtd+mTk6VF-ieQ@mail.gmail.com>
Date: Fri, 23 May 2014 09:34:06 +0200
Message-ID: <CACRpkdbpFv_7Up93tz68nKU1doZzgauMKKhZ7UHAS1KAnZ5wfA@mail.gmail.com>
Subject: Re: [PATCH v2] gpio: make of_get_named_gpiod_flags() private
From: Linus Walleij <linus.walleij@linaro.org>
To: Alexandre Courbot <gnurou@gmail.com>
Cc: Alexandre Courbot <acourbot@nvidia.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 23, 2014 at 5:34 AM, Alexandre Courbot <gnurou@gmail.com> wrote:

> Looks like the world did not break this time. However I noticed that
> the commit in your tree (and -next) included the changes since v1 in
> its log. Is it intended?

Yeah I copy that into the changelog sometimes. If I need that info
it's easier to have it in the commit message than looking up the mail.
Grant had this preference too.

Yours,
Linus Walleij
