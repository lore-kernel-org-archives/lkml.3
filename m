Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752167AbaC3RRG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 13:17:06 -0400
Received: from one.firstfloor.org ([193.170.194.197]:32888 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751919AbaC3RRF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 13:17:05 -0400
Date: Sun, 30 Mar 2014 19:17:03 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Jovi Zhangwei <jovi.zhangwei@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH v2 08/29] ktap: add bytecode
 reader(kernel/trace/ktap/kp_bcread.[c|h])
Message-ID: <20140330171703.GE22728@two.firstfloor.org>
References: <1396017924-7754-1-git-send-email-jovi.zhangwei@gmail.com>
 <1396017924-7754-9-git-send-email-jovi.zhangwei@gmail.com>
 <20140330024701.GA22728@two.firstfloor.org>
 <CAGdX0WG6Nid66iuRWqLbfmH89XacEXuUNYCNjnB7j=HYiyCKBw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGdX0WG6Nid66iuRWqLbfmH89XacEXuUNYCNjnB7j=HYiyCKBw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> That's designed for portability initially, it means we can just run bytecode
> without compile script file everywhere, especially when compilation  is
> a heavily task for some embedded platform, even though ktap compilation
> is extremely fast.
> 
> I doubt maybe there will have this bytecode portability requirement in future?

Portability should be on the source level.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
