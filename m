Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756035Ab3JRPGT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 11:06:19 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:8809 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754875Ab3JRPGS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 11:06:18 -0400
Date: Fri, 18 Oct 2013 11:06:16 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org, yrl.pp-manager.tt@hitachi.com
Subject: Re: [PATCH V2 0/5] trace-cmd: Support the feature recording trace
 data of guests on the host
Message-ID: <20131018110616.01a26af6@gandalf.local.home>
In-Reply-To: <20130913020627.28927.69090.stgit@yunodevel>
References: <20130913020627.28927.69090.stgit@yunodevel>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Sep 2013 11:06:27 +0900
Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com> wrote:

> Hi Steven,
> 
> This is a v2 patch set for realizing a part of "Integrated trace" feature which 
> is a trace merging system for a virtualization environment. Currently, trace-cmd
> does not have following features yet:
> 
> a) Server and client for a virtualization environment
> b) Structured message platform between guests and host
> c) Agent feature of a client
> d) Merge feature of trace data of multiple guests and host in chronological
>    order
> 

Hi Yoshihiro,

I do like your patch set, but I was thinking as this is becoming a new
ABI between the client and the server, I really want to spend a lot
more time looking at this before I pull it.

I'll be traveling again on Monday for 10 days (going to Kernel Summit
than the RT summit), and I'll try to review it more during my trip. But
even then, I really want to make sure the communication is robust. I
hate to have a "V3" and then need to support two older versions.

Thanks,

-- Steve
