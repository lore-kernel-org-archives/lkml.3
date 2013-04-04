Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763484Ab3DDQ4Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 12:56:16 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:62717 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763462Ab3DDQ4O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 12:56:14 -0400
MIME-Version: 1.0
In-Reply-To: <20130404141604.GD16459@redhat.com>
References: <1365035906-3208-1-git-send-email-yinghai@kernel.org>
	<1365035906-3208-4-git-send-email-yinghai@kernel.org>
	<20130404141604.GD16459@redhat.com>
Date: Thu, 4 Apr 2013 09:56:14 -0700
X-Google-Sender-Auth: aCp6j--oWkIJLqJVdF0xeHbBh6c
Message-ID: <CAE9FiQVn1C7Zy94=oQLpHnGp9WGevGB2SKCM2zMjHumc1Secmw@mail.gmail.com>
Subject: Re: [PATCH v2 2/4] x86, kdump: Retore crashkernel= to allocate low
From: Yinghai Lu <yinghai@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, WANG Chao <chaowang@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 4, 2013 at 7:16 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
>> +     crashkernel_high=size[KMG]
>> +                     [KNL, x86_64] range could be above 4G. Allow kernel
>> +                     to allocate physical memory region from top, so could
>> +                     be above 4G if system have more than 4G ram installed.
>
> Also specify "otherwise memory will be allocated below 4G, if available".
>
...
>> @@ -614,6 +619,8 @@ bytes respectively. Such letter suffixes
>>                       0: to disable low allocation on systems that do not
>>                       need swiotlb, that will save 72M low ram in first
>>                       kernel.
>> +                     It will be ignored when crashkernel_high=X is not used
>> +                     or return from that is below 4G.
>
> Replace "return from that" with "memory reserved".

updated.

Thanks

Yinghai
