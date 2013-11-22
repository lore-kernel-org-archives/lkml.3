Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756182Ab3KVWzO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 17:55:14 -0500
Received: from mail-vc0-f180.google.com ([209.85.220.180]:62811 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755413Ab3KVWzK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 17:55:10 -0500
MIME-Version: 1.0
In-Reply-To: <20131122221839.GD8981@mtj.dyndns.org>
References: <20131111220626.GA7509@sbohrermbp13-local.rgmadvisors.com>
 <52820030.6000806@huawei.com> <20131112143147.GB6049@dhcp22.suse.cz>
 <20131112155530.GA2860@sbohrermbp13-local.rgmadvisors.com>
 <20131112165504.GF6049@dhcp22.suse.cz> <20131114225649.GA16725@sbohrermbp13-local.rgmadvisors.com>
 <20131115062458.GA9755@mtj.dyndns.org> <20131115075401.GB9755@mtj.dyndns.org>
 <alpine.LNX.2.00.1311171746160.15789@eggly.anvils> <CAJ75kXZYjKwV_XiEB493jNyGRqS395JZyY-S9xQBQJLyaCSOEQ@mail.gmail.com>
 <20131122221839.GD8981@mtj.dyndns.org>
From: William Dauchy <wdauchy@gmail.com>
Date: Fri, 22 Nov 2013 23:54:49 +0100
Message-ID: <CAJ75kXabrnxqdtb5SXqm_pYTrSih9yvP38DApF+_P+YZCepTMw@mail.gmail.com>
Subject: Re: 3.10.16 cgroup_mutex deadlock
To: Tejun Heo <tj@kernel.org>
Cc: Hugh Dickins <hughd@google.com>, Shawn Bohrer <shawn.bohrer@gmail.com>,
        Michal Hocko <mhocko@suse.cz>, Li Zefan <lizefan@huawei.com>,
        cgroups@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Markus Blank-Burian <burian@muenster.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

On Fri, Nov 22, 2013 at 11:18 PM, Tejun Heo <tj@kernel.org> wrote:
> Just applied to cgroup/for-3.13-fixes w/ stable cc'd.  Will push to
> Linus next week.

Thank your for your quick reply. Do you also have a backport for
v3.10.x already available?

Best regards,
-- 
William
