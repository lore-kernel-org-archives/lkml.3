Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932581Ab3CGQjV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 11:39:21 -0500
Received: from mail.renton.name ([90.155.165.44]:35139 "EHLO
	beaver.old-horrors.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755296Ab3CGQjV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 11:39:21 -0500
Date: Thu, 7 Mar 2013 20:37:43 +0400
From: Alexey Vlasov <renton@renton.name>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: BUG: soft lockup on all kernels after 2.6.3x
Message-ID: <20130307163743.GC6115@beaver>
References: <20130209141029.GA13493@beaver>
 <1360422473.6696.28.camel@edumazet-glaptop>
 <20130307125424.GI13493@beaver>
 <1362673223.15793.215.camel@edumazet-glaptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1362673223.15793.215.camel@edumazet-glaptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 07, 2013 at 08:20:23AM -0800, Eric Dumazet wrote:
>
> What are gr_xxxx symbols ?

This is grsecurity patches ;)
 
> Mar  7 00:50:00 l25 [1735187.889877]  [<ffffffff8110e118>] ? is_path_reachable+0x48/0x60
> Mar  7 00:50:00 l25 [1735187.889880]  [<ffffffff8110e163>] ? path_is_under+0x33/0x60
> Mar  7 00:50:00 l25 [1735187.889887]  [<ffffffff812257a4>] ? gr_is_outside_chroot+0x54/0x70
> Mar  7 00:50:00 l25 [1735187.889890]  [<ffffffff81225815>] ? gr_chroot_fchdir+0x55/0x80
> Mar  7 00:50:00 l25 [1735187.889894]  [<ffffffff810f9b2e>] ? filename_lookup.clone.39+0x9e/0xe0
> Mar  7 00:50:00 l25 [1735187.889897]  [<ffffffff810fc85c>] ? user_path_at_empty+0x5c/0xb0
> Mar  7 00:50:00 l25 [1735187.889903]  [<ffffffff8102b5f9>] ? __do_page_fault+0x1b9/0x480
> Mar  7 00:50:00 l25 [1735187.889907]  [<ffffffff814b09c2>] ? page_fault+0x22/0x30
> Mar  7 00:50:00 l25 [1735187.889910]  [<ffffffff810f146e>] ? vfs_fstatat+0x3e/0x90
> Mar  7 00:50:00 l25 [1735187.889914]  [<ffffffff812278cb>] ? gr_learn_resource+0x3b/0x1e0
> Mar  7 00:50:00 l25 [1735187.889918]  [<ffffffff810f168f>] ? sys_newstat+0x1f/0x50
> Mar  7 00:50:00 l25 [1735187.889922]  [<ffffffff810ea4b4>] ? filp_close+0x54/0x80
> Mar  7 00:50:00 l25 [1735187.889925]  [<ffffffff814b09c2>] ? page_fault+0x22/0x30
> Mar  7 00:50:00 l25 [1735187.889928]  [<ffffffff814b0f49>] ? system_call_fastpath+0x18/0x1d
