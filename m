Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758166AbaGAP6L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 11:58:11 -0400
Received: from mail-oa0-f54.google.com ([209.85.219.54]:49516 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755467AbaGAP6J convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 11:58:09 -0400
MIME-Version: 1.0
In-Reply-To: <53B2D7A6.1040901@6wind.com>
References: <1403687411-27059-1-git-send-email-nicolas.dichtel@6wind.com> <53B2D7A6.1040901@6wind.com>
From: Vincent Guittot <vincent.guittot@linaro.org>
Date: Tue, 1 Jul 2014 17:57:48 +0200
Message-ID: <CAKfTPtAz99C=XC-YFuxJN2Rw+vDYTKLOGEFVARDfkW01ycuMFA@mail.gmail.com>
Subject: Re: [PATCH] sched: fix warnings in linux/sched.h
To: nicolas.dichtel@6wind.com
Cc: "mingo@redhat.com" <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1 July 2014 17:45, Nicolas Dichtel <nicolas.dichtel@6wind.com> wrote:
> Le 25/06/2014 11:10, Nicolas Dichtel a écrit :
>
>> Seen when compiling with W=1.
>>
>> Warnings were:
>> In file included from arch/x86/kernel/asm-offsets.c:9:0:
>> include/linux/sched.h:875:25: warning: type qualifiers ignored on function
>> return type [-Wignored-qualifiers]
>> include/linux/sched.h:882:25: warning: type qualifiers ignored on function
>> return type [-Wignored-qualifiers]
>> include/linux/sched.h:1002:21: warning: type qualifiers ignored on
>> function return type [-Wignored-qualifiers]
>>
>> It was introduced by commit 143e1e28cb40 ("sched: Rework sched_domain
>> topology
>> definition").
>>
>> CC: Vincent Guittot <vincent.guittot@linaro.org>
>> Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
>
> Any comment or problem about this patch?

This patch looks quit similar to https://lkml.org/lkml/2014/6/24/956

Vincent
