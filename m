Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754211Ab3FQVMy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 17:12:54 -0400
Received: from mail-la0-f52.google.com ([209.85.215.52]:45605 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753675Ab3FQVMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 17:12:53 -0400
MIME-Version: 1.0
In-Reply-To: <CAA9_cmf5y_z_XeX7N2Jno9uvUkrFK83RN1XrxTwVqZJnbdfEWA@mail.gmail.com>
References: <20130613172408.GA5561@intel.com>
	<CAA9_cmf5y_z_XeX7N2Jno9uvUkrFK83RN1XrxTwVqZJnbdfEWA@mail.gmail.com>
Date: Mon, 17 Jun 2013 14:12:51 -0700
X-Google-Sender-Auth: JtQ1LdbuenQxhs8qy2Pjs5DBuvY
Message-ID: <CAA9_cmdr7gjrbBN8tV9LAH2JXzFiegLzLPOAHVg-9sP8p9HRqg@mail.gmail.com>
Subject: Re: [PATCH] dmatest: masking tests for channel capabilities
From: Dan Williams <djbw@fb.com>
To: Jubin Mehta <jubin.mehta@intel.com>
Cc: Vinod Koul <vinod.koul@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Dave Jiang <dave.jiang@intel.com>, Jon Mason <jon.mason@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ apologies for the resend, gmail defaulted to html ]

On Mon, Jun 17, 2013 at 2:10 PM, Dan Williams <djbw@fb.com> wrote:
>> +Example to perform only MEMCPY and PQ mode tests (0x01 | 0x04 = 0x05):
>> +
>> +        % modprobe dmatest
>> +        % echo dma0chan0 > /sys/kernel/debug/dmatest/channel
>> +        % echo 5  > /sys/kernel/debug/dmatest/cap_mask
>> +        % echo 1 > /sys/kernel/debug/dmatest/iterations
>> +        % echo 1 > /sys/kernel/debug/dmatest/run
>
>
> Hmmm, I should have paid more attention when the debugfs support was
> initially proposed for dmatest.  As it is I see duplication and
> configuration parameters getting out of sync with their module parameter
> equivalents versus just having all configuration go through module
> parameters.  module_param_call() can be used for the more complex options.
> Debugfs at this point looks like overkill for what amounts to some simple
> configuration variables and a result line.
>
> --
> Dan
>
