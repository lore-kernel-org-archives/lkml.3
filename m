Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752505AbaKJWVo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 17:21:44 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:48203 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799AbaKJWVn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 17:21:43 -0500
Message-ID: <54613A75.9080307@kernel.dk>
Date: Mon, 10 Nov 2014 15:21:41 -0700
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>, Fabian Frederick <fabf@skynet.be>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 00/10 linux-next] cdrom: sysctl export + clean-up
References: <1415650916-9975-1-git-send-email-fabf@skynet.be> <1415652861.8868.19.camel@perches.com>
In-Reply-To: <1415652861.8868.19.camel@perches.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-11-10 13:54, Joe Perches wrote:
> On Mon, 2014-11-10 at 21:21 +0100, Fabian Frederick wrote:
>> This patchset moves sysctl functions to a new file cdrom_sysctl.c
>> and tries to solve small code / coding style issues.
>
> Hey Fabian.
>
> You're doing a lot of these.
>
> Maybe you should setup a git tree somewhere
> (maybe repo.or.cz or request a kernel.org account)
> and let people pull your branches from there.

I prefer just seeing the patches, makes it easier to review in the 
mailer. And applying them from email is easy enough.

-- 
Jens Axboe

