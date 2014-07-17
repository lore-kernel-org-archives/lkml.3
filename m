Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932947AbaGQNmg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 09:42:36 -0400
Received: from mail-ig0-f175.google.com ([209.85.213.175]:56950 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932179AbaGQNmf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 09:42:35 -0400
Message-ID: <53C7D2CB.7040001@linaro.org>
Date: Thu, 17 Jul 2014 08:42:35 -0500
From: Alex Elder <elder@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Petr_Ml=E1dek?= <pmladek@suse.cz>
CC: akpm@linux-foundation.org, bp@suse.de, john.stultz@linaro.org,
        jack@suse.cz, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] printk: honor LOG_PREFIX in msg_print_text()
References: <1405531620-9983-1-git-send-email-elder@linaro.org> <1405531620-9983-4-git-send-email-elder@linaro.org> <20140717094031.GQ6774@pathway.suse.cz> <53C7BF2E.4070705@linaro.org>
In-Reply-To: <53C7BF2E.4070705@linaro.org>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/17/2014 07:18 AM, Alex Elder wrote:
>> But I think that the fix is not complete. IMHO, we should finish the
>> > previous continuous line with '\n' before we print the prefix. I mean something
>> > like:
> I will re-post a new version of this patch.  When I do so
> I will look at this and--unless I find I disagree--will
> implement your suggestion.

I concur with this, but it's a different bug that changes
externally-visible behavior, so I'm going to add this as
a separate patch.

					-Alex
