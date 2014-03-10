Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754292AbaCJRRA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 13:17:00 -0400
Received: from smtp-out-237.synserver.de ([212.40.185.237]:1140 "EHLO
	smtp-out-129.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753655AbaCJRQ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 13:16:56 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 26802
Message-ID: <531DF3A2.80504@metafoo.de>
Date: Mon, 10 Mar 2014 18:17:22 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
CC: Mark Brown <broonie@kernel.org>, Lee Jones <lee.jones@linaro.org>,
        patches@opensource.wolfsonmicro.com,
        Samuel Ortiz <sameo@linux.intel.com>, linaro-kernel@lists.linaro.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: wm5102: Mark register 0x19 readable
References: <1394468977-23149-1-git-send-email-broonie@kernel.org> <20140310163811.GA16697@lee--X1> <20140310164904.GO28112@sirena.org.uk> <20140310170524.GN8570@opensource.wolfsonmicro.com>
In-Reply-To: <20140310170524.GN8570@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/10/2014 06:05 PM, Charles Keepax wrote:
> On Mon, Mar 10, 2014 at 04:49:04PM +0000, Mark Brown wrote:
>> On Mon, Mar 10, 2014 at 04:38:11PM +0000, Lee Jones wrote:
>>
>>> Can we have a #define for these please?
>>
>> It'd be nice but you'd need to ask the Wolfson guys to tell us what it's
>> called, all the information I have is the read in the driver source.
>> Meanwile we've got a bug.
>
> WRITE_SEQUENCER_CTRL_3, seems we should add that in since it is
> required for that 5102 boot stuff. Slightly confused as to how
> that ever worked without the register being readable, but guess
> it has been a while since I have fired up 5102 on mainline.
>

Presumably this change triggered it:

http://git.kernel.org/cgit/linux/kernel/git/broonie/regmap.git/commit/?h=topic/core&id=d4807ad2c4c0e17b6f00e3be9492c81de0804f40
