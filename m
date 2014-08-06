Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755233AbaHFAz6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 20:55:58 -0400
Received: from mail-la0-f43.google.com ([209.85.215.43]:40274 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752073AbaHFAz4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 20:55:56 -0400
Message-ID: <53E17D15.3090900@gmail.com>
Date: Tue, 05 Aug 2014 17:55:49 -0700
From: Frank Rowand <frowand.list@gmail.com>
Reply-To: frowand.list@gmail.com
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Stephen Boyd <sboyd@codeaurora.org>
CC: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        linux-serial@vger.kernel.org,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Jason Wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net
Subject: Re: [request for help] tty: serial: kgdb: fix msm_serial for kgdb
References: <53E02C7C.4090206@gmail.com> <53E03475.6070007@codeaurora.org> <53E03CEC.3060108@gmail.com> <53E12F04.3000509@codeaurora.org> <53E16E7C.8050302@codeaurora.org>
In-Reply-To: <53E16E7C.8050302@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/5/2014 4:53 PM, Stephen Boyd wrote:
> On 08/05/14 12:22, Stephen Boyd wrote:
>>
>> I tried it and it doesn't work either. Typing lots of characters finally
>> unjams it like you see on 1.4 hardware.
>>
> 
> Can you try this? It seems to work for me on both 1.3 and 1.4 hardware

Yes, much better getting rid of the single character mode!  Works for me
on the dragonboard (1.4 hardware).

Reviewed-by: Frank Rowand <frank.rowand@sonymobile.com>
Tested-by: Frank Rowand <frank.rowand@sonymobile.com>

Thanks for figuring this out.

I'll send a patch to handle sysrq after I see this patch upstream.

-Frank
