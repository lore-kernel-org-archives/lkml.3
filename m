Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936697Ab3DIBiq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 21:38:46 -0400
Received: from intranet.asianux.com ([58.214.24.6]:50155 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936538Ab3DIBip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 21:38:45 -0400
X-Spam-Score: -106.8
Message-ID: <51637105.9020506@asianux.com>
Date: Tue, 09 Apr 2013 09:38:13 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, gang.chen@asianux.com, tglx@linutronix.de
CC: tip-bot for Chen Gang <tipbot@zytor.com>,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/urgent] ftrace: Fix strncpy() use, use strlcpy() instead
 of strncpy()
References: <516243B7.9020405@asianux.com> <tip-75761cc15877c155b3849b4e0e0cb3f897faf471@git.kernel.org>
In-Reply-To: <tip-75761cc15877c155b3849b4e0e0cb3f897faf471@git.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013年04月08日 23:31, tip-bot for Chen Gang wrote:
> Commit-ID:  75761cc15877c155b3849b4e0e0cb3f897faf471
> Gitweb:     http://git.kernel.org/tip/75761cc15877c155b3849b4e0e0cb3f897faf471
> Author:     Chen Gang <gang.chen@asianux.com>
> AuthorDate: Mon, 8 Apr 2013 12:12:39 +0800
> Committer:  Ingo Molnar <mingo@kernel.org>
> CommitDate: Mon, 8 Apr 2013 13:26:56 +0200
> 
> ftrace: Fix strncpy() use, use strlcpy() instead of strncpy()
> 
> For NUL terminated string we always need to set '\0' at the end.
> 
> Signed-off-by: Chen Gang <gang.chen@asianux.com>
> Cc: rostedt@goodmis.org
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Link: http://lkml.kernel.org/r/516243B7.9020405@asianux.com
> Signed-off-by: Ingo Molnar <mingo@kernel.org>
> ---


  thank you very much for applying the 3 related patches.



-- 
Chen Gang

Asianux Corporation
