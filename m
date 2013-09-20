Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754633Ab3ITU4n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 16:56:43 -0400
Received: from mail-ob0-f178.google.com ([209.85.214.178]:54639 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753462Ab3ITU4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 16:56:41 -0400
MIME-Version: 1.0
In-Reply-To: <1379526839-14798-18-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1379526839-14798-1-git-send-email-sebastian.hesselbarth@gmail.com>
	<1379526839-14798-18-git-send-email-sebastian.hesselbarth@gmail.com>
Date: Fri, 20 Sep 2013 22:56:41 +0200
Message-ID: <CACRpkdYbHviadFn9Z9En6yA=smtw87fTSna13QtQHgFgub=+=A@mail.gmail.com>
Subject: Re: [PATCH 17/26] ARM: nomadik: remove custom .init_time hook
From: Linus Walleij <linus.walleij@linaro.org>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Alessandro Rubini <rubini@unipv.it>,
        STEricsson <STEricsson_nomadik_linux@list.st.com>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 18, 2013 at 7:53 PM, Sebastian Hesselbarth
<sebastian.hesselbarth@gmail.com> wrote:

> With arch/arm calling of_clk_init(NULL) from time_init(), we can now
> remove custom .init_time hooks.
>
> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
