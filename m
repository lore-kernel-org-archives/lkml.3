Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753633AbaIYPOi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 11:14:38 -0400
Received: from mail-qg0-f42.google.com ([209.85.192.42]:62843 "EHLO
	mail-qg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753106AbaIYPOh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 11:14:37 -0400
Date: Thu, 25 Sep 2014 11:14:33 -0400
From: Tejun Heo <tj@kernel.org>
To: Zefan Li <lizefan@huawei.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Andrey Wagin <avagin@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: cgroup_mount() falls asleep forever
Message-ID: <20140925151433.GA23044@htj.dyndns.org>
References: <CANaxB-ykM+5h4+x5hHK2Z_APpiQLvGvc=2nBR5pGQS=msqp6ZA@mail.gmail.com>
 <CANaxB-zqeJ0mse0J0=aH4uV+yRdgVhmHbAq4Wa8tW-81sNSMJA@mail.gmail.com>
 <20140924185213.GB7996@ZenIV.linux.org.uk>
 <20140924192456.GA1233@mtj.dyndns.org>
 <20140925024719.GJ7996@ZenIV.linux.org.uk>
 <20140925032502.GB6903@mtj.dyndns.org>
 <5423ED2B.8010009@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5423ED2B.8010009@huawei.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 25, 2014 at 06:23:39PM +0800, Zefan Li wrote:
> That patch is wrong. We have to use both pinned_sb and new_sb, so
> please revert it. :(
> 
> I think we need to put some test cases in tools/testing/selftests/, to
> prevent this fragile thing from breaking again.

Can you please send a patch to revert it?  There have been a couple
changes dependent on it.

Thanks.

-- 
tejun
