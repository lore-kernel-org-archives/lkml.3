Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756589AbaGIPO6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 11:14:58 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:51689 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756122AbaGIPO5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 11:14:57 -0400
Message-ID: <53BD5C6E.3030805@linaro.org>
Date: Wed, 09 Jul 2014 10:14:54 -0500
From: Alex Elder <alex.elder@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: Alex Elder <elder@linaro.org>, akpm@linux-foundation.org,
        ak@linux.intel.com, bp@suse.de, jack@suse.cz, john.stultz@linaro.org,
        pmladek@suse.cz, rostedt@goodmis.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] printk: rename DEFAULT_MESSAGE_LOGLEVEL
References: <1404911056-29064-1-git-send-email-elder@linaro.org> <1404911056-29064-2-git-send-email-elder@linaro.org> <20140709150043.GB5254@pd.tnic> <53BD5B64.3010703@linaro.org> <20140709151351.GD5254@pd.tnic>
In-Reply-To: <20140709151351.GD5254@pd.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/09/2014 10:13 AM, Borislav Petkov wrote:
> On Wed, Jul 09, 2014 at 10:10:28AM -0500, Alex Elder wrote:
>> Yes I realized this just sort of moved that sort of problem
>> to a different place.  The change was responding to the
>> inconsistency in naming in "printk.c".  I can control the
>> effects of that, but I can't predict who might be using
>> various config options, so I avoided doing that rename.
>>
>> Was I being overly cautious on the config option name?
>> I could fix that too and have consistency everywhere.
>
> You mean turn it into CONFIG_MESSAGE_LOGLEVEL_DEFAULT?

OK, I'll repost a little later with that change included.
Thanks.

					-Alex
