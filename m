Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758172Ab3KNWSb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 17:18:31 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:16193 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756408Ab3KNWSZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 17:18:25 -0500
Date: Thu, 14 Nov 2013 17:18:21 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: David Miller <davem@davemloft.net>
Cc: nicolas.dichtel@6wind.com, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, gregkh@linuxfoundation.org,
        williams@redhat.com, linux-rt-users@vger.kernel.org, lclaudio@uudg.org,
        netdev@vger.kernel.org, willemb@google.com
Subject: Re: [PATCH net] ip6tnl: fix use after free of fb_tnl_dev
Message-ID: <20131114171821.6500541d@gandalf.local.home>
In-Reply-To: <20131114.170529.1627250972818871118.davem@davemloft.net>
References: <20131113211430.1ad3bb7d@gandalf.local.home>
	<1384440423-4275-1-git-send-email-nicolas.dichtel@6wind.com>
	<20131114.170529.1627250972818871118.davem@davemloft.net>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Nov 2013 17:05:29 -0500 (EST)
David Miller <davem@davemloft.net> wrote:

 
> Applied and queued up for -stable, thanks for being so proactive about this
> Nicolas.

I should also note that I added this back to 3.10.18 and the bug goes
away.

If it's not too late:

Tested-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve

