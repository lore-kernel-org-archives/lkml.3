Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753365Ab3LBKcR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 05:32:17 -0500
Received: from mail-vb0-f51.google.com ([209.85.212.51]:44220 "EHLO
	mail-vb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753071Ab3LBKcN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 05:32:13 -0500
MIME-Version: 1.0
In-Reply-To: <5292A5EA.1030501@huawei.com>
References: <20131111220626.GA7509@sbohrermbp13-local.rgmadvisors.com>
 <52820030.6000806@huawei.com> <20131112143147.GB6049@dhcp22.suse.cz>
 <20131112155530.GA2860@sbohrermbp13-local.rgmadvisors.com>
 <20131112165504.GF6049@dhcp22.suse.cz> <20131114225649.GA16725@sbohrermbp13-local.rgmadvisors.com>
 <20131115062458.GA9755@mtj.dyndns.org> <20131115075401.GB9755@mtj.dyndns.org>
 <alpine.LNX.2.00.1311171746160.15789@eggly.anvils> <CAJ75kXZYjKwV_XiEB493jNyGRqS395JZyY-S9xQBQJLyaCSOEQ@mail.gmail.com>
 <20131122221839.GD8981@mtj.dyndns.org> <CAJ75kXabrnxqdtb5SXqm_pYTrSih9yvP38DApF+_P+YZCepTMw@mail.gmail.com>
 <5292A5EA.1030501@huawei.com>
From: William Dauchy <wdauchy@gmail.com>
Date: Mon, 2 Dec 2013 11:31:53 +0100
Message-ID: <CAJ75kXYKx67VaGYRs1nwataE2ra216qTB9Yks=MRGFN-c_b3uA@mail.gmail.com>
Subject: Re: 3.10.16 cgroup_mutex deadlock
To: Li Zefan <lizefan@huawei.com>
Cc: Tejun Heo <tj@kernel.org>, Hugh Dickins <hughd@google.com>,
        Shawn Bohrer <shawn.bohrer@gmail.com>, Michal Hocko <mhocko@suse.cz>,
        cgroups@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Markus Blank-Burian <burian@muenster.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Li,

On Mon, Nov 25, 2013 at 2:20 AM, Li Zefan <lizefan@huawei.com> wrote:
> I'll do this after the patch hits mainline, if Tejun doesn't plan to.

Do you have some news about it?
-- 
William
