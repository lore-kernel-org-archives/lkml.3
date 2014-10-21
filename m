Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754548AbaJUIcz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 04:32:55 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:61397 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751332AbaJUIcx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 04:32:53 -0400
MIME-Version: 1.0
In-Reply-To: <1412066704-28633-1-git-send-email-linus.walleij@linaro.org>
References: <1412066704-28633-1-git-send-email-linus.walleij@linaro.org>
Date: Tue, 21 Oct 2014 10:32:52 +0200
Message-ID: <CACRpkdYOyDMtoh6WaZhB9PQ9fn58zbbRsmgzB7HDw=v+UqhwHg@mail.gmail.com>
Subject: Re: [PATCH] RESEND RFT: pinctrl: sirf: move sgpio lock into state container
From: Linus Walleij <linus.walleij@linaro.org>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Barry Song <Baohua.Song@csr.com>, Barry Song <baohua@kernel.org>
Cc: "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 30, 2014 at 10:45 AM, Linus Walleij
<linus.walleij@linaro.org> wrote:

> Instead of referring to a global static variable for the sgpio
> locking, use the state container to contain the lock.
>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
> Barry, did you get around to testing this patch?

Shall I just apply this and see what happens?

Linus Walleij
