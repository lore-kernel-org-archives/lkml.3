Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422704AbaDQNbd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 09:31:33 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:61779 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422634AbaDQNba (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 09:31:30 -0400
Subject: Re: [PATCH] tracing/uprobes: fix uprobe_cpu_buffer memory leak
From: Namhyung Kim <namhyung@kernel.org>
To: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 17 Apr 2014 22:31:24 +0900
Message-ID: <1397741484.1731.11.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jovi,

(Sorry for replying in another thread.  I don't have an access to the
company mail at home.)

On Thu, Apr 17, 2014 at 04:05:19PM +0800, "zhangwei(Jovi)" wrote:
> Forgot to free uprobe_cpu_buffer percpu page in uprobe_buffer_disable.

Thanks for fixing this!

Acked-by: Namhyung Kim <namhyung@kernel.org>

Thanks,
Namhyung


