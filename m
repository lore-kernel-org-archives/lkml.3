Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752642Ab3KOPRE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 10:17:04 -0500
Received: from mail-qe0-f41.google.com ([209.85.128.41]:51976 "EHLO
	mail-qe0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752473Ab3KOPQ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 10:16:56 -0500
Message-ID: <52863AE2.9010005@linaro.org>
Date: Fri, 15 Nov 2013 10:16:50 -0500
From: David Long <dave.long@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
CC: "Jon Medhurst (Tixy)" <tixy@linaro.org>,
        linux-arm-kernel@lists.infradead.org, Rabin Vincent <rabin@rab.in>,
        Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH v2 10/13] kprobes: Remove uneeded kernel dependency on
 struct arch_specific_insn
References: <1381871068-27660-1-git-send-email-dave.long@linaro.org>   <1381871068-27660-11-git-send-email-dave.long@linaro.org>  <1384362833.3392.42.camel@linaro1.home> <52842F2C.1030701@hitachi.com> <1384438551.3388.78.camel@linaro1.home> <52853389.7080105@linaro.org> <5285F62D.5010407@hitachi.com>
In-Reply-To: <5285F62D.5010407@hitachi.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/15/13 05:23, Masami Hiramatsu wrote:
> I see. I'd just like to suggest you that your improvement on ONE arch
> can also be useful idea for the other archs. In that case, there would be
> better, more efficient way to do that.
> Since we are on the same (or, next) track, we can learn many things each other. :)
>
> Thank you,
>

I'd like to suggest there is still no reason not to take the current 
work (with suggested changes), which interested parties can then further 
adapt for supporting other/multiple architectures.  There is virtually 
no new architecture-specific code that would have to be redone later. 
Additionally, it's not clear to me how useful instruction interpretation 
is to any other architecture.  We are doing this only because 32-bit ARM 
does not support single-stepping.

-dl

