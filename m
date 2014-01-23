Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752084AbaAWQMl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 11:12:41 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:20764 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751445AbaAWQMk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 11:12:40 -0500
Date: Thu, 23 Jan 2014 11:12:37 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>, linux-kernel@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        "David A. Long" <dave.long@linaro.org>, yrl.pp-manager.tt@hitachi.com,
        Namhyung Kim <namhyung@kernel.org>
Subject: Re: [PATCH -tip 4/8] perf-probe: Use the actual address instead of
 the symbol name
Message-ID: <20140123111237.1ff2e523@gandalf.local.home>
In-Reply-To: <20140123145211.GB25714@ghostprotocols.net>
References: <20140123022945.7206.79944.stgit@kbuild-fedora.yrl.intra.hitachi.co.jp>
	<20140123022954.7206.77940.stgit@kbuild-fedora.yrl.intra.hitachi.co.jp>
	<20140123145211.GB25714@ghostprotocols.net>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Jan 2014 11:52:11 -0300
Arnaldo Carvalho de Melo <acme@ghostprotocols.net> wrote:

> Em Thu, Jan 23, 2014 at 02:29:55AM +0000, Masami Hiramatsu escreveu:
> > Since several local symbols can have same name (e.g. t_show),
> > we need to use the actual address instead of symbol name for
> > those points. Note that this works only with debuginfo.
> > 
> > E.g. without this change;
> > ----
> 
> Please use spaces after dashed lines, this is even as (or more)
> important as prefixing # lines, as this makes everything after the ---
> line and the patch itself to be ignored.
> 

You recommend after? I found adding a single space before the dashes
better, as that way I know I added one and didn't forget to.

-- Steve
