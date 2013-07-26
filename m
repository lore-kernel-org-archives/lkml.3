Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751245Ab3GZSkY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 14:40:24 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:27814 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750932Ab3GZSkX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 14:40:23 -0400
X-Authority-Analysis: v=2.0 cv=P6i4d18u c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=nb7EXMkRL1gA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=TPSRDgTb3zUA:10 a=20KFwNOVAAAA:8 a=ag1SF4gXAAAA:8 a=24K-Pi3Ekky5IT0VrzgA:9 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=1TSTQ8KKaH4A:10 a=Y3G1v2uiLx0A:10 a=HwvuMbrV-i0A:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1374864018.6580.40.camel@gandalf.local.home>
Subject: Re: [PATCH 1/1] debugfs: debugfs_remove_recursive() must not rely
 on list_empty(d_subdirs)
From: Steven Rostedt <rostedt@goodmis.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
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
Date: Fri, 26 Jul 2013 14:40:18 -0400
In-Reply-To: <20130726173857.GB15013@kroah.com>
References: <20130723205854.GA9036@redhat.com>
	 <20130724184640.GA21322@redhat.com> <20130725192742.GA14060@redhat.com>
	 <20130725200423.GA22274@redhat.com> <20130725234357.GA14958@kroah.com>
	 <20130726151151.GA19472@redhat.com> <20130726151256.GC19472@redhat.com>
	 <20130726173857.GB15013@kroah.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-07-26 at 10:38 -0700, Greg Kroah-Hartman wrote:

> > Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> 
> Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Thanks Greg, I appreciate this.

-- Steve


