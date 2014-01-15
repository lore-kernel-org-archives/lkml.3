Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751451AbaAOGCd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 01:02:33 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:52047 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757AbaAOGCa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 01:02:30 -0500
MIME-Version: 1.0
In-Reply-To: <20140115053706.4167.23616@quantum>
References: <1388986699-6470-1-git-send-email-21cnbao@gmail.com> <20140115053706.4167.23616@quantum>
From: Barry Song <21cnbao@gmail.com>
Date: Wed, 15 Jan 2014 14:02:09 +0800
Message-ID: <CAGsJ_4x4L2rerQ18w=C7VUQmF8hR3qXrzbsmxAK5kUkoXR06YA@mail.gmail.com>
Subject: Re: [PATCH v2] clk: sirf: re-arch to make the codes support both
 prima2 and atlas6
To: Mike Turquette <mturquette@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        DL-SHA-WorkGroupLinux <workgroup.linux@csr.com>,
        Barry Song <Baohua.Song@csr.com>, Rongjun Ying <Rongjun.Ying@csr.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014/1/15 Mike Turquette <mturquette@linaro.org>:
> Quoting Barry Song (2014-01-05 21:38:19)
>> diff --git a/drivers/clk/sirf/clk-atlas6.c b/drivers/clk/sirf/clk-atlas6.c
>> new file mode 100644
>> index 0000000..21e776a
>> --- /dev/null
>> +++ b/drivers/clk/sirf/clk-atlas6.c
>> @@ -0,0 +1,153 @@
>> +/*
>> + * Clock tree for CSR SiRFatlasVI
>> + *
>> + * Copyright (c) 2011 Cambridge Silicon Radio Limited, a CSR plc group company.
>> + *
>> + * Licensed under GPLv2 or later.
>> + */
>> +
>> +#include <linux/module.h>
>> +#include <linux/bitops.h>
>> +#include <linux/io.h>
>> +#include <linux/clk.h>
>> +#include <linux/clk-private.h>
>
> Please do not use clk-private.h. It is slated for removal (some day...).
> Do you actually need it?

removed in v3.
>
> Regards,
> Mike

-barry
