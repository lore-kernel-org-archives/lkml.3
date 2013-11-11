Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754516Ab3KKSNV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 13:13:21 -0500
Received: from mail-wg0-f48.google.com ([74.125.82.48]:50366 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753747Ab3KKSNL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 13:13:11 -0500
Date: Mon, 11 Nov 2013 19:13:04 +0100
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
To: David Cohen <david.a.cohen@linux.intel.com>
Cc: linux-kbuild@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        mmarek@suse.cz, rostedt@goodmis.org
Subject: Re: make oldnoconfig fix?
Message-ID: <20131111181304.GB3510@free.fr>
References: <52811DDD.3030609@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <52811DDD.3030609@linux.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David, All,

On 2013-11-11 10:11 -0800, David Cohen spake thusly:
> Is there a plan to fix 'make oldnoconfig' option?
> I currently have need to it :)
> I've tracked a thread fixing 'make olddefconfig' where 'oldnoconfig'
> option is reported as a known bug, right?

Sorry, I don't understand what your problem is.

Care to explain in details what problem you have:
  - what you start with
  - what you do
  - what you get
  - what you expected

So we can try to reproduce the issue and investigate what is wrong.

Since you mention an existing thread, please add a pointer (URL) to
this thread in the archives (Use: http://marc.info/?l=linux-kbuild ).

Regards,
Yann E. MORIN.

-- 
.-----------------.--------------------.------------------.--------------------.
|  Yann E. MORIN  | Real-Time Embedded | /"\ ASCII RIBBON | Erics' conspiracy: |
| +33 662 376 056 | Software  Designer | \ / CAMPAIGN     |  ___               |
| +33 223 225 172 `------------.-------:  X  AGAINST      |  \e/  There is no  |
| http://ymorin.is-a-geek.org/ | _/*\_ | / \ HTML MAIL    |   v   conspiracy.  |
'------------------------------^-------^------------------^--------------------'
