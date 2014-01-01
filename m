Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753530AbaAAL0G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jan 2014 06:26:06 -0500
Received: from mail-wg0-f53.google.com ([74.125.82.53]:45330 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752914AbaAAL0C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jan 2014 06:26:02 -0500
Date: Wed, 1 Jan 2014 12:25:55 +0100
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
To: Masanari Iida <standby24x7@gmail.com>
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org,
        linux-kbuild@vger.kernel.org
Subject: Re: [PATCH 1/2] [trivial] scripts: kconfig: Fix trailing whitespace
 in zconf.lex.c_shipped
Message-ID: <20140101112555.GA3372@free.fr>
References: <1387697785-29767-1-git-send-email-standby24x7@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1387697785-29767-1-git-send-email-standby24x7@gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Masanari, All,

On 2013-12-22 16:36 +0900, Masanari Iida spake thusly:
> This patch fixed "Error: trailing whitespace" found by
> checkpatch.pl in scripts/kconfig/zconf.lex.c_shipped

That file is a generated file, so we don't really care about trailing
spaces in it.

We only really care about trailing spaces in actual source files.

Ditto for your patch 2/2.

Regards,
Yann E. MORIN.

-- 
.-----------------.--------------------.------------------.--------------------.
|  Yann E. MORIN  | Real-Time Embedded | /"\ ASCII RIBBON | Erics' conspiracy: |
| +33 662 376 056 | Software  Designer | \ / CAMPAIGN     |  ___               |
| +33 223 225 172 `------------.-------:  X  AGAINST      |  \e/  There is no  |
| http://ymorin.is-a-geek.org/ | _/*\_ | / \ HTML MAIL    |   v   conspiracy.  |
'------------------------------^-------^------------------^--------------------'
