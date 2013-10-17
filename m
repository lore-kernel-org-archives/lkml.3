Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932119Ab3JQVVj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 17:21:39 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:42727 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1762373Ab3JQVVi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 17:21:38 -0400
Date: Thu, 17 Oct 2013 17:21:34 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org, yrl.pp-manager.tt@hitachi.com,
        aaronx.j.fabbri@intel.com
Subject: Re: [PATCH V2 2/5] trace-cmd: Apply the trace-msg protocol for
 communication between a server and clients
Message-ID: <20131017172134.44d58f69@gandalf.local.home>
In-Reply-To: <525F84E9.707@hitachi.com>
References: <20130913020627.28927.69090.stgit@yunodevel>
	<20130913020632.28927.18549.stgit@yunodevel>
	<20131014222115.4d427bb8@gandalf.local.home>
	<525F84E9.707@hitachi.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Oct 2013 15:34:17 +0900
Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com> wrote:
>    recorder error in splice output
> 
> It seems to be not due to applying my patch.
> We cannot use "localhost" for trace-cmd(v1.2).
> When we use "127.0.0.1", this problem does not occur.

You're right. Hmm, it's actually quite annoying that we can't use
localhost. I may have to fix that :-/

-- Steve

