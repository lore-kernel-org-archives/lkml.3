Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762949Ab3JQVLN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 17:11:13 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:15013 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758649Ab3JQVLK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 17:11:10 -0400
Date: Thu, 17 Oct 2013 17:11:08 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org, yrl.pp-manager.tt@hitachi.com,
        aaronx.j.fabbri@intel.com
Subject: Re: [PATCH V2 0/5] trace-cmd: Support the feature recording trace
 data of guests on the host
Message-ID: <20131017171108.2171f143@gandalf.local.home>
In-Reply-To: <525F8485.7090503@hitachi.com>
References: <20130913020627.28927.69090.stgit@yunodevel>
	<20131014172637.2ced6be9@gandalf.local.home>
	<525F8485.7090503@hitachi.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Oct 2013 15:32:37 +0900
Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com> wrote:


> OK. As you say, when we know domains which we will boot, trace-cmd
> should make those automatically. So, I'll add this feature.
> Note that if we don't know domains when we boot virt-sevrer, we must
> make those manually now.
> 
> In this patch set, virt-server always uses /tmp/trace-cmd/virt, so
> we had better indicate only the domain name with d option, I think.
> 
> trace-cmd virt-server -d domain -m 710 -g qemu
> 
> What do you think about this?

Yes, yes, of course. I only added the full path because I blindly cut
and pasted what was there.

-- Steve
