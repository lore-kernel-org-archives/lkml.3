Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752380AbaHRXp0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 19:45:26 -0400
Received: from mail-qa0-f44.google.com ([209.85.216.44]:38008 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751245AbaHRXpY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 19:45:24 -0400
MIME-Version: 1.0
In-Reply-To: <20140818173552.GA2126@drone.musicnaut.iki.fi>
References: <alpine.SOC.1.00.1407310101550.2065@math.ut.ee>
 <20140730.150722.861254999466992321.davem@davemloft.net> <alpine.SOC.1.00.1408131327250.18696@math.ut.ee>
 <20140813.124611.767426770013677.davem@davemloft.net> <alpine.SOC.1.00.1408151534480.27263@math.ut.ee>
 <alpine.SOC.1.00.1408181528270.2922@math.ut.ee> <20140818173552.GA2126@drone.musicnaut.iki.fi>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Tue, 19 Aug 2014 09:45:03 +1000
Message-ID: <CAGRGNgUq0-1rDtRJfFQ1ARvPXk6aT+f99-EGCN1vBpd35q2qyg@mail.gmail.com>
Subject: Re: sparc64 WARNING: at mm/mmap.c:2757 exit_mmap+0x13c/0x160()
To: Aaro Koskinen <aaro.koskinen@iki.fi>
Cc: Meelis Roos <mroos@linux.ee>, David Miller <davem@davemloft.net>,
        sparclinux <sparclinux@vger.kernel.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>, hughd@google.com,
        cat.schulze@alice-dsl.net
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

On Tue, Aug 19, 2014 at 3:35 AM, Aaro Koskinen <aaro.koskinen@iki.fi> wrote:
> Hi,
>
> On Mon, Aug 18, 2014 at 03:30:16PM +0300, Meelis Roos wrote:
>> > U1, U2, U5, U10, E220R, E420R later or some other day, whenever I get
>> > to them physically.
>>
>> Ultra 5 is bad news with 3.17-rc1: it almost boots up, then aftyer
>> strarting postfix and ntpd, gets RED state exception and contiunes
>> looping with it (before it gor RED state only after prom reboot).
>
> My Ultra 5 is fine with 3.17-rc1 (I'm writing this mail from it),
> also Ultra 10 seems to be OK based on quick test.

Stupid question: aren't the Ultra 5 and Ultra 10 essentially the same hardware?

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
