Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752555AbaDDUwH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 16:52:07 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:54366 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751879AbaDDUwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 16:52:05 -0400
Date: Fri, 04 Apr 2014 16:53:41 -0400 (EDT)
Message-Id: <20140404.165341.2082003037256406028.davem@davemloft.net>
To: dzickus@redhat.com
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, x86@kernel.org,
        sparclinux@vger.kernel.org, mguzik@redhat.com, atomlin@redhat.com
Subject: Re: [PATCH 3/4 v2] sparc64, nmi: Add more flexible NMI back trace
 support
From: David Miller <davem@davemloft.net>
In-Reply-To: <1396644430-70649-4-git-send-email-dzickus@redhat.com>
References: <1396644430-70649-1-git-send-email-dzickus@redhat.com>
	<1396644430-70649-4-git-send-email-dzickus@redhat.com>
X-Mailer: Mew version 6.4 on Emacs 23.4 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 04 Apr 2014 13:52:04 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Don Zickus <dzickus@redhat.com>
Date: Fri,  4 Apr 2014 16:47:09 -0400

> From: Aaron Tomlin <atomlin@redhat.com>
> 
> This patch introduces the sparc specific implementation
> changes to the arch_trigger_all_cpu_backtrace() routine.
> Now users have the ability to choose whether or not to
> issue an NMI back trace which includes current.
> 
> Update sysrq_handle_globreg() to use the new interface
> 
> [squash two sparc patches, update changelog - dcz]
> 
> Signed-off-by: Aaron Tomlin <atomlin@redhat.com>
> Signed-off-by: Don Zickus <dzickus@redhat.com>

Acked-by: David S. Miller <davem@davemloft.net>
