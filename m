Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752802Ab3AUGzY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 01:55:24 -0500
Received: from kiruna.synopsys.com ([198.182.44.80]:42680 "EHLO
	kiruna.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752667Ab3AUGzX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 01:55:23 -0500
Message-ID: <50FCE64D.1080501@synopsys.com>
Date: Mon, 21 Jan 2013 12:25:09 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel.cross-arch,gmane.linux.kernel
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <arnd@arndb.de>
Subject: Re: [PATCH v2 16/76] ARC: Syscall support (no-legacy-syscall ABI)
References: <1358511930-7424-1-git-send-email-vgupta@synopsys.com> <1358511930-7424-17-git-send-email-vgupta@synopsys.com> <20130119030918.GA23552@ZenIV.linux.org.uk>
In-Reply-To: <20130119030918.GA23552@ZenIV.linux.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.197.205]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 19 January 2013 08:39 AM, Al Viro wrote:
> Please, collapse your #36--#40 into that one (and I'd probably fold #17
> here as well, to simplify that reordering).  Sure, it's not a bisection
> hazard, but...
> 

I kept #16 and #17 distinct and

  * squashed switch-to-generic-kernel-thread #36 into process creation patch #17
  * split generic kernel_execve and sys_execve #37 into two
    * squashed sys_execve bits into syscall patch #16
    * squashed kernel_execve patch into #17
  * squashed switch-to-saner-execve patches #38 and #39 into #17
  * squashed generic clone patch #40 into #16

