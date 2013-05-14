Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757849Ab3ENOTo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 10:19:44 -0400
Received: from mail-ea0-f178.google.com ([209.85.215.178]:55275 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757443Ab3ENOTm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 10:19:42 -0400
Message-ID: <51924819.3060907@suse.cz>
Date: Tue, 14 May 2013 16:20:09 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:19.0) Gecko/20130124 Thunderbird/19.0
MIME-Version: 1.0
To: Richard Cochran <richardcochran@gmail.com>,
        Jiri Slaby <jirislaby@gmail.com>
CC: linux-kernel@vger.kernel.org, Jeff Mahoney <jeffm@suse.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH 15/15] ptp: PTP_1588_CLOCK_PCH depends on x86
References: <1367936303-13386-1-git-send-email-jslaby@suse.cz> <1367936303-13386-15-git-send-email-jslaby@suse.cz> <20130507192938.GA3599@netboy>
In-Reply-To: <20130507192938.GA3599@netboy>
X-Enigmail-Version: 1.6a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/07/2013 09:29 PM, Richard Cochran wrote:
> On Tue, May 07, 2013 at 04:18:23PM +0200, Jiri Slaby wrote:
>> From: Jeff Mahoney <jeffm@suse.com>
>>
>> The PCH EG20T is only compatible with Intel Atom processors so it
>> should depend on x86.
> 
> This patch has been submitted before,
> 
>    https://patchwork.kernel.org/patch/2069071/
> 
> and at that time the reaction was that it is good to have drivers
> cross-compiled, if only for code quality reasons.

Hmm, then it depends whether the kernel is for users or for developers.
I, as a user, do not really want to compile drivers with allmodconfig
which I have no way to load/use.

And allmodconfig is basically what we, users (SUSE distributors in this
case) do. So having this driver being built makes our life harder (in
the meaning we have to have specific rules about disabling unwanted
drivers from configs).

And, developers should have a testbed where they build 32bit configs.
And we actually have that for -next AFAIU.

thanks,
-- 
js
suse labs
