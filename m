Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753224AbaA3NbI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 08:31:08 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:28667 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752169AbaA3NbG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 08:31:06 -0500
Date: Thu, 30 Jan 2014 08:31:03 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: nicolas.dichtel@6wind.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        stable <stable@vger.kernel.org>, Clark Williams <williams@redhat.com>,
        "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
        John Kacur <jkacur@redhat.com>, Willem de Bruijn <willemb@google.com>
Subject: Re: [PATCH 0/2] [BUG FIXES - 3.10.27] sit: More backports
Message-ID: <20140130083103.2bc68bad@gandalf.local.home>
In-Reply-To: <52EA1B4B.5080403@6wind.com>
References: <20140128205756.074448668@goodmis.org>
	<52E8E025.2060803@6wind.com>
	<20140129075745.4227a2ed@gandalf.local.home>
	<52E9267C.90403@6wind.com>
	<20140129154811.27fbaf13@gandalf.local.home>
	<52EA1B4B.5080403@6wind.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Jan 2014 10:28:43 +0100
Nicolas Dichtel <nicolas.dichtel@6wind.com> wrote:


> Steve, I think the patch I sent yesterday is the good fix. At the end, it's
> a backport of Willem's patch. Note that he also ack that patch.
> The first version you sent (which removes
> unregister_netdevice_queue(sitn->fb_tunnel_dev, &list)) will introduce a
> memory leak when the user destroy a netns.

Hi Nicolas,

I reverted my patches and applied and tested your patches locally and
they passed my first line testing. I'm going to have them entered into
our test suite, after removing our other patches, and see if they solve
all the bugs that we were tripping over.

I'll let you know when these are finished.

Thanks!

-- Steve
