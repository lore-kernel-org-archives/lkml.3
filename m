Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753323Ab3JYKsh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 06:48:37 -0400
Received: from mail-vb0-f45.google.com ([209.85.212.45]:52887 "EHLO
	mail-vb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752926Ab3JYKsf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 06:48:35 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1310251221310.5266@ionos.tec.linutronix.de>
References: <525BD08C.2080101@t-online.de>
	<CA+55aFwN++wO=rTFaH7m6YYQX+Fv3qDt6Hxs7UnPUJpFsrwSkA@mail.gmail.com>
	<CA+55aFy7TpvkVuPEOJ7Qqirwap1gXoD1_MrYLhgPAYuVpN8u=w@mail.gmail.com>
	<alpine.DEB.2.02.1310251221310.5266@ionos.tec.linutronix.de>
Date: Fri, 25 Oct 2013 11:48:35 +0100
X-Google-Sender-Auth: 4rnqZ-jUAE8ss-Huq9jnxBYlkA0
Message-ID: <CA+55aFxw1Hm4QVeEigkByP5RppSL30oHnLoR16C=henf-a=uFQ@mail.gmail.com>
Subject: Re: [BUG 3.12.rc4] Oops: unable to handle kernel paging request
 during shutdown
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Knut Petersen <Knut_Petersen@t-online.de>, Ingo Molnar <mingo@kernel.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>,
        Greg KH <greg@kroah.com>, linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 25, 2013 at 11:23 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
>
> Enable DEBUG_OBJECTS, DEBUG_OBJECTS_FREE, DEBUG_OBJECTS_TIMERS

Yes, but nobody has actually been able to trigger it with those. It's
pretty rare, and the debug options are so expensive that they aren't
reasonable to enable generally...

So we need to try to figure out how to trigger it, or narrow things
down some way..

              Linus
