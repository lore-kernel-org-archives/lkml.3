Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756195Ab3EHAWF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 20:22:05 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:38692 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755110Ab3EHAWD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 20:22:03 -0400
Message-ID: <51899AA7.4030106@gmail.com>
Date: Tue, 07 May 2013 17:21:59 -0700
From: Dirk Brandewie <dirk.brandewie@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: dirk.brandewie@gmail.com, linux-kernel@vger.kernel.org,
        cpufreq@vger.kernel.org, Linux PM list <linux-pm@vger.kernel.org>
Subject: Re: [PATCH 0/6] Intel pstate driver update
References: <1367940030-19311-1-git-send-email-dirk.j.brandewie@gmail.com> <4686510.A1KmKYg1tS@vostro.rjw.lan>
In-Reply-To: <4686510.A1KmKYg1tS@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/07/2013 05:07 PM, Rafael J. Wysocki wrote:
> On Tuesday, May 07, 2013 08:20:24 AM dirk.brandewie@gmail.com wrote:
>> From: dirk <dirk.brandewie@gmail.com>
>>
> All queued up for a post-3.10-rc1 push as 3.10 material, but I have a couple
> of comments.
>
> First, the patches didn't apply for me cleanly.  I needed to fix up one of
> them manually to make it apply and patch [5/6] didn't appear to be necessary
> at all (it made changes that had been made previously).  Please check the
> bleeding-edge branch of my tree to see if the code is what you wanted and
> let me know (either way).
>
Srinivas's commit d1b6848 collided with my 5/6 patch. my patches were based off 
of v3.9. Which branch of yours should I base my submissions on?

linux-pm/bleeding-edge is correct.

> Second, can you please CC your cpufreq submissions to linux-pm@vger.kernel.org?
> That will allow me to use Patchwork for managing them, which is much more
> convenient than plain email.
>

No problem

--Dirk

> Thanks,
> Rafael
>
>

