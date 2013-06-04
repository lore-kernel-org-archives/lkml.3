Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751627Ab3FDSeX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 14:34:23 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:40008 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751361Ab3FDSeT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 14:34:19 -0400
From: Kevin Hilman <khilman@linaro.org>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: linux-kernel@vger.kernel.org, Sekhar Nori <nsekhar@ti.com>,
        Tony Lindgren <tony@atomide.com>, Ben Dooks <ben-linux@fluff.org>,
        Kukjin Kim <kgene.kim@samsung.com>, Barry Song <baohua.song@csr.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        davinci-linux-open-source@linux.davincidsp.com,
        linux-i2c@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [RFC 09/42] drivers/i2c/busses: don't check resource with devm_ioremap_resource
References: <1368173847-5661-1-git-send-email-wsa@the-dreams.de>
	<1368173847-5661-10-git-send-email-wsa@the-dreams.de>
Date: Tue, 04 Jun 2013 11:34:15 -0700
In-Reply-To: <1368173847-5661-10-git-send-email-wsa@the-dreams.de> (Wolfram
	Sang's message of "Fri, 10 May 2013 10:16:54 +0200")
Message-ID: <87txldzpw8.fsf@linaro.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wolfram Sang <wsa@the-dreams.de> writes:

> devm_ioremap_resource does sanity checks on the given resource. No need to
> duplicate this in the driver.
>
> Signed-off-by: Wolfram Sang <wsa@the-dreams.de>

Acked-by: Kevin Hilman <khilman@linaro.org>  # for i2c-omap.c

