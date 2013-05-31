Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757138Ab3EaQ06 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 12:26:58 -0400
Received: from mail-qc0-f181.google.com ([209.85.216.181]:60195 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755111Ab3EaQ0v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 12:26:51 -0400
Message-ID: <51A8CF48.2080801@gmail.com>
Date: Fri, 31 May 2013 12:26:48 -0400
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Olivier Langlois <olivier@trillion01.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        kosaki.motohiro@gmail.com
Subject: Re: [PATCH v5 0/8] posix timers fixlet
References: <1369604149-13016-1-git-send-email-kosaki.motohiro@gmail.com>
In-Reply-To: <1369604149-13016-1-git-send-email-kosaki.motohiro@gmail.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(5/26/13 5:35 PM), kosaki.motohiro@gmail.com wrote:
> From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> 
> Glibc's posix timer testcase found a lot of bugs in posix timer code.
> This series, hopefully, fixes all of them. All patches are independent
> each other logically.
> 
> Changes from v4
>   - [1/8] comments colarification, fix account_group_{user_system}_time too.
>   - [8/8] added CPUCLOCK_VIRT and CPUCLOCK_PROF timer initialization fix

Ping?

Thomas, Could you pick them up into your tree?

