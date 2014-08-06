Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755309AbaHFBUE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 21:20:04 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:53305 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753523AbaHFBUC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 21:20:02 -0400
Message-ID: <53E182BF.8010406@codeaurora.org>
Date: Tue, 05 Aug 2014 18:19:59 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: frowand.list@gmail.com
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
References: <53E02C7C.4090206@gmail.com> <53E03475.6070007@codeaurora.org> <53E03CEC.3060108@gmail.com> <53E12F04.3000509@codeaurora.org> <53E16E7C.8050302@codeaurora.org> <53E17D15.3090900@gmail.com>
In-Reply-To: <53E17D15.3090900@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/05/14 17:55, Frank Rowand wrote:
> On 8/5/2014 4:53 PM, Stephen Boyd wrote:
>> On 08/05/14 12:22, Stephen Boyd wrote:
>>> I tried it and it doesn't work either. Typing lots of characters finally
>>> unjams it like you see on 1.4 hardware.
>>>
>> Can you try this? It seems to work for me on both 1.3 and 1.4 hardware
> Yes, much better getting rid of the single character mode!  Works for me
> on the dragonboard (1.4 hardware).
>
> Reviewed-by: Frank Rowand <frank.rowand@sonymobile.com>
> Tested-by: Frank Rowand <frank.rowand@sonymobile.com>
>
>

Great, I'll send an official patch with some commit text that hopefully
makes sense.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

