Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753138AbaC3D6M (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2014 23:58:12 -0400
Received: from one.firstfloor.org ([193.170.194.197]:60100 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753118AbaC3D6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2014 23:58:11 -0400
Date: Sun, 30 Mar 2014 05:58:10 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Jovi Zhangwei <jovi.zhangwei@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
        linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH v2 13/29] ktap: add ring buffer handling
 code(kernel/trace/ktap/kp_transport.[c|h])
Message-ID: <20140330035810.GD22728@two.firstfloor.org>
References: <1396017924-7754-1-git-send-email-jovi.zhangwei@gmail.com>
 <1396017924-7754-14-git-send-email-jovi.zhangwei@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1396017924-7754-14-git-send-email-jovi.zhangwei@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> A lot of code in this file is duplicated with kernel trace_output.c.

Please modify trace_output instead to avoid this.

-Andi

