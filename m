Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754331Ab3ITUyP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 16:54:15 -0400
Received: from mail-ob0-f179.google.com ([209.85.214.179]:47884 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753076Ab3ITUyO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 16:54:14 -0400
MIME-Version: 1.0
In-Reply-To: <1379526839-14798-3-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1379526839-14798-1-git-send-email-sebastian.hesselbarth@gmail.com>
	<1379526839-14798-3-git-send-email-sebastian.hesselbarth@gmail.com>
Date: Fri, 20 Sep 2013 22:54:13 +0200
Message-ID: <CACRpkdaD9yvtxP8a6gav_KaYWYSO_uh_e6Qz2bM8-0jTpvJ9gA@mail.gmail.com>
Subject: Re: [PATCH 02/26] clk: nomadik: move src init out of nomadik_clk_init
From: Linus Walleij <linus.walleij@linaro.org>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Alessandro Rubini <rubini@unipv.it>,
        STEricsson <STEricsson_nomadik_linux@list.st.com>,
        Mike Turquette <mturquette@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 18, 2013 at 7:53 PM, Sebastian Hesselbarth
<sebastian.hesselbarth@gmail.com> wrote:

> nomadik_clk_init currently also maps system reset controller base address
> used by clocks and registers a reboot notifier. To allow further cleanup of
> nomadik clk setup, this moves system reset controller setup from
> nomadik_clk_init to its own function.
>
> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>

I don't see where it's going until I've seen the rest of the patches
but OK: Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
