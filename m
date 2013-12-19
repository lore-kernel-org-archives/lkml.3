Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750954Ab3LSRYC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 12:24:02 -0500
Received: from mail-ie0-f175.google.com ([209.85.223.175]:64743 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751677Ab3LSRYA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 12:24:00 -0500
Message-ID: <52B329F2.9020403@gmail.com>
Date: Thu, 19 Dec 2013 09:16:34 -0800
From: David Daney <ddaney.cavm@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: Tejun Heo <tj@kernel.org>, akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 18/40] percpu: Add preemption checks to __this_cpu ops
References: <20131219155015.443763038@linux.com> <20131219155032.657725367@linux.com>
In-Reply-To: <20131219155032.657725367@linux.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/19/2013 07:50 AM, Christoph Lameter wrote:
> [Patch depends on another patch in this series that introduces raw_cpu_ops]
>
> We define a check function in order to avoid trouble with the
> include files. Then the higher level __this_cpu macros are
> modified to invoke the preemption check.
>
> Acked-by: Ingo Molnar<mingo@kernel.org>
> Signed-off-by: Christoph Lameter<cl@linux.com>
>


I get:


Applying: percpu: Add preemption checks to __this_cpu ops
/home/ddaney/base/octeon/linux-base/trunk/kernel/linux-master/.git/rebase-apply/patch:139: 
new blank line at EOF.
+
warning: 1 line adds whitespace errors.


David
