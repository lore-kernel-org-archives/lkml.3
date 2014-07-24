Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932886AbaGXNad (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 09:30:33 -0400
Received: from mail-oa0-f51.google.com ([209.85.219.51]:41136 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932723AbaGXNaa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 09:30:30 -0400
MIME-Version: 1.0
In-Reply-To: <20140723173625.GA38489@core.coreip.homeip.net>
References: <20140723173625.GA38489@core.coreip.homeip.net>
Date: Thu, 24 Jul 2014 15:30:29 +0200
Message-ID: <CACRpkdZUqRPzZGWmU0=XpR9pnFUPYZiCewuEqnpfH1jOpXAOZw@mail.gmail.com>
Subject: Re: [PATCH] Input: ipaq-micro-ts - introduce open/close
From: Linus Walleij <linus.walleij@linaro.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Linux Input <linux-input@vger.kernel.org>,
        Alessandro GARDICH <gremlin@gremlin.it>,
        Dmitry Artamonow <mad_soft@inbox.ru>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2014 at 7:36 PM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:

> Wire up open/close so we do not try to send events until someone uses them;
> this also allows us to remove micro_ts_remove() and rely fully on managed
> resources.
>
> Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>

Looks good.
Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
