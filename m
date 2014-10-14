Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932307AbaJNTah (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 15:30:37 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:43879 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754166AbaJNTag (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 15:30:36 -0400
Date: Tue, 14 Oct 2014 15:30:32 -0400 (EDT)
Message-Id: <20141014.153032.1779634723768373525.davem@davemloft.net>
To: nicolas.dichtel@6wind.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ebiederm@xmission.com, akpm@linux-foundation.org, adobriyan@gmail.com,
        rui.xiang@huawei.com, viro@zeniv.linux.org.uk, oleg@redhat.com,
        gorcunov@openvz.org, kirill.shutemov@linux.intel.com,
        grant.likely@secretlab.ca, tytso@mit.edu,
        torvalds@linux-foundation.org
Subject: Re: [PATCH linux v3 1/1] fs/proc: use a rb tree for the directory
 entries
From: David Miller <davem@davemloft.net>
In-Reply-To: <543BB42B.30505@6wind.com>
References: <1412672559-5256-1-git-send-email-nicolas.dichtel@6wind.com>
	<1412672559-5256-2-git-send-email-nicolas.dichtel@6wind.com>
	<543BB42B.30505@6wind.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 14 Oct 2014 12:30:36 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Date: Mon, 13 Oct 2014 13:14:51 +0200

> I'm not sure who is in charge of taking this patch. Should I resend
> it to someone else or is it already included in a tree?

Just want to make it clear that I don't intend to take this via
the networking tree.
