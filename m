Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752563AbaBXDks (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 22:40:48 -0500
Received: from ozlabs.org ([203.10.76.45]:38360 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752023AbaBXDkq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 22:40:46 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Xudong Zhang <xdzhang@suse.com>
Cc: linux-kernel@vger.kernel.org, felixmelon@gmail.com
Subject: Re: [PATCH] There should have a warn/log when out-of-tree module is loaded
In-Reply-To: <20140221081330.GA11757@dell-zxd.apac.novell.com>
References: <20140221081330.GA11757@dell-zxd.apac.novell.com>
User-Agent: Notmuch/0.15.2 (http://notmuchmail.org) Emacs/23.4.1 (x86_64-pc-linux-gnu)
Date: Mon, 24 Feb 2014 12:09:23 +1030
Message-ID: <87sir970hg.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Xudong Zhang <xdzhang@suse.com> writes:
> I can not get any hint when I found that my kernel is tainted (out of
> tree module is loaded). And I checked all loaded and loadable modules
> but it showed that all of them are intree modules.
> I think we need a warn when out of tree module is loaded.
>
> Signed-off-by: Xudong Zhang <xdzhang@suse.com>

This would be an escalation.

This taint only has an effect on oops messages, and
/proc/sys/kernel/tainted.

Cheers,
Rusty.
