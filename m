Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933000AbaGXQPx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 12:15:53 -0400
Received: from unicorn.mansr.com ([81.2.72.234]:36013 "EHLO unicorn.mansr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759002AbaGXQPw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 12:15:52 -0400
From: =?iso-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Nicholas Krause <xerofoify@gmail.com>, gregkh@linuxfoundation.org,
        john.stultz@linaro.org, paul.gortmaker@windriver.com,
        gang.chen.5i5j@gmail.com, yongjun_wei@trendmicro.com.cn,
        dan.carpenter@oracle.com, tomas.winkler@intel.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: Change kzalloc to kcalloc
References: <1406156581-6052-1-git-send-email-xerofoify@gmail.com>
	<20140724144725.GA32669@home.goodmis.org>
	<20140724105132.3cf221c2@gandalf.local.home>
Date: Thu, 24 Jul 2014 17:15:47 +0100
In-Reply-To: <20140724105132.3cf221c2@gandalf.local.home> (Steven Rostedt's
	message of "Thu, 24 Jul 2014 10:51:32 -0400")
Message-ID: <yw1x38dqag24.fsf@unicorn.mansr.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt <rostedt@goodmis.org> writes:

> On Thu, 24 Jul 2014 10:47:25 -0400
> Steven Rostedt <rostedt@goodmis.org> wrote:
>
>> The three parameters are the number of elements, the size of each individual
>> element, and then finally the flags used on how to allocate that memory.
>> I have to say, you did get the flags part correct.
>> 
>> Now lets look at what you did. For the size you had:
>
> That should have read "For the count you had:"
>
> Oh well, you get my point anyway.

I have some doubts about the last bit.

-- 
Måns Rullgård
mans@mansr.com
