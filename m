Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756056Ab3JKU5q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 16:57:46 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:16232 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756029Ab3JKU5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 16:57:43 -0400
Message-ID: <1381525061.15023.13.camel@pippen.local.home>
Subject: Re: [PATCH v10 11/12] tracing: fix tracing_snapshot kerneldoc
From: Steven Rostedt <rostedt@goodmis.org>
To: Tom Zanussi <tom.zanussi@linux.intel.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org
Date: Fri, 11 Oct 2013 16:57:41 -0400
In-Reply-To: <1381498183.19281.12.camel@empanada>
References: <cover.1381445299.git.tom.zanussi@linux.intel.com>
	 <af1e1b69b339a85e11f580af9c3ba6dfa28cb20f.1381445299.git.tom.zanussi@linux.intel.com>
	 <5257F408.9040503@hitachi.com> <1381498183.19281.12.camel@empanada>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-4+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-10-11 at 08:29 -0500, Tom Zanussi wrote:
> On Fri, 2013-10-11 at 21:50 +0900, Masami Hiramatsu wrote:
> > (2013/10/11 9:48), Tom Zanussi wrote:
> > > The names of the functions are tracing_snapshot_*, not
> > > trace_snapshot_* - fix up the kerneldoc to avoid confusion.
> > > 
> > > Signed-off-by: Tom Zanussi <tom.zanussi@linux.intel.com>
> > 
> > It seems that this is not related this series.
> > Please send it as a trivial fix patch :)
> > 
> 
> Yeah, I keep adding patches as I test things, and 4 of the patches in
> this patchset now fit that description..

I'll pull this patch in now. I'll queue it up for 3.13.

-- Steve


