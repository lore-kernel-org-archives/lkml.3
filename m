Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753278AbaC3Lju (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 07:39:50 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:33841 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753201AbaC3Ljt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 07:39:49 -0400
X-Auth-Info: 6wHSAHfzKY8bd1EdwkOKGl4oLImKIhHvdZkGu5Phk04=
From: Andreas Schwab <schwab@linux-m68k.org>
To: Struan Bartlett <struan.bartlett@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Support for netconsole as default tty/console?
References: <CAOte+=YgX=0dahqCS6-=yBLHnTjoJtii3Ycx4mhrj9SqNADZzg@mail.gmail.com>
	<87r45lqcm7.fsf@igel.home>
	<CAOte+=YX5z9wri5Cj=JxHF2JjQroKYKAXurh=JRfjQH5eU_hyQ@mail.gmail.com>
X-Yow: This ASIAGO-N-DRIED TOMATO combo would taste a lot better between two
 plastic SIPPER LIDS!
Date: Sun, 30 Mar 2014 13:39:46 +0200
In-Reply-To: <CAOte+=YX5z9wri5Cj=JxHF2JjQroKYKAXurh=JRfjQH5eU_hyQ@mail.gmail.com>
	(Struan Bartlett's message of "Sun, 30 Mar 2014 10:44:33 +0200")
Message-ID: <871txjnce5.fsf@igel.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Struan Bartlett <struan.bartlett@gmail.com> writes:

> Thank you. I've begun investigating the sources in drivers/tty. Am I
> correct in thinking that this only needs a tty driver, and not also a
> serial driver?

See arch/m68k/emu/nfcon.c for a somewhat minimal example (only output).

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
