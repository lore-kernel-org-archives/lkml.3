Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751537AbaA2KCa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 05:02:30 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:46804 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750938AbaA2KC1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 05:02:27 -0500
Message-ID: <52E8D1AB.7080002@gmail.com>
Date: Wed, 29 Jan 2014 11:02:19 +0100
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        Mike Turquette <mturquette@linaro.org>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus <torvalds@linux-foundation.org>
Subject: Re: linux-next: build failure after merge of the clk tree
References: <20140129143203.3856df2abbf5f3c52b444ca5@canb.auug.org.au>
In-Reply-To: <20140129143203.3856df2abbf5f3c52b444ca5@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/29/2014 04:32 AM, Stephen Rothwell wrote:
> After merging the clk tree, today's linux-next build (x86_64 allmodconfig)
> failed like this:
>
> drivers/clk/clk-si5351.c: In function 'si5351_i2c_probe':
> drivers/clk/clk-si5351.c:1314:2: error: too many arguments to function 'si5351_dt_parse'
>    ret = si5351_dt_parse(client, variant);
>    ^
> drivers/clk/clk-si5351.c:1296:12: note: declared here
>   static int si5351_dt_parse(struct i2c_client *client)
>              ^
>
> Caused by commit 9d43dc7f403d ("clk: si5351: remove variant from
> platform_data").
>
> I have used the clk tree from next-20140128 for today.  (Yes, I know that
> Linus already took this - I guess I won't have to worry about it
> tomorrow.)

I wasn't aware that Mike did not sent his PR for v3.14 yet and that
Linus will pick it up that quickly. The patch had been lying around
for a while but was obviously not well compile tested.

Anyway, my patch, my fault: Thanks for fixing it up and sorry for the
inconvenience.

Sebastian

