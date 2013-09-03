Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761177Ab3ICVMo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 17:12:44 -0400
Received: from mail-wg0-f53.google.com ([74.125.82.53]:52676 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760334Ab3ICVMm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 17:12:42 -0400
Date: Tue, 3 Sep 2013 23:12:37 +0200
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH 1/3] kconfig: do not special-case 'MODULES' symbol
Message-ID: <20130903211237.GA3681@free.fr>
References: <1378242287-12759-1-git-send-email-yann.morin.1998@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1378242287-12759-1-git-send-email-yann.morin.1998@free.fr>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michal, All,

On 2013-09-03 23:04 +0200, Yann E. MORIN spake thusly:
> Currently, the 'MODULES' symbol is hard-coded to be the default symbol
> that enables/disables tristates, if no other symbol was declared with
> 'option modules'.
> 
> While this used to be needed for the Linux kernel, we now have an
> explicit 'option modules' attached to the 'MODULES' symbol (since
> cset 11097a036), so we no longer need to special-case it in the
> kconfig code.
> 
> Furthermore, kconfig is extensively used out of the Linux kernel, and
> other projects may have another meaning for a symbol named 'MODULES'.
> 
> This patch changes the way we enable/disable tristates: if a symbol was
> found with 'option modules' attached to it, then that symbol controls
> enabling tristates. Otherwise, tristates are disabled, even if a symbol
> named 'MODULES' exists.

Doh... I forgot to send an intro mail first. Seems holidays really were
a good break! :-)

Anyway, this series might be a bit late to go in for 3.12, but it has
previously been discussed with you and Sam.

If you feel it's too touchy for 3.12, then I believe it can easily wait
for 3.13.

If you want it for 3.12, I can send a pull-request if that's easier for
you.

Regards,
Yann E. MORIN.

-- 
.-----------------.--------------------.------------------.--------------------.
|  Yann E. MORIN  | Real-Time Embedded | /"\ ASCII RIBBON | Erics' conspiracy: |
| +33 662 376 056 | Software  Designer | \ / CAMPAIGN     |  ___               |
| +33 223 225 172 `------------.-------:  X  AGAINST      |  \e/  There is no  |
| http://ymorin.is-a-geek.org/ | _/*\_ | / \ HTML MAIL    |   v   conspiracy.  |
'------------------------------^-------^------------------^--------------------'
