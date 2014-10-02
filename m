Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754605AbaJBQOC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 12:14:02 -0400
Received: from mail-oi0-f43.google.com ([209.85.218.43]:62506 "EHLO
	mail-oi0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754535AbaJBQOA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 12:14:00 -0400
MIME-Version: 1.0
In-Reply-To: <CAMo8BfKvvGg7QAH1GqGH98Qsw9v8=Ok0cV+uxKL5RP97p--KpQ@mail.gmail.com>
References: <1412264685-3368-1-git-send-email-paulmcquad@gmail.com>
	<CAMo8BfKvvGg7QAH1GqGH98Qsw9v8=Ok0cV+uxKL5RP97p--KpQ@mail.gmail.com>
Date: Thu, 2 Oct 2014 20:13:59 +0400
Message-ID: <CAMo8BfLkZvH9zG+O7cTJmwAs5WCTRfV6VmN8p=apUuRZut5i-Q@mail.gmail.com>
Subject: Re: [PATCH] mm: highmem remove 3 errors
From: Max Filippov <jcmvbkbc@gmail.com>
To: Paul McQuade <paulmcquad@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 2, 2014 at 7:54 PM, Max Filippov <jcmvbkbc@gmail.com> wrote:
> On Thu, Oct 2, 2014 at 7:44 PM, Paul McQuade <paulmcquad@gmail.com> wrote:
>> -       return (void*) vaddr;
>> +       return (void *) vaddr;
>
> checkpatch suggests that
> CHECK: No space is necessary after a cast

Sorry, wasn't clear enough. 'After a cast' means between ')' and 'vaddr' in the
above case. Space insertion between 'void' and '*' is correct.

-- 
Thanks.
-- Max
