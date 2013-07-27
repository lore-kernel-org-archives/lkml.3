Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751827Ab3G0N3Y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jul 2013 09:29:24 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:44074 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751559Ab3G0N3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jul 2013 09:29:22 -0400
Date: Sat, 27 Jul 2013 15:29:15 +0200
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Linux Kernel Development <linux-kernel@vger.kernel.org>,
        Andrew Veliath <andrewtv@usa.net>, linux-kbuild@vger.kernel.org,
        linux-sh@vger.kernel.org
Subject: Re: Build regressions/improvements in v3.11-rc2
Message-ID: <20130727132915.GA3655@free.fr>
References: <alpine.DEB.2.02.1307232209510.32497@ayla.of.borg>
 <alpine.DEB.2.02.1307232210440.32577@ayla.of.borg>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1307232210440.32577@ayla.of.borg>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Geert, All,

Sorry to chime in a bit late...

On 2013-07-23 22:20 +0200, Geert Uytterhoeven spake thusly:
> On Tue, 23 Jul 2013, Geert Uytterhoeven wrote:
> > JFYI, when comparing v3.11-rc2 to v3.11-rc1[3], the summaries are:
> >   - build errors: +9/-23
[--SNIP--]
> powerpc-randconfig, due to a kconfig issue:
> 
> Expose SCOM controllers via debugfs (SCOM_DEBUGFS) [N/y] (NEW) aborted!
> Console input/output is redirected. Run 'make oldconfig' to update configuration
> .
> make[3]: *** [silentoldconfig] Error 1

Can you give me instructions on how to reproduce this error?

randconfig now should print the RNF seed, so that's d be nice to have to
reproduce the error. Also, having the problematic changeset would be
nice.

Regards,
Yann E. MORIN.

-- 
.-----------------.--------------------.------------------.--------------------.
|  Yann E. MORIN  | Real-Time Embedded | /"\ ASCII RIBBON | Erics' conspiracy: |
| +33 662 376 056 | Software  Designer | \ / CAMPAIGN     |  ___               |
| +33 223 225 172 `------------.-------:  X  AGAINST      |  \e/  There is no  |
| http://ymorin.is-a-geek.org/ | _/*\_ | / \ HTML MAIL    |   v   conspiracy.  |
'------------------------------^-------^------------------^--------------------'
