Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753844AbaCaJSe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 05:18:34 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:38332 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753421AbaCaJSd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 05:18:33 -0400
Message-ID: <533932E2.5060302@hitachi.com>
Date: Mon, 31 Mar 2014 18:18:26 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Jovi Zhangwei <jovi.zhangwei@gmail.com>
Cc: Ingo Molnar <mingo@redhat.org>, Steven Rostedt <rostedt@goodmis.org>,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [RFC PATCH 00/28] ktap: A lightweight dynamic tracing tool
 for Linux
References: <1396014469-5937-1-git-send-email-jovi.zhangwei@gmail.com>
In-Reply-To: <1396014469-5937-1-git-send-email-jovi.zhangwei@gmail.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jovi,

(2014/03/28 22:47), Jovi Zhangwei wrote:
> Hi All,
> 
> The following set of patches add ktap tracing tool. 
> 
> ktap is a new script-based dynamic tracing tool for Linux.
> It uses a scripting language and lets the user trace system dynamically.
> 
> Highlights features:
> * a simple but powerful scripting language
> * register-based interpreter (heavily optimized) in Linux kernel
> * small and lightweight
> * not depend on the GCC toolchain for each script run
> * easy to use in embedded environments without debugging info
> * support for tracepoint, kprobe, uprobe, function trace, timer, and more
> * supported in x86, ARM, PowerPC, MIPS
> * safety in sandbox

Is this the minimal code base of ktap for upstream? It seems that
this series includes many extras. Would you slim this down to the
minimum function set (minimum runtime and lua compiler code)?
If we succeed to merge the basic functionality, we can add other
extra features one by one.

Thank you,


-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


