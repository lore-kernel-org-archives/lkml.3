Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759396Ab3GZQ26 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 12:28:58 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48405 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757810Ab3GZQ25 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 12:28:57 -0400
Date: Fri, 26 Jul 2013 09:28:56 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Oleg Nesterov <oleg@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Alexander Z Lam <azl@google.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        David Sharp <dhsharp@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/1] debugfs: debugfs_remove_recursive() must not rely on
 list_empty(d_subdirs)
Message-ID: <20130726162856.GA12531@kroah.com>
References: <20130723205854.GA9036@redhat.com>
 <20130724184640.GA21322@redhat.com>
 <20130725192742.GA14060@redhat.com>
 <20130725200423.GA22274@redhat.com>
 <20130725234357.GA14958@kroah.com>
 <20130726151151.GA19472@redhat.com>
 <1374852613.6580.35.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374852613.6580.35.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 26, 2013 at 11:30:13AM -0400, Steven Rostedt wrote:
> On Fri, 2013-07-26 at 17:11 +0200, Oleg Nesterov wrote:
> > 
> > Steven, Greg. Assuming that nobody objects and the patch is fine.
> > Perhaps this patch can be routed via rostedt/linux-trace tree?
> 
> I'm fine with pushing it. But that requires Greg's Acked-by.

I can take it through my driver-core tree, which normally handles
debugfs patches, so it's no problem for me to take it.

Let me beat on it a bit first...

thanks,

greg k-h
