Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752468Ab3ISIpq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 04:45:46 -0400
Received: from mail-qa0-f49.google.com ([209.85.216.49]:35203 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751892Ab3ISIpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 04:45:44 -0400
MIME-Version: 1.0
In-Reply-To: <1379526839-14798-5-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1379526839-14798-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1379526839-14798-5-git-send-email-sebastian.hesselbarth@gmail.com>
From: Barry Song <21cnbao@gmail.com>
Date: Thu, 19 Sep 2013 16:45:23 +0800
Message-ID: <CAGsJ_4xC_g1C-pGQGrcLOBhKLSMG3D8369DRPoFgNZhKqs-aTQ@mail.gmail.com>
Subject: Re: [PATCH 04/26] clk: prima2: declare OF clock provider
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Mike Turquette <mturquette@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        LKML <linux-kernel@vger.kernel.org>, Barry Song <baohua.song@csr.com>,
        Olof Johansson <olof@lixom.net>, Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> @@ -1124,3 +1106,4 @@ void __init sirfsoc_of_clk_init(void)
>
>         of_clk_add_provider(np, of_clk_src_onecell_get, &clk_data);
>  }
> +CLK_OF_DECLARE(sirfsoc_clk, "sirf,prima2-clkc", sirfsoc_clk_init);

hi Sebastian,
what if the driver is compatible with multiple clk controllers and we
want to add another compatible string here except "sirf,prima2-clkc"?

-barry
