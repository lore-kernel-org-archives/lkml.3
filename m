Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752675AbaAPOal (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 09:30:41 -0500
Received: from mail-wi0-f169.google.com ([209.85.212.169]:58932 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751123AbaAPOah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 09:30:37 -0500
Message-ID: <52D7ED0A.2030502@linaro.org>
Date: Thu, 16 Jan 2014 15:30:34 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: raistlin@linux.it, juri.lelli@gmail.com, Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] [ tip/sched/core ] System unresponsive after booting
References: <52D64676.4040000@linaro.org> <20140115120418.GD31570@twins.programming.kicks-ass.net> <52D7E343.40909@linaro.org> <20140116141743.GT31570@twins.programming.kicks-ass.net> <52D7EAA4.2080208@linaro.org> <20140116142546.GU31570@twins.programming.kicks-ass.net>
In-Reply-To: <20140116142546.GU31570@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/16/2014 03:25 PM, Peter Zijlstra wrote:
> On Thu, Jan 16, 2014 at 03:20:20PM +0100, Daniel Lezcano wrote:
>> Already tested. The last commits do not change the issue described above.
>
> Bummer, ok, what version of Ubuntu/rsyslogd are you using? I have a
> laptop around that should have some recent ubuntu on it, let me go find
> it.

It is a Ubuntu 12.04 and rsyslog 5.8.6-1ubuntu8.4



-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

