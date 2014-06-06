Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752127AbaFFSD0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 14:03:26 -0400
Received: from mail-la0-f54.google.com ([209.85.215.54]:54825 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751279AbaFFSDY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 14:03:24 -0400
MIME-Version: 1.0
In-Reply-To: <20140606175655.GX13930@laptop.programming.kicks-ass.net>
References: <5390D7E1.7060606@gatech.edu> <5391FFFD.1060901@gatech.edu> <20140606175655.GX13930@laptop.programming.kicks-ass.net>
From: Pranith Kumar <pranith@gatech.edu>
Date: Fri, 6 Jun 2014 14:02:52 -0400
X-Google-Sender-Auth: dRqirr9JGuZIsIhKNpiBd_MW-G8
Message-ID: <CAJhHMCBHTUoNKVN=ooh5jL+oESNJCyQQg-rUNzDJs5t0wKFEow@mail.gmail.com>
Subject: Re: [RFC PATCH 1/1] cleanup: use bool as return type for rwsem_is_locked
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, tim.c.chen@linux.intel.com,
        davidlohr@hp.com, mingo@redhat.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 6, 2014 at 1:56 PM, Peter Zijlstra <peterz@infradead.org> wrote:
>> Fixed and checked the assembly. It saves us 2 bytes of code, not much. I am not sure if that is worth it :(
>
> still 2 bytes, so sure.
>
> Which gcc did you use and what arch did you build? That might be useful
> info for the changelog.

I am using gcc (Ubuntu/Linaro 4.7.3-2ubuntu1~12.04) 4.7.3. I tested
this using ARCH=um with a Pentium processor to turn on
CONFIG_RWSEM_GENERIC_SPINLOCK.

-- 
Pranith
