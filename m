Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751972Ab3CCGMl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 01:12:41 -0500
Received: from mail-oa0-f53.google.com ([209.85.219.53]:51692 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750846Ab3CCGMk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 01:12:40 -0500
MIME-Version: 1.0
In-Reply-To: <20130302132330.GA15256@localhost>
References: <5131ad43.H709l5IR4X+pbvbq%fengguang.wu@intel.com>
	<1362229972.31874.7.camel@gandalf.local.home>
	<1362230122.31874.8.camel@gandalf.local.home>
	<20130302132330.GA15256@localhost>
Date: Sat, 2 Mar 2013 22:12:40 -0800
X-Google-Sender-Auth: zNfgAShOaSckXO7RgH1gE6o-nTc
Message-ID: <CANeU7Qn4n5QpiEiFaiwR5if4yAaCiWMHneJ8gg26Jac-4tbZyw@mail.gmail.com>
Subject: Re: [trace:tip/perf/core 5/15] kernel/trace/trace_functions.c:79:16:
 sparse: incorrect type in initializer (different address spaces)
From: Christopher Li <sparse@chrisli.org>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 2, 2013 at 5:23 AM, Fengguang Wu <fengguang.wu@intel.com> wrote:
> That's it!  Verified with
>
>         make C=1 kernel/trace/trace_functions.o

You can use C=2 to run sparse without recompile the obj file.

Chris
