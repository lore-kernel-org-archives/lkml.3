Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758684Ab3D3Dia (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 23:38:30 -0400
Received: from mail-qa0-f43.google.com ([209.85.216.43]:41626 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757716Ab3D3Di3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 23:38:29 -0400
Message-ID: <517F3CB1.6010705@gmail.com>
Date: Mon, 29 Apr 2013 23:38:25 -0400
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Olivier Langlois <olivier@trillion01.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        David Miller <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        kosaki.motohiro@gmail.com
Subject: Re: [PATCH 04/10] posix-cpu-timers: don't account cpu timer after
 stopped thread runtime accounting
References: <1367291838-5490-1-git-send-email-kosaki.motohiro@gmail.com> <1367291838-5490-5-git-send-email-kosaki.motohiro@gmail.com>
In-Reply-To: <1367291838-5490-5-git-send-email-kosaki.motohiro@gmail.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hm. I'm not sure why this path series start [patch 4/10]. maybe I need to review my script again.
anyway, patch 1-3 don't exist. sorry for confusing.

