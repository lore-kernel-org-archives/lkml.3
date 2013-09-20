Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754180Ab3ITUzf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 16:55:35 -0400
Received: from mail-ob0-f176.google.com ([209.85.214.176]:55467 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753650Ab3ITUze (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 16:55:34 -0400
MIME-Version: 1.0
In-Reply-To: <1379526839-14798-4-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1379526839-14798-1-git-send-email-sebastian.hesselbarth@gmail.com>
	<1379526839-14798-4-git-send-email-sebastian.hesselbarth@gmail.com>
Date: Fri, 20 Sep 2013 22:55:33 +0200
Message-ID: <CACRpkdax_csU5xMUzi-ut+g0Q2Ko8uKvb+dS9=MudouEJgJBMw@mail.gmail.com>
Subject: Re: [PATCH 03/26] clk: nomadik: declare OF clock provider
From: Linus Walleij <linus.walleij@linaro.org>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Alessandro Rubini <rubini@unipv.it>,
        STEricsson <STEricsson_nomadik_linux@list.st.com>,
        Mike Turquette <mturquette@linaro.org>,
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

> Common clock framework allows to register clock providers to get called
> on of_clk_init() by using CLK_OF_DECLARE. This converts nomadik clock
> provider to make use of it and get rid of the mach specific clk init
> call. As clocks require system reset controller base address to be
> initialized each clock driver checks src_base and calls new
> nomadik_src_init if required.
>
> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>

Looks like a good idea!
Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
