Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751875AbaHTITv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 04:19:51 -0400
Received: from srv2.trombetti.net ([65.254.53.252]:2238 "EHLO server"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751292AbaHTITt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 04:19:49 -0400
Message-ID: <53F45A29.6060604@shiftmail.org>
Date: Wed, 20 Aug 2014 10:19:53 +0200
From: Ethan Wilson <ethan.wilson@shiftmail.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: (trying again) how to get kernel stack trace if process not blocked?
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello list,
I know cat /proc/pid/stack shows the kernel call stack of a process, and 
this is so good, but it will show just 0xffffffffffffffff if the process 
is running in kernel space and not blocked (sleeping).

It would be *very* useful to get the kernel stack trace for a running 
process, even if imprecise, or at least knowing the name of the kernel 
function executing now (top of the stack). Why is it not doable?

I tried to disable CONFIG_SCHED_OMIT_FRAME_POINTER but it didn't allow 
to print the stack from /proc/pid/stack anyway. What is the benefit of 
disabling such kernel option (i.e. having the frame pointer)?

I guessed that maybe with EIP from /proc/pid/stat it is possible to do 
something like that but I can't find much information on how to do that.

Thanks for any information
EW
