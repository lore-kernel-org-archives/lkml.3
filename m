Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756920Ab3G3Cgj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 22:36:39 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:59101 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753193Ab3G3Cgh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 22:36:37 -0400
Message-ID: <1375151796.2075.97.camel@joe-AO722>
Subject: Re: Checkpatch error on trace events macros
From: Joe Perches <joe@perches.com>
To: Li Zefan <lizefan@huawei.com>
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org
Date: Mon, 29 Jul 2013 19:36:36 -0700
In-Reply-To: <51F71FBC.6030600@huawei.com>
References: <20130729195201.GC14883@xanatos> <51F7171C.4060100@huawei.com>
	 <1375149538.2075.95.camel@joe-AO722> <51F71FBC.6030600@huawei.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-07-30 at 10:06 +0800, Li Zefan wrote:
> On 2013/7/30 9:58, Joe Perches wrote:
> > So what are these TRACE_<FOO> defines that need
> > excluding from the "complex values" check?
> > 
> > Anything other than 
> > 
> > TRACE_SYSTEM
> > TRACE_INCLUDE_FILE
> > TRACE_INCLUDE_PATH
> > 
> > ?
> > 
> > samples/trace_events/trace-events-sample.h
> > only has those 3.
> > 
> 
> Try:
>   # scripts/checkpatch.pl --file include/trace/events/*
> 
> You'll see numerous errors. :)

Nope, you'll see numerous whitespace defects, but no
actual errors.

If you run with:

--ignore=spacing,long_line,code_indent,leading_space,printf_l,split_string,space_before_tab,trailing_whitespace,line_continuations

it's flawless.


