Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751862AbaC2Oy2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2014 10:54:28 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:47033 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751523AbaC2Oy0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2014 10:54:26 -0400
X-Auth-Info: hO5lFTM6yrxd+WS9IoSJBmqkFH2F4oKepigNqXwAE74=
From: Andreas Schwab <schwab@linux-m68k.org>
To: Struan Bartlett <struan.bartlett@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Support for netconsole as default tty/console?
References: <CAOte+=YgX=0dahqCS6-=yBLHnTjoJtii3Ycx4mhrj9SqNADZzg@mail.gmail.com>
X-Yow: RHAPSODY in Glue!
Date: Sat, 29 Mar 2014 15:54:24 +0100
In-Reply-To: <CAOte+=YgX=0dahqCS6-=yBLHnTjoJtii3Ycx4mhrj9SqNADZzg@mail.gmail.com>
	(Struan Bartlett's message of "Sat, 29 Mar 2014 13:22:21 +0100")
Message-ID: <87r45lqcm7.fsf@igel.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Struan Bartlett <struan.bartlett@gmail.com> writes:

> Adding console=netconsole to the command line does not appear to have
> the desired effect. I am not sure if this is because netconsole,
> unlike the serial console, does not provide a tty. Can anyone advise
> if this understanding is correct? If so, is there an independent
> solution to this problem?

It should not be hard to add a tty driver to netconsole, there are many
examples to borrow from.

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
