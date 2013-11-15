Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752979Ab3KOWfZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 17:35:25 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:41077 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752165Ab3KOWfS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 17:35:18 -0500
Message-ID: <5286A1A4.2020905@linaro.org>
Date: Fri, 15 Nov 2013 14:35:16 -0800
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: Amit Pundir <amit.pundir@linaro.org>,
        =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Android Kernel Team <kernel-team@android.com>
Subject: Re: [PATCH v3] epoll: drop EPOLLWAKEUP if PM_SLEEP is disabled
References: <1384500391-20513-1-git-send-email-amit.pundir@linaro.org> <4921878.yXb9shUEsy@vostro.rjw.lan> <52866D8D.6070801@linaro.org> <2338693.sZIlYGM98f@vostro.rjw.lan>
In-Reply-To: <2338693.sZIlYGM98f@vostro.rjw.lan>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/15/2013 02:40 PM, Rafael J. Wysocki wrote:
> On Friday, November 15, 2013 10:53:01 AM John Stultz wrote:
>> On 11/15/2013 07:10 AM, Rafael J. Wysocki wrote:
>>> On Friday, November 15, 2013 12:56:31 PM Amit Pundir wrote:
>>>> Drop EPOLLWAKEUP from epoll events mask if CONFIG_PM_SLEEP is disabled.
>>>>
>>>> Signed-off-by: Amit Pundir <amit.pundir@linaro.org>
>>> Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>>>
>>> Or am I supposed to take care of this?
>> I would assume it would be you, but maybe Al would prefer to take it?
>>
>> Also, should this be also marked for stable?
> Well, do people see it in production?

I guess its unlikely, but it seems like its possible. I guess I've got
no objection to holding off unless someone else hits this.

thanks
-john

