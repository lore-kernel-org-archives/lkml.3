Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752926AbaC1VC0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 17:02:26 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:40849 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751760AbaC1VCZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 17:02:25 -0400
Date: Fri, 28 Mar 2014 17:02:22 -0400 (EDT)
Message-Id: <20140328.170222.346040641241669437.davem@davemloft.net>
To: dh.herrmann@gmail.com
Cc: netdev@vger.kernel.org, teg@jklm.no, johannes@sipsolutions.net,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 0/4] Provide netdev naming-policy via sysfs
From: David Miller <davem@davemloft.net>
In-Reply-To: <CANq1E4TxaNnZoqfw5DiifAhk28hVq5HJJMd07ZDFAjdc68nKKg@mail.gmail.com>
References: <1395839117-20090-1-git-send-email-dh.herrmann@gmail.com>
	<20140328.145410.1817326821928803131.davem@davemloft.net>
	<CANq1E4TxaNnZoqfw5DiifAhk28hVq5HJJMd07ZDFAjdc68nKKg@mail.gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 28 Mar 2014 14:02:24 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Herrmann <dh.herrmann@gmail.com>
Date: Fri, 28 Mar 2014 20:34:47 +0100

> However, as mentioned in the discussions on v1, there're more
> use-cases than that. Imagine a 3rd party initrd renames a
> network-device early, if udev runs in the main system, we would rename
> the device again. If we could detect the rename via NET_NAME_RENAMED,
> we wouldn't break such setups. The only reason to rename devices in
> udev is to get reliable names. If someone else already renamed a
> device, we always expect them to provide better names than we do, so
> udev should only touch devices that have kernel-enumerated names.
> Of course, this can be fixed by requiring all the initrd developers to
> somehow tag devices as already renamed. But this would replicate
> information that the kernel already has.

You want to use the kernel to facilitate communication between two
userland components.

Imagine if we had to do that for everything.

Really, it's not a good reason, sorry.
