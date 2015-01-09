Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932757AbbAILqr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 06:46:47 -0500
Received: from forward4m.mail.yandex.net ([37.140.138.4]:55110 "EHLO
	forward4m.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755109AbbAILqq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 06:46:46 -0500
From: Kirill Tkhai <tkhai@yandex.ru>
To: Luca Abeni <luca.abeni@unitn.it>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Juri Lelli <juri.lelli@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <54AFB839.8090904@unitn.it>
References: <20141230002738.6c12db31@utopia>		 <2629881420411885@web9m.yandex.ru> <54AAABFB.3060109@unitn.it>		 <1420499241.3361.14.camel@yandex.ru> <20150107080155.1d42d123@luca-1225C>	 <1420633741.12772.10.camel@yandex.ru> <54AD2A56.70307@unitn.it> <1420635879.14676.12.camel@yandex.ru> <54AFB839.8090904@unitn.it>
Subject: Re: Another SCHED_DEADLINE bug (with bisection and possible fix)
MIME-Version: 1.0
Message-Id: <620901420804002@web3m.yandex.ru>
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Fri, 09 Jan 2015 14:46:42 +0300
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=koi8-r
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


09.01.2015, 14:15, "Luca Abeni" <luca.abeni@unitn.it>:
> Hi Kirill,
>
> On 01/07/2015 02:04 PM, Kirill Tkhai wrote:
> [...]
>>>> šIf in the future we allow non-privileged users to increase deadline,
>>>> šwe will reflect that in __setparam_dl() too.
>>> šOk.
>> šDoes my patch help you? It helps me, but anyway I need your confirmation.
>
> Sorry about the delay... Anyway, I finally had time to test your patch, and
> as expected it fixes the hang I was seeing.

Thanks for the testing.

Kirill
