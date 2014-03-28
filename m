Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752442AbaC1Sxz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 14:53:55 -0400
Received: from mga01.intel.com ([192.55.52.88]:6372 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751305AbaC1Sxy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 14:53:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,752,1389772800"; 
   d="scan'208";a="509185501"
From: Andi Kleen <andi@firstfloor.org>
To: Jovi Zhangwei <jovi.zhangwei@gmail.com>
Cc: Ingo Molnar <mingo@redhat.org>, Steven Rostedt <rostedt@goodmis.org>,
        linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 15/28] ktap: add built-in functions and library (runtime/lib_*.c)
References: <1396014469-5937-1-git-send-email-jovi.zhangwei@gmail.com>
	<1396014469-5937-16-git-send-email-jovi.zhangwei@gmail.com>
Date: Fri, 28 Mar 2014 11:51:00 -0700
In-Reply-To: <1396014469-5937-16-git-send-email-jovi.zhangwei@gmail.com> (Jovi
	Zhangwei's message of "Fri, 28 Mar 2014 09:47:36 -0400")
Message-ID: <87d2h6nomj.fsf@tassilo.jf.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jovi Zhangwei <jovi.zhangwei@gmail.com> writes:
>
> 2). Ansi library(lib_ansi.c):
> ansi.clear_screen
> ansi.set_color
> ansi.set_color2
> ansi.set_color3
> ansi.reset_color
> ansi.new_line

This really can't be done in some kind of ktap library?

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
