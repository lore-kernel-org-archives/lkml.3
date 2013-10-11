Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757951Ab3JKNA1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 09:00:27 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:43687 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752198Ab3JKNA0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 09:00:26 -0400
Message-ID: <5257F666.7080703@hitachi.com>
Date: Fri, 11 Oct 2013 22:00:22 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Tom Zanussi <tom.zanussi@linux.intel.com>
Cc: rostedt@goodmis.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v10 12/12] tracing: define trace_dump_stack() if !CONFIG_STACKTRACE
References: <cover.1381445299.git.tom.zanussi@linux.intel.com> <b88c6631dc9bdd143e5fc19341954e42e59de128.1381445299.git.tom.zanussi@linux.intel.com>
In-Reply-To: <b88c6631dc9bdd143e5fc19341954e42e59de128.1381445299.git.tom.zanussi@linux.intel.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/10/11 9:48), Tom Zanussi wrote:
> If CONFIG_STACKTRACE is turned off, trace_dump_stack() isn't defined,
> resulting in an 'undefined reference' error - define a stub to remedy
> that.
> 
> Signed-off-by: Tom Zanussi <tom.zanussi@linux.intel.com>

Hmm, what kernel config caused that error?
It seems that the CONFIG_STACKTRACE is forced on if it is required.
And if you have found such case, IMHO, we should turn on the CONFIG_STACKTRACE
in Kconfig.
(Also, if it is not related to this series, it should be reported as a separated
bugfix :) )

Thank you,


-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


