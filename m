Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753352Ab3AYHyn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 02:54:43 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:54183 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751977Ab3AYHyl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 02:54:41 -0500
Date: Fri, 25 Jan 2013 08:54:37 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Anton Arapov <anton@redhat.com>, Christoph Hellwig <hch@infradead.org>,
        Josh Stone <jistone@redhat.com>, linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Suzuki Poulose <suzuki@in.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Subject: Re: [GIT PULL] uprobes: pre-filtering
Message-ID: <20130125075437.GB21036@gmail.com>
References: <20130113185916.GA25831@redhat.com>
 <20130124121720.GA3104@gmail.com>
 <20130124154018.GA8580@redhat.com>
 <20130124154159.GB32071@gmail.com>
 <20130124170612.GA14823@redhat.com>
 <20130125064629.GD23723@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130125064629.GD23723@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Srikar Dronamraju <srikar@linux.vnet.ibm.com> wrote:

> The other alternative is to extend the current abi and pass 
> the prefilter option. Should we extend the abi for userspace 
> tracing is obviously debatable.

That's the obvious path to go - why add something to the kernel 
if user-space cannot make use of it?

Thanks,

	Ingo
