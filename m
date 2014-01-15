Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751306AbaAOFhR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 00:37:17 -0500
Received: from mail-gg0-f173.google.com ([209.85.161.173]:36112 "EHLO
	mail-gg0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718AbaAOFhP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 00:37:15 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Barry Song <21cnbao@gmail.com>, linux-kernel@vger.kernel.org
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <1388986699-6470-1-git-send-email-21cnbao@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, workgroup.linux@csr.com,
        "Barry Song" <Baohua.Song@csr.com>,
        "Rongjun Ying" <Rongjun.Ying@csr.com>
References: <1388986699-6470-1-git-send-email-21cnbao@gmail.com>
Message-ID: <20140115053706.4167.23616@quantum>
User-Agent: alot/0.3.5
Subject: Re: [PATCH v2] clk: sirf: re-arch to make the codes support both prima2 and
 atlas6
Date: Tue, 14 Jan 2014 21:37:06 -0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Barry Song (2014-01-05 21:38:19)
> diff --git a/drivers/clk/sirf/clk-atlas6.c b/drivers/clk/sirf/clk-atlas6.c
> new file mode 100644
> index 0000000..21e776a
> --- /dev/null
> +++ b/drivers/clk/sirf/clk-atlas6.c
> @@ -0,0 +1,153 @@
> +/*
> + * Clock tree for CSR SiRFatlasVI
> + *
> + * Copyright (c) 2011 Cambridge Silicon Radio Limited, a CSR plc group company.
> + *
> + * Licensed under GPLv2 or later.
> + */
> +
> +#include <linux/module.h>
> +#include <linux/bitops.h>
> +#include <linux/io.h>
> +#include <linux/clk.h>
> +#include <linux/clk-private.h>

Please do not use clk-private.h. It is slated for removal (some day...).
Do you actually need it?

Regards,
Mike
