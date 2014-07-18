Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762026AbaGRNje (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 09:39:34 -0400
Received: from mail-ig0-f170.google.com ([209.85.213.170]:45206 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762008AbaGRNjc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 09:39:32 -0400
Message-ID: <53C92396.2080007@linaro.org>
Date: Fri, 18 Jul 2014 08:39:34 -0500
From: Alex Elder <elder@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Petr_Ml=E1dek?= <pmladek@suse.cz>
CC: akpm@linux-foundation.org, bp@suse.de, john.stultz@linaro.org,
        jack@suse.cz, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/6] printk: LOG_CONT and LOG_NEWLINE are opposites
References: <1405606151-19875-1-git-send-email-elder@linaro.org> <1405606151-19875-3-git-send-email-elder@linaro.org> <20140718105356.GY6774@pathway.suse.cz>
In-Reply-To: <20140718105356.GY6774@pathway.suse.cz>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/18/2014 05:53 AM, Petr Mládek wrote:
>> @@ -1686,9 +1690,8 @@ asmlinkage int vprintk_emit(int facility, int level,
>> >  		if (cont_add(facility, level, text, text_len))
>> >  			printed_len += text_len;
>> >  		else
>> > -			printed_len += log_store(facility, level,
>> > -						 lflags | LOG_CONT, 0,
>> > -						 dict, dictlen, text, text_len);
>> > +			printed_len += log_store(facility, level, lflags, 0,
>> > +						 NULL, 0, text, text_len);
>> >  	} else {
>> >  		bool stored = false;
>> >  
> I do not see real benefit in this change. I think that it would cause
> more confusion than help. I would suggest to remove it. Then I will
> agree with this patch :-)

Done.  I'm going to add your Reviewed-by based on this.  Please correct
me if that's not what you want.

					-Alex
