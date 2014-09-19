Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757864AbaISXfm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 19:35:42 -0400
Received: from mail-lb0-f177.google.com ([209.85.217.177]:42162 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752139AbaISXfl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 19:35:41 -0400
MIME-Version: 1.0
In-Reply-To: <20140919205754.GE26432@jtriplet-mobl1>
References: <1411147563-9136-1-git-send-email-bobby.prani@gmail.com> <20140919205754.GE26432@jtriplet-mobl1>
From: Pranith Kumar <bobby.prani@gmail.com>
Date: Fri, 19 Sep 2014 19:35:09 -0400
Message-ID: <CAJhHMCCXUJyyxPe=HFcR_YtihwkLEg96X81W8R7FKpsYb78Z9w@mail.gmail.com>
Subject: Re: [RFC PATCH] rcu: Change use of __this_cpu ops on a bool type
To: Josh Triplett <josh@joshtriplett.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        "open list:READ-COPY UPDATE..." <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 19, 2014 at 4:57 PM, Josh Triplett <josh@joshtriplett.org> wrote:
> On Fri, Sep 19, 2014 at 01:26:03PM -0400, Pranith Kumar wrote:
>> __this_cpu_{read/write}() uses sizeof() to determine the size of the variable.
>> Using this operation on a bool type causes sparse to complain.
>>
>> I checked the generated code and there is only a slight difference in
>> instructions generated.
>>
>> I am not sure this warning by sparse is really valid, but let us silence it
>> anyways.
>>
>> Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
>
> I believe this warning was actually fixed with current versions of
> Sparse; there was some discussion and a patch on the linux-sparse
> mailing list.  Can you please recheck with the latest Sparse from git,
> and if it still breaks, please raise that on linux-sparse?
>

Yup, looks like the latest version of sparse fixes this. Please ignore
this patch. Thanks!

-- 
Pranith
