Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755987Ab3EPHc7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 03:32:59 -0400
Received: from mail-lb0-f179.google.com ([209.85.217.179]:44787 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755901Ab3EPHcy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 03:32:54 -0400
Message-ID: <51948BA2.4030700@kernel.org>
Date: Thu, 16 May 2013 10:32:50 +0300
From: Pekka Enberg <penberg@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Sasha Levin <sasha.levin@oracle.com>
CC: torvalds@linux-foundation.org, mingo@kernel.org, peterz@infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 1/9] lockdep: Be nice about building from userspace
References: <1368674141-10796-1-git-send-email-sasha.levin@oracle.com> <1368674141-10796-2-git-send-email-sasha.levin@oracle.com>
In-Reply-To: <1368674141-10796-2-git-send-email-sasha.levin@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/16/2013 06:15 AM, Sasha Levin wrote:
> Lockdep is an awesome piece of code which detects locking issues
> which are relevant both to userspace and kernelspace. We can
> easily make lockdep work in userspace since there is really no
> kernel spacific magic going on in the code.
>
> All we need is to wrap two functions which are used by lockdep
> and are very kernel specific.
>
> Doing that will allow tools located in tools/ to easily utilize
> lockdep's code for their own use.
>
> Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
> Cc: penberg@kernel.org
> Cc: peterz@infradead.org
> Link: http://lkml.kernel.org/r/1352753446-24109-1-git-send-email-sasha.levin@oracle.com
> Signed-off-by: Ingo Molnar <mingo@kernel.org>

FWIW:

Acked-by: Pekka Enberg <penberg@kernel.org>

to the whole series.

			Pekka

