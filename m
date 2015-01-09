Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932721AbbAILPM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 06:15:12 -0500
Received: from mail3.unitn.it ([193.205.206.24]:50711 "EHLO mail3.unitn.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932492AbbAILPK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 06:15:10 -0500
Message-ID: <54AFB839.8090904@unitn.it>
Date: Fri, 09 Jan 2015 12:15:05 +0100
From: Luca Abeni <luca.abeni@unitn.it>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: tkhai@yandex.ru
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Juri Lelli <juri.lelli@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Another SCHED_DEADLINE bug (with bisection and possible fix)
References: <20141230002738.6c12db31@utopia>		 <2629881420411885@web9m.yandex.ru> <54AAABFB.3060109@unitn.it>		 <1420499241.3361.14.camel@yandex.ru> <20150107080155.1d42d123@luca-1225C>	 <1420633741.12772.10.camel@yandex.ru> <54AD2A56.70307@unitn.it> <1420635879.14676.12.camel@yandex.ru>
In-Reply-To: <1420635879.14676.12.camel@yandex.ru>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kirill,

On 01/07/2015 02:04 PM, Kirill Tkhai wrote:
[...]
>>> If in the future we allow non-privileged users to increase deadline,
>>> we will reflect that in __setparam_dl() too.
>> Ok.
>
> Does my patch help you? It helps me, but anyway I need your confirmation.
Sorry about the delay... Anyway, I finally had time to test your patch, and
as expected it fixes the hang I was seeing.



				Thanks,
					Luca

