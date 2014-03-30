Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752813AbaC3A6M (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2014 20:58:12 -0400
Received: from one.firstfloor.org ([193.170.194.197]:59544 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752595AbaC3A6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2014 20:58:11 -0400
Date: Sun, 30 Mar 2014 01:58:09 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Jovi Zhangwei <jovi.zhangwei@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@redhat.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 15/28] ktap: add built-in functions and library
 (runtime/lib_*.c)
Message-ID: <20140330005809.GY22728@two.firstfloor.org>
References: <1396014469-5937-1-git-send-email-jovi.zhangwei@gmail.com>
 <1396014469-5937-16-git-send-email-jovi.zhangwei@gmail.com>
 <87d2h6nomj.fsf@tassilo.jf.intel.com>
 <CAGdX0WHEB7r0t_Bu6ME+gS=HxjFY9dnfn6azwyXe4U6sV7r0eQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGdX0WHEB7r0t_Bu6ME+gS=HxjFY9dnfn6azwyXe4U6sV7r0eQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Maybe in future, after ktap support "include" or "require" to
> import user defined library in userspace.

Can't you just have some hardcoded standard script for now that is 
always appeneded and provides these functions?

-Andi
