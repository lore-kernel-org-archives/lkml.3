Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758974Ab3FCTvo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 15:51:44 -0400
Received: from mail-bk0-f54.google.com ([209.85.214.54]:41491 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751903Ab3FCTvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 15:51:42 -0400
Message-ID: <51ACF3C9.2090701@message-id.googlemail.com>
Date: Mon, 03 Jun 2013 21:51:37 +0200
From: Stefan Seyfried <stefan.seyfried@googlemail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Borislav Petkov <bp@alien8.de>,
        Li Zhong <zhong@linux.vnet.ibm.com>, Mike Galbraith <efault@gmx.de>
Subject: Re: [PATCH 2/8] vtime: Use consistent clocks among nohz accounting
References: <1369065716-22801-1-git-send-email-fweisbec@gmail.com> <1369065716-22801-3-git-send-email-fweisbec@gmail.com> <51AC6625.3080000@message-id.invalid.com> <20130603194806.GC31107@somewhere>
In-Reply-To: <20130603194806.GC31107@somewhere>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 03.06.2013 21:48, schrieb Frederic Weisbecker:
> On Mon, Jun 03, 2013 at 11:47:17AM +0200, Stefan Seyfried wrote:
>> FWIW:
>> Tested-by: Stefan Seyfried <seife+dev@b1-systems.com>
>>
>> This patch fixes the 0% CPU issue on openSUSE Factory kernels for me.
> 
> Thanks! The patch has been committed already so I can't add your Tested-by:
> but feedbacks on testing are always appeciated.

But it did not end up in Linus' tree yet. That would be more important
for me than the credits in the commit message :-)

Thanks,

	Stefan
-- 
Stefan Seyfried
Linux Consultant & Developer -- GPG Key: 0x731B665B

B1 Systems GmbH
Osterfeldstraße 7 / 85088 Vohburg / http://www.b1-systems.de
GF: Ralph Dehner / Unternehmenssitz: Vohburg / AG: Ingolstadt,HRB 3537
