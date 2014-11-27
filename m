Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751382AbaK0Nf3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 08:35:29 -0500
Received: from mail-ie0-f175.google.com ([209.85.223.175]:46886 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866AbaK0Nf2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 08:35:28 -0500
MIME-Version: 1.0
In-Reply-To: <20141114213256.GA24709@dtor-ws>
References: <20141114213256.GA24709@dtor-ws>
Date: Thu, 27 Nov 2014 14:35:27 +0100
Message-ID: <CACRpkdZsPKMCm1wv09xTPb3j1MbRRiJaeG9A7OjX+e4PreKSwA@mail.gmail.com>
Subject: Re: [PATCH] gpio-tz1090: fix error handling of irq_of_parse_and_map
From: Linus Walleij <linus.walleij@linaro.org>
To: Dmitry Torokhov <dtor@chromium.org>
Cc: Alexandre Courbot <gnurou@gmail.com>, Wolfram Sang <wsa@the-dreams.de>,
        James Hogan <james.hogan@imgtec.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 14, 2014 at 10:32 PM, Dmitry Torokhov <dtor@chromium.org> wrote:

> irq_of_parse_and_map() returns 0 on error, so testing for negative
> result never works.
>
> Signed-off-by: Dmitry Torokhov <dtor@chromium.org>

Patch applied with James' ACK.

Yours,
Linus Walleij
