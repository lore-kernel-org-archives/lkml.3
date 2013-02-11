Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757931Ab3BKQgz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 11:36:55 -0500
Received: from relay1.sgi.com ([192.48.179.29]:56637 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757817Ab3BKQgy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 11:36:54 -0500
Message-ID: <51191E23.9080500@sgi.com>
Date: Mon, 11 Feb 2013 08:36:51 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Dimitri Sivanich <sivanich@sgi.com>
Subject: Re: [PATCH 6/7] x86, UV: UV3 Check current gru hub support.
References: <20130208184305.132404589@gulag1.americas.sgi.com> <20130208184306.212373913@gulag1.americas.sgi.com> <20130211094032.GD23932@gmail.com>
In-Reply-To: <20130211094032.GD23932@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 2/11/2013 1:40 AM, Ingo Molnar wrote:
>
> * Mike Travis <travis@sgi.com> wrote:
>
>> This patch checks current hub support to avoid panicing the
>> system until all the GRU changes for UV3+ are in place.
>>
>> Signed-off-by: Dimitri Sivanich <sivanich@sgi.com>
>> Signed-off-by: Mike Travis <travis@sgi.com>

It was Dimitri's patch, and I put the Author: right after
the Subject: line but since it was sent from my quilt mail
command, it was changed.  It was my mistake with the second
s-o-b: line.
>
> That's a weird signoff sequence. It should either also include a
> From: Dimitri tag at the front, or the Signed-off-by should be
> Acked-by.
>
> Please also use consistent titles in your patches, standardizing
> on this pattern would be nice:
>
>     x86/UV/UV3: Check current gru hub support
>
> while UV patches affecting all UV models would come with a
> 'x86/UV:' title or so.

I can do this.

Thanks,
Mike

>
> Thanks,
>
> 	Ingo
>
