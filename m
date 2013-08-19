Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750938Ab3HSJyv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 05:54:51 -0400
Received: from mail-ob0-f172.google.com ([209.85.214.172]:62259 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750Ab3HSJyu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 05:54:50 -0400
MIME-Version: 1.0
In-Reply-To: <1376901103.26146.1.camel@joe-AO722>
References: <1376900724-9636-1-git-send-email-linus.walleij@linaro.org>
	<1376901103.26146.1.camel@joe-AO722>
Date: Mon, 19 Aug 2013 11:54:50 +0200
Message-ID: <CACRpkdZK=VFgx2-msEOiUb6t9rPs0xr_Tv9KV+Y_=Vuq53XG8w@mail.gmail.com>
Subject: Re: [PATCH v2] dmaengine: make dmatest less noisy
From: Linus Walleij <linus.walleij@linaro.org>
To: Joe Perches <joe@perches.com>
Cc: Vinod Koul <vinod.koul@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dan Williams <djbw@fb.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 19, 2013 at 10:31 AM, Joe Perches <joe@perches.com> wrote:

>> -static unsigned int threads_per_chan = 1;
>> +static unsigned int threads_per_chan = 8;
>>  module_param(threads_per_chan, uint, S_IRUGO);
>>  MODULE_PARM_DESC(threads_per_chan,
>>               "Number of threads to start per channel (default: 1)");
>
> This is unrelated and makes the MODULE_PARAM_DESC below
> it have the incorrect default.

Argh sorry, unrelated patches in the tree.

As I don't have loadable modules enabled in this system I
have to alter the compile defaults and compile the module into
the kernel :-/

Thanks for fixing the real issue the right way!

Yours,
Linus Walleij
