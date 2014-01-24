Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752571AbaAXMOJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 07:14:09 -0500
Received: from mail-gg0-f179.google.com ([209.85.161.179]:58996 "EHLO
	mail-gg0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752210AbaAXMOH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 07:14:07 -0500
Date: Fri, 24 Jan 2014 09:13:40 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>, linux-kernel@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        "David A. Long" <dave.long@linaro.org>, yrl.pp-manager.tt@hitachi.com,
        Namhyung Kim <namhyung@kernel.org>
Subject: Re: Re: [PATCH -tip 4/8] perf-probe: Use the actual address instead
 of the symbol name
Message-ID: <20140124121340.GA5348@ghostprotocols.net>
References: <20140123022945.7206.79944.stgit@kbuild-fedora.yrl.intra.hitachi.co.jp>
 <20140123022954.7206.77940.stgit@kbuild-fedora.yrl.intra.hitachi.co.jp>
 <20140123145211.GB25714@ghostprotocols.net>
 <20140123111237.1ff2e523@gandalf.local.home>
 <52E1C6AC.4000608@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52E1C6AC.4000608@hitachi.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Jan 24, 2014 at 10:49:32AM +0900, Masami Hiramatsu escreveu:
> (2014/01/24 1:12), Steven Rostedt wrote:
> > On Thu, 23 Jan 2014 11:52:11 -0300
> > Arnaldo Carvalho de Melo <acme@ghostprotocols.net> wrote:
> > 
> >> Em Thu, Jan 23, 2014 at 02:29:55AM +0000, Masami Hiramatsu escreveu:
> >>> Since several local symbols can have same name (e.g. t_show),
> >>> we need to use the actual address instead of symbol name for
> >>> those points. Note that this works only with debuginfo.
> >>>
> >>> E.g. without this change;
> >>> ----
> >>
> >> Please use spaces after dashed lines, this is even as (or more)
> >> important as prefixing # lines, as this makes everything after the ---
> >> line and the patch itself to be ignored.
> >>
> 
> Oops, I thought that "----" was safe...
> 
> > You recommend after? I found adding a single space before the dashes
> > better, as that way I know I added one and didn't forget to.
> 
> OK, I'll add at least one space before dashes.
> 
> BTW, should "#" have two spaces instead of one?

I suggest using two spaces before --- and #, that is what I do and edit
patches from others when merging, so that would save me some time while
processing patches.

- Arnaldo
 
> Thank you
> 
> -- 
> Masami HIRAMATSU
> IT Management Research Dept. Linux Technology Center
> Hitachi, Ltd., Yokohama Research Laboratory
> E-mail: masami.hiramatsu.pt@hitachi.com
> 
