Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755770AbaCNTbK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 15:31:10 -0400
Received: from mail-qc0-f179.google.com ([209.85.216.179]:41434 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754661AbaCNTbI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 15:31:08 -0400
Message-ID: <532358F7.4090705@gmail.com>
Date: Fri, 14 Mar 2014 15:31:03 -0400
From: Sasha Levin <levinsasha928@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Jason Low <jason.low2@hp.com>, Fengguang Wu <fengguang.wu@intel.com>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [locking/mutexes] WARNING: CPU: 1 PID: 77 at kernel/locking/mutex-debug.c:82
 debug_mutex_unlock()
References: <20140313012744.GA7714@localhost> <1394675197.2107.3.camel@j-VirtualBox>
In-Reply-To: <1394675197.2107.3.camel@j-VirtualBox>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/12/2014 09:46 PM, Jason Low wrote:
> Hi Fengguang,
>
> Can you try out this patch?
>
> https://lkml.org/lkml/2014/3/12/243

Hi Jason,

It fixes the problem for me.


Thanks,
Sasha

